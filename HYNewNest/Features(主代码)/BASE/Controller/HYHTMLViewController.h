//
//  HYHTMLViewController.h
//  HYGEntire
//
//  Created by zaky on 26/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "CNBaseVC.h"
#import "TopTabAGUltimateView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYHTMLViewController : CNBaseVC

@property (strong,nonatomic) TopTabAGUltimateView *topTabAgUlView;

- (instancetype)initWithTitle:(NSString *)webTitle strUrl:(NSString *)strUrl;
@property (nonatomic, copy) void(^backBlock)(void);
@end

NS_ASSUME_NONNULL_END
