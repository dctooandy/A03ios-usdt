//
//  IN3SManager.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SManager.h"
#import "AFNetworking.h"
#import "IN3SParamsModel.h"
#import "IN3SGlobalModel.h"
#import "IN3SLaunchModel.h"
#import "IN3SPageModel.h"
#import "IN3SAGQJModel.h"
#import "IN3SExitModel.h"
#import "IN3SBrowserModel.h"
#import "IN3SRequestModel.h"
#import "IN3SWebViewController.h"
#import <WebKit/WebKit.h>

@interface IN3SManager()<WKNavigationDelegate>
@property(nonatomic, strong)AFHTTPSessionManager *sessionManager;
@property(nonatomic, assign)CGFloat startLaunchTime;
@property(nonatomic, strong)dispatch_queue_t triggerQueue; //触发事件的队列
@property(nonatomic, copy)NSString *networkType;
@property(nonatomic, strong)UIWindow *webWin; //用于获取webview的uuid
@property(nonatomic, copy)NSArray<NSDictionary<NSString *, Class> *> *allParamsModelClass;  //每添加一个事件类都需要在该数组添加映射
@end
@implementation IN3SManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //每添加一个事件类都需要在该数组添加映射
        _allParamsModelClass = @[@{kConstantEventTypeLaunch : [IN3SLaunchModel class]},
                                 @{kConstantEventTypePage : [IN3SPageModel class]},
                                 @{kConstantEventTypeRequest : [IN3SRequestModel class]},
                                 @{kConstantEventTypeBrowser : [IN3SBrowserModel class]},
                                 @{kConstantEventTypeAGQJ : [IN3SAGQJModel class]},
                                 @{kConstantEventTypeExit : [IN3SExitModel class]},
                                 ];

        _triggerQueue = dispatch_queue_create("IN3SAnalytics.queue.trigger", DISPATCH_QUEUE_SERIAL);
        //先暂停事件保存队列，等待上传完成
        dispatch_suspend(_triggerQueue);
        //监听网络环境
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        //监听网络变化
        __weak typeof(self)weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf networkTypeChangedWithStatus:status];
        }];
        //获取webview的uuid
        if ([NSThread isMainThread]) {
            [self loadGetUUIDWebView];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self loadGetUUIDWebView];
            });
        }
    }
    return self;
}
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static IN3SManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[IN3SManager alloc] init];
        NSString *baseUrl = @"https://3s.sreanalyze.com/api/v1";
        NSURL *url = [NSURL URLWithString:baseUrl];
        _manager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        _manager.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.sessionManager.requestSerializer.timeoutInterval = 20;
        _manager.sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"application/json",@"text/xml",@"text/html",@"text/plain", nil];
    });
    return _manager;
}
- (void)loadGetUUIDWebView
{
    self.webWin = [[UIWindow alloc] initWithFrame:CGRectZero];
    self.webWin.rootViewController = [[IN3SWebViewController alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    webView.navigationDelegate = self;
    [self.webWin addSubview:webView];
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IN3SResource.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (!bundle) {
        [NSException raise:@"配置有误,请在工程中引入IN3SAnalytics.bundle资源文件" format:@""];
    }
    NSString * path = [bundle pathForResource:@"3s" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

// 请求开始前，会先调用此代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    NSLog(@"开始请求页面:%@",absoluteString);
    if ([navigationAction.request.URL.path containsString:@"agqj"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSURLComponents *comp = [NSURLComponents componentsWithString:navigationAction.request.URL.absoluteString];
        for (NSURLQueryItem *item in comp.queryItems) {
            if ([item.name isEqualToString:@"uuid"]) {
                [[NSUserDefaults standardUserDefaults] setValue:item.value forKey:kConstantKeyWebViewUUID];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        webView.navigationDelegate = nil;
//        [webView removeFromSuperview];
        self.webWin.hidden = YES;
        self.webWin = nil;
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)configureSDKWithProduct:(NSString *)product
{
    self.product = product;
    self.startLaunchTime = [[IN3SUtility timestamp] doubleValue];
    [self sendSavedData];
}
- (void)sendSavedData
{
    IN3SGlobalModel *globalModel = nil;
    //如果数据库中保存有全局参数，则用保存的，否则创建新的
    NSArray *globalParamsArray = [IN3SGlobalModel bg_findAll:nil];
    if (globalParamsArray && globalParamsArray.count > 0) {
        globalModel = globalParamsArray.firstObject;
    } else {
        globalModel = [[IN3SGlobalModel alloc] init];
        globalModel.product = self.product;
        globalModel.domain = self.domain;
        globalModel.user = self.userName;
    }
    globalModel.page = [self getCurrentPage];
    
    //获取库中非全局参数
    NSMutableDictionary *dataDict = @{}.mutableCopy;
    for (NSDictionary<NSString *, Class> *dict in _allParamsModelClass) {
        NSString *key = dict.allKeys[0];
        dataDict[key] = [dict[key] arrayOfDictionariesFromModels:[dict[key] bg_findAll:nil]];
    }
    
    //如果库中没有保存的数据，则不上传，并触发事件保存队列
    if (dataDict.count == 0) {
        dispatch_resume(self.triggerQueue);
        return;
    }
    //拼接参数
    NSMutableDictionary *paramDict = @{}.mutableCopy;
    paramDict[@"global"] = globalModel.toDictionary;
    paramDict[@"data"] = dataDict.mutableCopy;
    paramDict[@"time"] = [IN3SUtility timestamp];
    paramDict[@"db"] = self.product;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict.copy options:NSJSONWritingPrettyPrinted error:nil];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    INLog(@"3S上传数据采集参数:%@",jsonString);
    
    NSMutableDictionary *requestDict = @{}.mutableCopy;
    requestDict[@"code"] = base64String;
    __weak typeof(self)weakSelf = self;
 
    [self.sessionManager POST:@"/api/v1/stats/collect" parameters:requestDict.copy progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            INLog(@"3S上传数据采集结果:%@",responseDict);
            NSString *message = [responseDict valueForKey:@"message"];
            if (message && [message isKindOfClass:[NSString class]] && [message isEqualToString:@"OK"]) {
                //数据采集成功,删除数据
                //全局参数不在映射表里，要单独删除
                [IN3SGlobalModel bg_delete:nil where:nil];
                [IN3SGlobalModel bg_delete:nil where:nil];
                for (NSDictionary<NSString *, Class> *dict in strongSelf->_allParamsModelClass) {
                    NSString *key = dict.allKeys[0];
                    [dict[key] bg_delete:nil where:nil];
                }
            }
        } else {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            INLog(@"3S上传数据采集失败:%@",responseStr);
        }
        //触发事件保存队列
        dispatch_resume(weakSelf.triggerQueue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        INLog(@"3S上传数据采集失败:%@",error);
        __strong typeof(weakSelf)strongSelf = weakSelf;
        //触发事件保存队列
        dispatch_resume(strongSelf.triggerQueue);
    }];
}

- (NSString *)product
{
    if (!_product) {
        [NSException raise:@"配置有误,请设置product" format:@""];
    }
    return _product;
}
- (NSString *)domain
{
    if (!_domain) {
        return @"";
    }
    return _domain;
}
- (void)triggerEventWithParameter:(IN3SParamsModel *)parameter timestamp:(NSString *)timestamp
{
    //当用户名或手机站存在时，更新全局参数，保证能获取的用户名和手机站
    if (self.userName.length > 0 || self.domain.length > 0) {
        IN3SGlobalModel *globalModel = [[IN3SGlobalModel alloc] init];
        globalModel.product = self.product;
        globalModel.domain = self.domain;
        globalModel.user = self.userName;
        globalModel.page = @"";
        [globalModel bg_saveOrUpdate];
    }
    
    parameter.page = parameter.page ? : [self getCurrentPage];
    NSString *time = [NSString stringWithFormat:@"%.3lf",[timestamp doubleValue]];
    parameter.time = timestamp ? time : [IN3SUtility timestamp];
    
    INLog(@"3S数据采集:事件:%@,参数:%@",parameter.eventKey,parameter.toDictionary);
    
    //一类事件最多保存最近20条记录
    NSInteger savedCount = [[parameter class] bg_count:nil where:nil];

    NSInteger limitCount = 20;
    if (savedCount >= limitCount) {
        NSString* where = [NSString stringWithFormat:@"limit %d",savedCount - (limitCount - 1)];
        [[parameter class] bg_delete:nil where:where];
    }
    __weak typeof(self)weakSelf = self;
    //所有事件在串行队列中保存入库，且每次App启动在上传未完成前该队列处理暂停等待状态。
    dispatch_async(self.triggerQueue, ^{
        if (IN3SAnalyticsEventLaunch == parameter.eventType) {
            ((IN3SLaunchModel *)parameter).network = weakSelf.networkType;
        }
        [parameter bg_saveOrUpdate];
    });
}
- (void)launchFinished
{
    CGFloat currentTime = [[IN3SUtility timestamp] doubleValue];
    CGFloat durationTime = currentTime - self.startLaunchTime;
    NSString *timestamp = [NSString stringWithFormat:@"%f", self.startLaunchTime];
    IN3SLaunchModel *model = [[IN3SLaunchModel alloc] init];
    model.init_time = durationTime * 1000;
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (void)exitApp:(NSString *)timestamp
{
    IN3SExitModel *model = [[IN3SExitModel alloc] init];
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (void)enterPageWithName:(NSString *)pageName responseTime:(double)resTime timestamp:(NSString *)timestamp
{
    IN3SPageModel *model = [[IN3SPageModel alloc] init];
    model.page = pageName;
    model.rsptime = resTime;
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (void)loadWebViewWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    IN3SBrowserModel *model = [[IN3SBrowserModel alloc] init];
    model.url = url;
    model.rsptime = resTime;
    model.rspcode = resCode;
    model.msg = msg;
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (void)requestWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    IN3SRequestModel *model = [[IN3SRequestModel alloc] init];
    model.url = url;
    model.rsptime = resTime;
    model.rspcode = resCode;
    model.msg = msg;
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (void)loadAGQJWithResponseTime:(double)resTime isPreload:(BOOL)isPreload isFinishedPreload:(BOOL)isFinishedPreload msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    IN3SAGQJModel *model = [[IN3SAGQJModel alloc] init];
    model.preload = isPreload;
    model.rsptime = resTime;
    model.load_finish = false;
    model.msg = msg;
    [self triggerEventWithParameter:model timestamp:timestamp];
}
- (NSString *)getCurrentPage
{
    __block UIViewController *currentVC = nil;
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            currentVC = [IN3SUtility currentViewController];
        });
    } else {
        currentVC = [IN3SUtility currentViewController];
    }
    if (currentVC && [currentVC isKindOfClass:[UIViewController class]]) {
        return NSStringFromClass([currentVC class]);
    }
    return @"";
}
- (void)networkTypeChangedWithStatus:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.networkType = @"wifi";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.networkType = @"4G";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            self.networkType = @"disconnect";
            break;
        default:
            self.networkType = @"unkown";
            break;
    }
}
@end
