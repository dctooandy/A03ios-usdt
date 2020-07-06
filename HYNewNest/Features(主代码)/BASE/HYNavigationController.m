//
//  HYNavigationController.m
//  HYGEntire
//
//  Created by zaky on 11/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "HYNavigationController.h"

@interface HYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (self.viewControllers.count <= 1 ) {
      return NO;
  }
  return YES;
}

// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}

//禁止响应手势的是否ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
   return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.topViewController isKindOfClass:viewController.class]) {
        return;
    }
    //当存在子控制器时才隐藏tabBar
    if (self.viewControllers.count>0) {
//        [(HYTabBarViewController *)[HYGPageRouter currentTabBarController] hideSuspendBall];
//        self.interactivePopGestureRecognizer.enabled = NO;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //  push入栈
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

    //判断即将到栈底
    if (self.viewControllers.count == 0) {
       
    }
    //pop出栈
    return [super popViewControllerAnimated:animated];
}

+ (HYNavigationController *)navigationControllerWithController:(Class)controller tabBarTitle:(NSString *)tabBarTitle normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage{
    UIViewController *vc = [[controller alloc] init];;
    
    UITabBarItem *item = [[UITabBarItem alloc]
                          initWithTitle:tabBarTitle
                          image:normalImage
                          selectedImage:selectedImage];

    item.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    item.titlePositionAdjustment = UIOffsetMake(0, 0);
    item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    vc.tabBarItem = item;
    vc.tabBarItem.title = tabBarTitle;
    //vc.title = tabBarTitle;

    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor darkTextColor]}];

    nav.navigationBar.translucent = YES;
    
    return nav;
}

#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
