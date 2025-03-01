//
//  GameStartPlayViewController.m
//  HyEntireGame
//
//  Created by kunlun on 2018/9/27.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "GameStartPlayViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <WebKit/WebKit.h>
#import "LoadingView.h"
#import "GameModel.h"
#import <IN3SAnalytics/CNTimeLog.h>

#define POST_JS @"function my_post(path, params) {\
var method = \"GET\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"



@interface GameStartPlayViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate>

@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) NSString *gameUrl;
@property (strong,nonatomic) NSString *gameName;
@property(nonatomic,strong) UIProgressView *progressView;

@end

@implementation GameStartPlayViewController

- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (instancetype)initGameWithGameUrl:(NSString *)gameUrl title:(NSString *)title{
    self = [super init];
    if(self) {
        self.gameName = title;
        if ([gameUrl containsString:@"http"]) {
            NSString *agwebUrl = [NSString stringWithFormat:@"%@&webApp=%@",gameUrl,@"true"];
            self.gameUrl = [agwebUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            self.gameUrl = gameUrl;
        }
        
        if ([self isAGQJGame] == true) {
            [CNTimeLog startRecordTime:CNEventAGQJLaunch];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self popGestureClose];

    if ([self.gameUrl containsString:@"callbackUrl"] && ![self.gameName isEqualToString:@"AS真人棋牌"]) {
        if ([self.gameUrl containsString:@"gameType=MOON"] ||
            [self.gameUrl containsString:@"gameType=STAI"] ||
            [self.gameUrl containsString:@"gameType=HILO"] ||
            [self.gameUrl containsString:@"gameType=DICE"] ||
            [self.gameUrl containsString:@"gameType=PLIN"] )
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.navigationItem.title = self.gameName;
            [self addNaviRightItemWithImageName:@"shuaxin"];
        }else
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title = self.gameName;
        [self addNaviRightItemWithImageName:@"shuaxin"];
    }
}

- (void)rightItemAction {
    [self refresh];
}

- (void)refresh{
    if ([self isAGQJGame] == true) {
        [CNTimeLog AGQJReLoad];
    }
    
    [self.webView reload];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self popGestureOpen];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isAGQJGame] == true) {
        [CNTimeLog AGQJFirstLoad];
    }

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways ];
  
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //不允许默认的全屏播放视频 真人视讯
    config.allowsInlineMediaPlayback = YES;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.allowsBackForwardNavigationGestures = true;
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [self.webView evaluateJavaScript:@"window.navigator.userAgent;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"UA: Error == %@", error.localizedDescription);
            return;;
        }
        self.webView.customUserAgent = [NSString stringWithFormat:@"%@ app_version=%@ great-winner Safari",result,appVersion];
        
    }];
    [self.view addSubview:self.webView];
    
    WEAKSELF_DEFINE
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONGSELF_DEFINE
        if ([strongSelf.gameUrl containsString:@"callbackUrl"] && ![self.gameName isEqualToString:@"AS真人棋牌"]) {
            if ([self.gameUrl containsString:@"gameType=MOON"] ||
                [self.gameUrl containsString:@"gameType=STAI"] ||
                [self.gameUrl containsString:@"gameType=HILO"] ||
                [self.gameUrl containsString:@"gameType=DICE"] ||
                [self.gameUrl containsString:@"gameType=PLIN"] )
            {
                make.top.equalTo(strongSelf.view);
            }else
            {
                make.top.equalTo(strongSelf.view).mas_offset(kStatusBarHeight);
            }
        } else {
            make.top.equalTo(strongSelf.view);
        }
        
        make.left.right.equalTo(strongSelf.view);
        make.bottom.equalTo(strongSelf.view).mas_offset(-kSafeAreaHeight);
    }];
    
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    //进度条
    [self.webView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.tintColor = kHexColor(0x02EED9);
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONGSELF_DEFINE
        make.left.right.equalTo(strongSelf.webView);
        make.top.equalTo(strongSelf.webView);
        make.height.mas_equalTo(2);
    }];

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.gameUrl]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDYDeviceOrientationDidChange)
                         name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
  
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        MyLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.hidden = NO;
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
//    if ([message.name isEqualToString:@"AppModel"]) {
//        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
//        // NSDictionary, and NSNull类型
//        DLog(@"%@", message.body);
//    }
    
    if ([message.name isEqualToString:@"h5ClickBackNav"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
     MyLog(@"log---->didStartProvisionalNavigation %@ \n",[webView.URL absoluteString]);
    

      NSString *absoluteString = webView.URL.absoluteString;
        
      if ([absoluteString containsString:@"getticketfailed"]) {
          [CNTOPHUB showError:@"获取票据失败"];
      }
      
      if ([absoluteString containsString:@"landscape.html"] ||
          [absoluteString containsString:@"sensor.html"]) {
          
      }
      if ([absoluteString containsString:@"aggameh5/game.html"] && [self isAGQJGame] == true) { //进入AGQJ
          [CNTimeLog endRecordTime:CNEventAGQJLaunch];
      }
      if ([absoluteString containsString:@"disconnect.html"]) {
          [webView reload];
      }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    MyLog(@"didFinishNavigation \n")
    [self viewDidLayoutSubviews];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    MyLog(@"didFailProvisionalNavigation \n")
    [CNTOPHUB showError:@"游戏加载失败"];
}


#pragma mark - WKNavigationDelegate

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    MyLog(@"url :\n%@",navigationAction.request.URL.absoluteString);
    
//    if ([navigationAction.request.URL.absoluteString isEqualToString:@"http://www.hygame03.com/"]
//        || [navigationAction.request.URL.absoluteString isEqualToString:@"http://m2.hwx22.com/"]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    
    //ag 游戏的返回检测
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([urlStr hasPrefix:@"https://localhost/exit.html"] || [urlStr hasPrefix:@"https://localhost/disconnect.html"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
        [self.navigationController popViewControllerAnimated:YES];
        
        NSArray *paths = [urlStr componentsSeparatedByString:@"?"];
        if (paths.count > 1) {
            if ([(NSString *)paths[1] containsString:@"method=rg"]) {
                // 去注册
                [NNPageRouter jump2Register];
            }
        }
        
        return;
    }
    
    //ag彩票里 返回 "http://localhost/disconnect.html" 通知app已断线，需要重新加载游戏
    if ([urlStr hasPrefix:@"https://localhost/disconnect.html"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self refresh];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
    
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    MyLog(@"decidePolicyForNavigationResponse --> %@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
     
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    //  js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];

    [self presentViewController:alertController animated:YES completion:^{}];
 
}



#pragma mark - 屏幕旋转

//必须返回YES
- (BOOL)shouldAutorotate{
    if ([self.gameName isEqualToString:@"彩票"] || [self.gameName isEqualToString:@"AS真人棋牌"]) {
        return NO;
    } else {
        return YES;
    }
}


 - (BOOL)onDYDeviceOrientationDidChange{
     if ([self.gameName isEqualToString:@"彩票"] || [self.gameName isEqualToString:@"AS真人棋牌"]) {
         return NO;
     }
     
     //获取当前设备Device
     UIDevice *device = [UIDevice currentDevice];
     if (device.orientation==UIDeviceOrientationLandscapeLeft || device.orientation==UIDeviceOrientationLandscapeRight) {

         if (device.orientation==UIDeviceOrientationLandscapeLeft) {
             [self setInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
         }else if (device.orientation==UIDeviceOrientationLandscapeRight){
             [self setInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
         }
         // 旋转改变约束
         [self.navigationController setNavigationBarHidden:YES animated:YES];
         
         [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.left.right.bottom.equalTo(self.view);
         }];

     }else if(device.orientation==UIDeviceOrientationPortrait){
          [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
         // 竖直复原约束
         WEAKSELF_DEFINE
         if ([self.gameUrl containsString:@"callbackUrl"] && ![self.gameName isEqualToString:@"AS真人棋牌"]) {
//             self.hideNavgation = YES;
             if ([self.gameUrl containsString:@"gameType=MOON"] ||
                 [self.gameUrl containsString:@"gameType=STAI"] ||
                 [self.gameUrl containsString:@"gameType=HILO"] ||
                 [self.gameUrl containsString:@"gameType=DICE"] ||
                 [self.gameUrl containsString:@"gameType=PLIN"] )
             {
                 [self.navigationController setNavigationBarHidden:NO animated:YES];
                 self.navigationItem.title = self.gameName;
                 [self addNaviRightItemWithImageName:@"shuaxin"];
             }else
             {
                 [self.navigationController setNavigationBarHidden:YES animated:YES];
             }
         } else {
//             self.hideNavgation = NO;
             [self.navigationController setNavigationBarHidden:NO animated:YES];
             self.navigationItem.title = self.gameName;
             [self addNaviRightItemWithImageName:@"shuaxin"];
         }
         
         [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
             STRONGSELF_DEFINE
             if ([strongSelf.gameUrl containsString:@"callbackUrl"] && ![self.gameName isEqualToString:@"AS真人棋牌"]) {
                 make.top.equalTo(strongSelf.view).mas_offset(kStatusBarHeight);
             } else {
                 make.top.equalTo(strongSelf.view);
             }
             make.left.right.equalTo(strongSelf.view);
             make.bottom.equalTo(strongSelf.view).mas_offset(-kSafeAreaHeight);
         }];
      }

    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Custom Method
- (BOOL)isAGQJGame {
    return [self.gameName isEqualToString:@"百家乐-旗舰厅"];
}

@end
