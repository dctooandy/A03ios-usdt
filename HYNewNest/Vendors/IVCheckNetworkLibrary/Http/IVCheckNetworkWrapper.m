//
//  IVCheckNetworkWrapper.m
//  IVCheckNetworkLibrary
//
//  Created by Key on 25/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVCheckNetworkWrapper.h"
#import "IVCheckRequest.h"
#import "IVCheckGatewayRequest.h"
#import "IVHttpManager.h"
#import "KLDNetPing.h"
#import "GCDAsyncSocket.h"
#include <netdb.h>
#include <arpa/inet.h>
#import "IVLAManager.h"
NSString * const kCheckTypeNameKey        = @"typeName";
NSString * const kCheckUrlKey             = @"url";
NSString * const kCheckTimeKey            = @"time";
NSString * const kCheckLogKey             = @"com.IVCheckNetwork.log";
NSString * const kIVCNetworkStatusKey     = @"com.IVCheckNetwork.networkStatusKey";
NSString * const kEnterBackgroundTime     = @"com.IVCheckNetwork.enterBackgroundTime";
NSTimeInterval const kCheckMiniTime       = 10.0; //最短检测时间间隔

NSNotificationName const IVGetOptimizeGatewayNotification     = @"IVGetOptimizeGatewayNotification";
NSNotificationName const IVGetOptimizeGCNotification           = @"IVGetOptimizeGCNotification";
NSNotificationName const IVGetOptimizeDomainNotification       = @"IVGetOptimizeDomainNotification";
NSNotificationName const IVNetworkStatusChangedNotification    = @"IVNetworkStatusChangedNotification";


@interface IVCheckNetworkWrapper ()<KLDNetPingDelegate,GCDAsyncSocketDelegate>
@property (nonatomic ,copy) void (^pingCompletion)(void);
@property (nonatomic ,copy) void (^socketCompletion)(void);
@property (nonatomic ,copy) void (^printLogBlock)(NSString *);
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@end
static IVCheckNetworkWrapper *wrapper;
static NSMutableDictionary *checkedUrlDict;
@implementation IVCheckNetworkWrapper
{
    BOOL _isInit;
}
__attribute__((constructor)) static void EntryPoint()
{
    wrapper = [[IVCheckNetworkWrapper alloc] init];
    checkedUrlDict = @{}.mutableCopy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isInit = YES;
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
            [[NSUserDefaults standardUserDefaults] setDouble:time forKey:kEnterBackgroundTime];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
            NSTimeInterval enterBackgroundTime = [[NSUserDefaults standardUserDefaults] doubleForKey:kEnterBackgroundTime];
            //退到后台再进入前台大于5分钟
            if ((currentTime - enterBackgroundTime) / 1000.0 > 5 * 60) {
                [IVCheckNetworkWrapper didEnterBackgroundLongTimeOrNetworkStatusChanged];
            }
        }];
        //监听网络环境
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        //监听网络变化
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (!self->_isInit) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IVNetworkStatusChangedNotification object:nil userInfo:@{kIVCNetworkStatusKey : @(status)}];
                //获取最优手机站域名和网关，第一次启动及网络断开时不调用
                if (status != AFNetworkReachabilityStatusNotReachable) {
                    [IVCheckNetworkWrapper didEnterBackgroundLongTimeOrNetworkStatusChanged];
                }
            }
            self->_isInit = NO;
            
        }];
    }
    return self;
}

+ (void)didEnterBackgroundLongTimeOrNetworkStatusChanged
{
    NSArray *gateways = [IVHttpManager shareManager].gateways;
    NSArray *domains = [IVHttpManager shareManager].domains;
    if (gateways && gateways.count > 0) {
        [self getOptimizeUrlWithArray:gateways isAuto:YES type:IVKCheckNetworkTypeGateway progress:nil completion:nil];
    }
    if (domains && domains.count > 0) {
        [self getOptimizeUrlWithArray:domains isAuto:YES type:IVKCheckNetworkTypeDomain progress:nil completion:nil];
    }
}
+ (void)getOptimizeUrlWithArray:(NSArray<NSString *> *)array isAuto:(BOOL)isAuto type:(IVKCheckNetworkType)type progress:(nullable void (^)(IVCheckDetailModel *respone))progress completion:(nullable void (^)(IVCheckDetailModel *model))completion
{
    if (!array || ![array isKindOfClass:[NSArray class]] || array.count == 0) {
        completion(nil);
        return;
    }
    for (NSString *url in array) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        if ([checkedUrlDict valueForKey:url]) {
            NSTimeInterval lastTime = [[checkedUrlDict valueForKey:url] doubleValue];
            if (currentTime - lastTime < kCheckMiniTime) {
                return;
            }
        }
        [checkedUrlDict setValue:@(currentTime) forKey:url];
    }
    __weak typeof(self)weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray<IVCheckDetailModel *> *resultArray = [NSMutableArray<IVCheckDetailModel *> array];
     for (NSInteger i = 0 ; i < array.count; i++) {
         dispatch_group_enter(group);
         [self startCheckWithUrl:array[i] isAuto:isAuto type:type completion:^(NSTimeInterval time) {
             IVCheckDetailModel *model = [[IVCheckDetailModel alloc] init];
             model.index = i;
             model.url = array[i];
             model.time = time;
             model.type = type;
             model.title = [NSString stringWithFormat:@"线路%@:",@(i + 1)];
             [resultArray addObject:model];
             if (progress) {
                 progress(model);
             }
             dispatch_group_leave(group);
         }];
     }
    //所有的域名检查完成
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        //如果没有检查成功的域名
        if (resultArray.count <= 0) {
            [strongSelf switchMainQueueWithCompletion:completion model:nil];
            return;
        }
        //如果只有一个
        if (resultArray.count == 1) {
            [strongSelf switchMainQueueWithCompletion:completion model:resultArray[0]];
            return;
        }
        IVCheckDetailModel *minTimeModel = resultArray[0];
        IVCheckDetailModel *lastModel = resultArray[0];
        for (int i = 0; i < resultArray.count; i++) {
            IVCheckDetailModel *model = resultArray[i];
            if (i > 0) {
                lastModel = resultArray[i - 1];
                if (model.time < lastModel.time) {
                    minTimeModel = model;
                }
            }
        }
        [strongSelf switchMainQueueWithCompletion:completion model:minTimeModel];
    });
}
+ (void)getOptimizeUrlSynWithArray:(NSArray<NSString *> *)array isAuto:(BOOL)isAuto type:(IVKCheckNetworkType)type progress:(nullable void (^)(IVCheckDetailModel *respone))progress completion:(nullable void (^)(IVCheckDetailModel *model))completion
{
    if (!array || ![array isKindOfClass:[NSArray class]] || array.count == 0) {
        completion(nil);
        return;
    }
    NSString *listTitle = nil;
    switch (type) {
        case IVKCheckNetworkTypeDomain:
            listTitle = @"domain list";
            break;
        case IVKCheckNetworkTypeGateway:
            listTitle = @"gateway list";
            break;
        case  IVKCheckNetworkTypeGameDomian:
            listTitle = @"game domain list";
            break;
        default:
            listTitle = @"";
            break;
    }
    [self writeCheckLog:[NSString stringWithFormat:@"start check %@ health...",listTitle] isAuto:NO];
    [self writeCheckLog:[NSString stringWithFormat:@"%@...",listTitle] isAuto:NO];
    [self writeCheckLog:@"------------------------" isAuto:NO];
    for (NSString *url in array) {
        NSString *str = [NSURL URLWithString:url].host;
        [self writeCheckLog:[self replaceSecurityUrl:str] isAuto:NO];
    }
    [self writeCheckLog:@"------------------------" isAuto:NO];
    
    __weak typeof(self)weakSelf = self;
   
    NSMutableArray<IVCheckDetailModel *> *resultArray = [NSMutableArray<IVCheckDetailModel *> array];
    __block NSInteger index = 0;
    __block NSString *url = array[0];
    [self checkSynWithUrl:url index:index array:array resultArray:resultArray type:type progress:progress completion:^{
        [self writeCheckLog:[NSString stringWithFormat:@"%@ health check done",listTitle] isAuto:NO];
        [self writeCheckLog:@"========================" isAuto:NO];
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        //所有的域名检查完成
        //如果没有检查成功的域名
        if (resultArray.count <= 0) {
            [strongSelf switchMainQueueWithCompletion:completion model:nil];
            return;
        }
        //如果只有一个
        if (resultArray.count == 1) {
            [strongSelf switchMainQueueWithCompletion:completion model:resultArray[0]];
            return;
        }
        IVCheckDetailModel *minTimeModel = resultArray[0];
        IVCheckDetailModel *lastModel = resultArray[0];
        for (int i = 0; i < resultArray.count; i++) {
            IVCheckDetailModel *model = resultArray[i];
            if (i > 0) {
                lastModel = resultArray[i - 1];
                if (model.time < lastModel.time) {
                    minTimeModel = model;
                }
            }
        }
        [strongSelf switchMainQueueWithCompletion:completion model:minTimeModel];
    }];
}
+ (void)checkSynWithUrl:(NSString *)url index:(NSInteger)index array:(NSArray<NSString *> *)array resultArray:(NSMutableArray *)resultArray type:(IVKCheckNetworkType)type progress:(nullable void (^)(IVCheckDetailModel *respone))progress completion:(nullable void (^)(void))completion
{
    [self startCheckWithUrl:url isAuto:NO type:type completion:^(NSTimeInterval time) {
        IVCheckDetailModel *model = [[IVCheckDetailModel alloc] init];
        model.index = index;
        model.url = url;
        model.time = time;
        model.type = type;
        model.title = [NSString stringWithFormat:@"线路%@:",@(index + 1)];
        [resultArray addObject:model];
        if (progress) {
            progress(model);
        }
        if (index < array.count - 1) {
            [self checkSynWithUrl:array[index+1] index:index+1 array:array resultArray:resultArray type:type progress:progress completion:completion];
        } else {
            if (completion) {
                completion();
            }
        }
    }];
}
+ (void)switchMainQueueWithCompletion:(nullable void (^)(IVCheckDetailModel *respone))completion model:(IVCheckDetailModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            if (model.time < 100000) {
                completion(model);
            } else {
                completion(nil);
            }
        }
        if (model.time > 100000) {
            return;
        }
        switch (model.type) {
            case IVKCheckNetworkTypeGateway:
                [[NSNotificationCenter defaultCenter] postNotificationName:IVGetOptimizeGatewayNotification object:nil userInfo:@{kCheckUrlKey : model.url}];
                [IVHttpManager shareManager].gateway = model.url;
                break;
            case IVKCheckNetworkTypeGameDomian:
                [[NSNotificationCenter defaultCenter] postNotificationName:IVGetOptimizeGCNotification object:nil userInfo:@{kCheckUrlKey : model.url}];
                [IVHttpManager shareManager].gameDomain = model.url;
                break;
            case IVKCheckNetworkTypeDomain:
                [[NSNotificationCenter defaultCenter] postNotificationName:IVGetOptimizeDomainNotification object:nil userInfo:@{kCheckUrlKey : model.url}];
                [IVHttpManager shareManager].domain = model.url;
                break;
            default:
                break;
        }
    });
}
+ (void)startCheckWithUrl:(NSString *)url isAuto:(BOOL)isAuto type:(IVKCheckNetworkType)type completion:(nullable void (^)(NSTimeInterval time))completion
{
    NSString *typeName = nil;
    NSString *subUrl = @"version.txt";
    KYHTTPManager *request = [IVCheckRequest manager];
    ((IVCheckRequest *)request).url = url;
    switch (type) {
        case IVKCheckNetworkTypeGateway:
            typeName = @"gateway";
            subUrl = @"/health";
            request = [IVCheckGatewayRequest manager];
            ((IVCheckGatewayRequest *)request).url = url;
            break;
        case IVKCheckNetworkTypeGameDomian:
            typeName = @"game domain";
            break;
        case IVKCheckNetworkTypeDomain:
            typeName = @"domain";
            break;
        default:
            typeName = [NSString stringWithFormat:@"other%@",@(type)];
            break;
    }
    
    NSString *secUrl = [self replaceSecurityUrl:[NSURL URLWithString:url].host];
    NSString *startLog = [NSString stringWithFormat:@" %@->\n%@",typeName,secUrl];
    [self writeCheckLog:startLog isAuto:isAuto];
    [self writeCheckLog:@"<--->" isAuto:isAuto];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    __block NSString *errInfo = nil;
    [request sendRequestWithUrl:subUrl callBack:^(id  _Nullable response, NSError * _Nullable error) {
        BOOL isSuccess = NO;
        if (!error) {
            if (type == IVKCheckNetworkTypeGateway) {
                IVJResponseObject *obj = (IVJResponseObject *)response;
                if ([obj.body boolValue]) {
                    isSuccess = YES;
                } else {
                    errInfo = [NSString stringWithFormat:@"errCode:%@",obj.head.errCode];
                }
            } else if ([response isKindOfClass:[NSString class]]) {
                NSString *responseStr = response;
                if ([responseStr containsString:@"version"]) {
                    isSuccess = YES;
                } else {
                    errInfo = [NSString stringWithFormat:@"errCode:%d",10000];
                }
            }
        } else {
            errInfo = [NSString stringWithFormat:@"errCode:%ld",error.code];
        }
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSTimeInterval durationTime = endTime - startTime;
        NSString *log = [NSString stringWithFormat:@"time->:%.lfms",durationTime];
        NSString *log1 = @"";
        if (isSuccess) {
            log1 = @"true";
        } else {
            durationTime = 1000000;
            log1 = @"false";
        }
        [self writeCheckLog:log isAuto:isAuto];
        [self writeCheckLog:@"<--->" isAuto:isAuto];
        if (errInfo) {
            [self writeCheckLog:errInfo isAuto:isAuto];
        }
        [self writeCheckLog:log1 isAuto:isAuto];
        [self writeCheckLog:@"---------------" isAuto:isAuto];
        if (completion) {
            completion(durationTime);
        }
    }];;
}
+ (void)checkTripartiteDomainWithCompletion:(void (^)(void))completion
{
    [self writeCheckLog:@"start check baidu url..." isAuto:NO];
    IVCheckRequest *request = [IVCheckRequest manager];
    request.url = @"http://www.baidu.com";
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    [request sendRequestWithUrl:@"" callBack:^(id  _Nullable response, NSError * _Nullable error) {
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSTimeInterval durationTime = endTime - startTime;
        NSString *log = [NSString stringWithFormat:@"baidu time->:%.lfms",durationTime];
        NSInteger errCode = 200;
        if (error) {
            errCode = error.code;
        }
        [self writeCheckLog:[NSString stringWithFormat:@"baidu code = %ld",errCode] isAuto:NO];
        [self writeCheckLog:log isAuto:NO];
        [self writeCheckLog:@"baidu check done" isAuto:NO];
        [self writeCheckLog:@"========================" isAuto:NO];
        completion();
    }];
}
+ (void)startPingGatewayWithCompletion:(void(^)(void))completion
{
    [self writeCheckLog:@"start ping gateway..." isAuto:NO];
    NSString *gateway = [IVHttpManager shareManager].gateways[0];
    NSInteger index = 0;
    [self startPingWithUrl:gateway index:index completion:completion];
}
+ (void)startPingWithUrl:(NSString *)url index:(NSInteger)index completion:(void (^)(void))completion
{
    [wrapper pingWithUrl:url completion:^{
        [self writeCheckLog:@"---------------" isAuto:NO];
        if (index < [IVHttpManager shareManager].gateways.count - 1) {
            NSString *gateway = [IVHttpManager shareManager].gateways[index + 1];
            [self startPingWithUrl:gateway index:index + 1 completion:completion];
        } else {
            [self writeCheckLog:@"ping gateway done." isAuto:NO];
            [self writeCheckLog:@"========================" isAuto:NO];
            completion();
        }
    }];
}
- (void)pingWithUrl:(NSString *)url completion:(void (^)(void))completion
{
    NSString *host = [NSURL URLWithString:url].host;
    NSString *str = [NSString stringWithFormat:@"ping gateway->%@",[IVCheckNetworkWrapper replaceSecurityUrl:host]];
    [IVCheckNetworkWrapper writeCheckLog:str isAuto:NO];
    self.pingCompletion = completion;
    KLDNetPing *netPing = [[KLDNetPing alloc] init];
    netPing.delegate = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [netPing runWithHostName:host normalPing:YES];
    });
}
+ (void)startConnectGatewaySocketWithCompletion:(void(^)(void))completion
{
    [self writeCheckLog:@"start check socket..." isAuto:NO];
    NSString *gateway = [IVHttpManager shareManager].gateways[0];
    NSInteger index = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startConnectSocketWithUrl:gateway index:index completion:completion];
    });
}
+ (void)startConnectSocketWithUrl:(NSString *)url index:(NSInteger)index completion:(void(^)(void))completion
{
    NSString *host = [NSURL URLWithString:url].host;
    [self connectSocketWithHost:host completion:^{
        [self writeCheckLog:@"---------------" isAuto:NO];
        if (index < [IVHttpManager shareManager].gateways.count - 1) {
            NSString *gateway = [IVHttpManager shareManager].gateways[index + 1];
            [self startConnectSocketWithUrl:gateway index:index + 1 completion:completion];
        } else {
            [self writeCheckLog:@"socket check done." isAuto:NO];
            [self writeCheckLog:@"========================" isAuto:NO];
            completion();
        }
    }];
}
+ (void)connectSocketWithHost:(NSString *)host completion:(void(^)(void))completion
{
    wrapper.socketCompletion = completion;
    NSString *ip = [self getIPWithHostName:host];
    NSString *securiteIp = nil;
    if (ip && ip.length > 4) {
        NSRange range = NSMakeRange(1, ip.length - 3);
        securiteIp = [NSString stringWithFormat:@"*%@*",[ip substringWithRange:range]];
    }
    NSString *log = [NSString stringWithFormat:@"gateway %@ ip-->%@",[self replaceSecurityUrl:host],securiteIp];
    [self writeCheckLog:log isAuto:NO];
    [self writeCheckLog:[NSString stringWithFormat:@"check socket %@",securiteIp] isAuto:NO];
    NSError *error = nil;
    BOOL yet = [wrapper.clientSocket connectToHost:ip onPort:80 viaInterface:nil withTimeout:-1 error:&error];
    if (error || !yet) {
        [IVCheckNetworkWrapper writeCheckLog:@"socket connect failed" isAuto:NO];
        completion();
        [wrapper.clientSocket disconnect];
    }
}
///根据域名获取ip地址 - 可以用于控制APP的开关某一个入口，比接口方式速度快的多
+ (NSString*)getIPWithHostName:(const NSString*)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(hostN);
    } @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    if (phot == NULL) {
        return nil;
    }
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0}; inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}
+ (void)startHttpRequestGatewayWithCompletion:(void(^)(void))completion
{
    [self writeCheckLog:@"start check nginx..." isAuto:NO];
    NSString *gateway = [IVHttpManager shareManager].gateways[0];
    [self startHttpRequestWithUrl:gateway index:0 completion:completion];
}
+ (void)startHttpRequestWithUrl:(NSString *)url index:(NSInteger)index completion:(void(^)(void))completion
{
    [self httpRequestWithUrl:url completion:^{
        if (index < [IVHttpManager shareManager].gateways.count - 1) {
            [self writeCheckLog:@"---------------" isAuto:NO];
            NSString *gateway = [IVHttpManager shareManager].gateways[index + 1];
            [self startHttpRequestWithUrl:gateway index:index + 1 completion:completion];
        } else {
            [self writeCheckLog:@"check nginx done." isAuto:NO];
            [self writeCheckLog:@"========================" isAuto:NO];
            completion();
        }
    }];
    
    
}
+ (void)httpRequestWithUrl:(NSString *)url completion:(void(^)(void))completion
{
    NSString *host = [NSURL URLWithString:url].host;
    NSString *log = [NSString stringWithFormat:@"check nginx-->%@",[self replaceSecurityUrl:host]];
    [self writeCheckLog:log isAuto:NO];
    IVCheckRequest *request = [IVCheckRequest new];
    request.url = url;
    [request sendRequestWithUrl:@"" callBack:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSString *log = [NSString stringWithFormat:@"check nginx fail-->code:%ld",error.code];
            [self writeCheckLog:log isAuto:NO];
            NSString *log1 = [NSString stringWithFormat:@"check nginx fail-->errInfo:%@",[error.userInfo valueForKey:@"NSLocalizedDescription"]];
            [self writeCheckLog:log1 isAuto:NO];
        } else {
            NSString *log = [NSString stringWithFormat:@"check nginx success-->code:%d",200];
            [self writeCheckLog:log isAuto:NO];
        }
        completion();
    }];
}
+ (void)startCheckGatewayStatusWithCompletion:(void(^)(void))completion
{
    [self writeCheckLog:@"start gateway statusCode..." isAuto:NO];
    NSString *gateway = [IVHttpManager shareManager].gateways[0];
    [self startCheckGatewayStatusWithUrl:gateway index:0 completion:completion];
}
+ (void)startCheckGatewayStatusWithUrl:(NSString *)url index:(NSInteger)index completion:(void(^)(void))completion
{
    [self checkGatewayStatusWithUrl:url completion:^{
        if (index < [IVHttpManager shareManager].gateways.count - 1) {
            [self writeCheckLog:@"---------------" isAuto:NO];
            NSString *gateway = [IVHttpManager shareManager].gateways[index + 1];
            [self startCheckGatewayStatusWithUrl:gateway index:index + 1 completion:completion];
        } else {
            [self writeCheckLog:@"check gateway statusCode done." isAuto:NO];
            [self writeCheckLog:@"========================" isAuto:NO];
            completion();
        }
    }];
}
+ (void)checkGatewayStatusWithUrl:(NSString *)url completion:(void(^)(void))completion
{
    NSString *host = [NSURL URLWithString:url].host;
    NSString *log = [NSString stringWithFormat:@"check gateway statusCode-->%@",[self replaceSecurityUrl:host]];
    [self writeCheckLog:log isAuto:NO];
    IVCheckRequest *request = [IVCheckRequest new];
    request.url = [NSString stringWithFormat:@"http://%@/",host];
    [request sendRequestWithUrl:@"domain_status/" callBack:^(NSString *  _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSString *log = [NSString stringWithFormat:@"check gateway statusCode fail-->code:%ld",error.code];
            [self writeCheckLog:log isAuto:NO];
            NSString *log1 = [NSString stringWithFormat:@"check gateway statusCode fail-->errInfo:%@",[error.userInfo valueForKey:@"NSLocalizedDescription"]];
            [self writeCheckLog:log1 isAuto:NO];
        } else {
            NSString *log = nil;
            if ([response containsString:@"b5c615b3a0208062f7eadeaa4f05adf0"]) {
                log = [NSString stringWithFormat:@"check gateway statusCode success-->code:%d",200];
            } else {
                log = [NSString stringWithFormat:@"check gateway statusCode fail-->code:%d",30000];
            }
            [self writeCheckLog:log isAuto:NO];
        }
        completion();
    }];
}
#pragma mark -----------------------结束ping回调----------------------------------------
- (void)appendPingLog:(NSString *)pingLog {
    [IVCheckNetworkWrapper writeCheckLog:pingLog isAuto:NO];
    if ([pingLog containsString:@"create failed"]) {
        self.pingCompletion();
    }
}
- (void)netPingDidEnd
{
    self.pingCompletion();
}
#pragma mark -----------------------socket回调----------------------------------------
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [IVCheckNetworkWrapper writeCheckLog:@"socket connect successed" isAuto:NO];
    [sock disconnect];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.socketCompletion();
}
+ (void)sendCheckLog
{
    NSString *allLog = [[NSUserDefaults standardUserDefaults] valueForKey:kCheckLogKey];
    
    [IVLAManager checkNetworkWithEventId:@"i3XAg_gateway" data:@{@"content" : allLog}];
}
//安全处理
+ (NSString *)replaceSecurityUrl:(NSString *)url
{
    if (url.length == 0) {
        return nil;
    }
    NSString *urlStr = url;
//    if ([IVNetwork productId]) {
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:[[IVNetwork productId] lowercaseString] withString:@""];
//    }
    int index1 = arc4random() % urlStr.length;
    int index2 = 0;
    for (; ;) {
        index2 = arc4random() % urlStr.length;
        if (index1 != index2) {
            break;
        }
    }
    urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(index1, 1) withString:@"*"];
    urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(index2, 1) withString:@"*"];
    return urlStr;
}

+ (void)writeCheckLog:(NSString *)log isAuto:(BOOL)isAuto
{
    if (isAuto) {
        return;
    }
    wrapper.printLogBlock(log);
    NSString *allLog = [[NSUserDefaults standardUserDefaults] valueForKey:kCheckLogKey];
    allLog = allLog ? : @"";
    allLog = [NSString stringWithFormat:@"%@\n%@",allLog,log];
    [[NSUserDefaults standardUserDefaults] setValue:allLog forKey:kCheckLogKey];
}
+ (void)setPrintLogBlock:(void (^)(NSString * log))printLogBlock
{
    wrapper.printLogBlock = printLogBlock;
}
@end
