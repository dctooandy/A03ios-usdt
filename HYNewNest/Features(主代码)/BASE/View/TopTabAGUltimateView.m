//
//  TopTabAGUltimateView.m
//  HYGEntire
//
//  Created by zaky on 04/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "TopTabAGUltimateView.h"
#import "HYHTMLViewController.h"
#import "HYInGameHelper.h"
#import "BYSuperCopartnerVC.h"

@interface TopTabAGUltimateView()<WKNavigationDelegate, WKUIDelegate> //WKScriptMessageHandler  要加协议

@property (strong, nonatomic) WKWebViewConfiguration *webConfig;

@property (strong, nonatomic) UIProgressView *progressView;
@property (assign, nonatomic) CGFloat scale;

@end

@implementation TopTabAGUltimateView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scale = 1.516;
        [self setupView];
    }
    return self;
}

- (void)setupView{
   
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
    _wkWebView.scrollView.scrollEnabled = YES;
    _wkWebView.opaque = NO;
    _wkWebView.backgroundColor = [UIColor clearColor];
    [self addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self);
        //make.bottom.equalTo(self).offset(STATUS_HEIGHT + 30);
    }];
   
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    self.wkWebView.scrollView.bounces = true;
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    
    //进度条
    [self.wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.wkWebView addObserver:self
    forKeyPath:@"title"
       options:NSKeyValueObservingOptionNew
       context:nil];
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.tintColor = kHexColor(0x02EED9);
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.wkWebView);
        make.height.mas_equalTo(2);
    }];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        MyLog(@"progress: %f", self.wkWebView.estimatedProgress);
        self.progressView.hidden = NO;
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else if([keyPath isEqualToString:@"title"]){
        UIViewController *currentVC = [NNControllerHelper getCurrentViewController];
        currentVC.navigationItem.title = self.wkWebView.title;
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    
    /*
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
     */
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    MyLog(@"log---->didStartProvisionalNavigation %@ \n",[webView.URL absoluteString]);
    NSString *absoluteString = webView.URL.absoluteString;
    
    // 百家乐大师赛
    if ([absoluteString containsString:@"hy://agqj"]) {
        [[HYInGameHelper sharedInstance] inGame:InGameTypeAGQJ];
    }
    
    if ([absoluteString containsString:@"landscape.html"] ||
        [absoluteString containsString:@"sensor.html"]) {
        //说明进桌了
        self.isLandScape = YES;
        if (self.landScapeStateChange) {
            self.landScapeStateChange(YES);
        }
    }
//    if ([absoluteString containsString:@"portrait.html"]) {
//        //说明进AG旗舰大厅了
//        self.isLandScape = NO;
//        if (self.landScapeStateChange) {
//            self.landScapeStateChange(NO);
//        }
//        [[CNTimeLog shareInstance] endRecordTime:CNEventAGQJLaunch];
//    }
    
    if ([absoluteString containsString:@"disconnect.html"]) {
        //说明失去连接了
        self.isLandScape = NO;
        if (self.landScapeStateChange) {
            self.landScapeStateChange(NO);
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    MyLog(@"decidePolicyForNavigationAction ===> \n%@", url);
    
    if ([url hasPrefix:@"hy://login"]){
        //登录
        decisionHandler(WKNavigationActionPolicyCancel);
        [self loginClick];
        
    }else if ([url hasPrefix:@"hy://regist"]){
        //注册
        decisionHandler(WKNavigationActionPolicyCancel);
        [self registerClick];
        
//    }else if ([url hasPrefix:@"hy://share"]){
        //分享
//        [ShareListPopView show];
        
    }else if ([url hasPrefix:@"hy://kefu"]){
        //客服
        decisionHandler(WKNavigationActionPolicyCancel);
        [self kefu];
        
    }else if ([url hasPrefix:@"hy://main"]){
        //主页
        decisionHandler(WKNavigationActionPolicyCancel);
        [kCurNavVC popToRootViewControllerAnimated:YES];
        [NNControllerHelper currentTabBarController].selectedIndex = 0;
        
    }else if ([url hasPrefix:@"hy://withdraw"]){
        //提现
        decisionHandler(WKNavigationActionPolicyCancel);
        [self wdrawClick];
        
    }else if ([url hasPrefix:@"hy://depositInfo"]) {
        // 买币指南
        decisionHandler(WKNavigationActionPolicyCancel);
        [NNPageRouter jump2BuyECoin];
    
    }else if ([url hasPrefix:@"hy://deposit"]){
        //充值
        decisionHandler(WKNavigationActionPolicyCancel);
        [self rechargeClick];
        
    }else if ([url hasPrefix:@"hy://agqj"]){
        //AG旗舰
        [self btnAGqjClick];
        
//    }else if ([url hasPrefix:@"hy://score"]){
        //积分兑换
//        IntegralViewController *vc = [[IntegralViewController alloc] init];
//        UIViewController *topVC = [UIViewController topViewController];
//        [topVC.navigationController pushViewController:vc animated:YES];
        
//    }else if ([url hasPrefix:@"hy://settings/info"]){
        //个人资料
//        PersonInfoViewController *vc = [[PersonInfoViewController alloc] init];
//        UIViewController *topVC = [UIViewController topViewController];
//        [topVC.navigationController pushViewController:vc animated:YES];
        
//    }else if ([url hasPrefix:@"hy://videogame"]){
        //电子游戏
//        DYViewController *vc = [[DYViewController alloc] init];
//        UIViewController *topVC = [UIViewController topViewController];
//        [topVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([url containsString:@"/share?"]) {
        //好友推荐
        decisionHandler(WKNavigationActionPolicyCancel);
        [kCurNavVC popToRootViewControllerAnimated:NO];
        [kCurNavVC pushViewController:[BYSuperCopartnerVC new] animated:YES];
        
    }else if ([url containsString:@"/vip?"]) {
        //vip
        decisionHandler(WKNavigationActionPolicyCancel);
        [kCurNavVC popToRootViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NNControllerHelper currentTabBarController].selectedIndex = 1;
        });
        
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/**
 打开一个新页面时调用
 */
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    MyLog(@"外部打开一个新页面:%@ ",navigationAction.request.URL.absoluteString);
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
        return nil;
    }
    
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    if ([absoluteString containsString:@"forwardPage.do"]) {
        if ([absoluteString containsString:@"method=dp"]) {
            
            //充值
            if (self.landScapeStateChange) {
                self.landScapeStateChange(NO);
            }
//            RechargeViewController *vc = [[RechargeViewController alloc] init];
//            UIViewController *topVC = [UIViewController topViewController];
//            [topVC.navigationController pushViewController:vc animated:YES];
           
        } else if ([absoluteString containsString:@"method=wd"]) {
            
            //取款
            if (self.landScapeStateChange) {
                self.landScapeStateChange(NO);
            }
            [self wdrawClick];
            
        } else if ([absoluteString containsString:@"method=pcs"] || [absoluteString containsString:@"method=cs"]) {
             
            //在线客服
            if (self.landScapeStateChange) {
                self.landScapeStateChange(NO);
            }
            [self kefu];
            
        } else if ([absoluteString containsString:@"method=rg"]) {
            
            //开户
           
        } else if ([absoluteString containsString:@"method=pm"]) {
            
            //优惠
           
        } else if ([absoluteString containsString:@"method=fu"]) {
            
            //论坛
            
        } else if ([absoluteString containsString:@"method=et"]) {
            
            //退出游戏
            
        }
    } else {
        //游戏内打开二级页面，如BBIN
        //IVNormalWKWebViewController *vc = [[IVNormalWKWebViewController alloc] initWithRequest:navigationAction.request];
        //[self.navigationController pushViewController:vc animated:YES];
    }
    return nil;
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    MyLog(@"--zq--function- %s  %@",__func__ ,navigationResponse.response.URL.absoluteString);
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

#pragma mark GET SET
- (WKWebViewConfiguration *)webConfig {
    if(!_webConfig){
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.preferences = [[WKPreferences alloc] init];
       //_webConfig.preferences.minimumFontSize = 10;
        _webConfig.preferences.javaScriptEnabled = YES;
       //_webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        _webConfig.allowsInlineMediaPlayback = YES;
        _webConfig.mediaTypesRequiringUserActionForPlayback = YES;
        //在iOS上默认为NO，表示不能自动通过窗口打开
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webConfig.processPool = [[WKProcessPool alloc] init];
        
        
//        _webConfig.userContentController = [[WKUserContentController alloc] init];
        //禁止长按弹出 UIMenuController 相关
        //禁止选择 css 配置相关
        NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        //css 选中样式取消
        NSMutableString*javascript = [NSMutableString string];
        [javascript appendString:@"var style = document.createElement('style');"];
        [javascript appendString:@"style.type = 'text/css';"];
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
        [javascript appendString:@"style.appendChild(cssContent);"];
        [javascript appendString:@"document.body.appendChild(style);"];
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        //javascript 注入
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript
                                                                injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                             forMainFrameOnly:YES];
        WKUserContentController*userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:noneSelectScript];
        WKWebViewConfiguration*configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        _webConfig.userContentController = userContentController;

    }
    return _webConfig;
}

-(void)loadWebViewWithURL:(NSString*)webUrl{
    if ([webUrl containsString:@"http"]) {
        NSString *agwebUrl = [NSString stringWithFormat:@"%@&webApp=%@",webUrl,@"true"];
        _webUrl = [agwebUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }
}

- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}

//注册
- (void)registerClick{
    [NNPageRouter jump2Register];
}

//登录
- (void)loginClick{
    [NNPageRouter jump2Login];
}

//提现
- (void)wdrawClick{
    [NNPageRouter jump2Withdraw];
}

- (void)rechargeClick {
    [NNPageRouter jump2Deposit];
}

//AG游戏
- (void)btnAGqjClick{
    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGQJ];
}

//联系客服
- (void)kefu{
    [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
}

- (void)reloadFirstPage {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}


@end
