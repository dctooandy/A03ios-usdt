//
//  TopTabAGUltimateView.h
//  HYGEntire
//
//  Created by zaky on 04/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopTabAGUltimateView : UIView

@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) NSString *webUrl;
@property (assign, nonatomic) BOOL isLandScape;
@property (copy  , nonatomic) void(^landScapeStateChange)(BOOL isLandScape);
-(void)loadWebViewWithURL:(NSString*)webUrl;
-(void)reloadFirstPage;
@end

NS_ASSUME_NONNULL_END
