//
//  CNBaseVC.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseVC.h"
#import "UIViewController+Extension.h"

@interface CNBaseVC ()
@end

@implementation CNBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kHexColor(0x10101C);
}

-(void)addNaviLeftItemNil{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *norImage = [UIImage imageNamed:@""];
    UIImage *heiImage = [UIImage imageNamed:@""];
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:heiImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    
    UIView *barButtonView = [[UIView alloc] initWithFrame:button.bounds];
    [barButtonView addSubview:button];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)addNaviRightItemWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor skin_colorWithHex:@"0xFFFFFF"];
    button.titleLabel.font = [UIFont fontPFR15];
    [button addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIView *cuntomView = [[UIView alloc] initWithFrame:button.bounds];
    [cuntomView addSubview:button];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cuntomView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addNaviRightItemWithImageName:(NSString *)name{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIView *cuntomView = [[UIView alloc] initWithFrame:button.bounds];
    [cuntomView addSubview:button];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cuntomView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemAction {
    
}

- (void)openH5Page:(NSString *)h5url title:(nonnull NSString *)title {

}

- (void)dealloc {
    NSLog(@"@%s销毁了%@", __func__, NSStringFromClass([self class]));
}


#pragma mark - 控制屏幕旋转方法
//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

////由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}



#pragma mark - STATUSBAR

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([CNSkinManager currSkinType] == SKinTypeBlack) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}




@end
