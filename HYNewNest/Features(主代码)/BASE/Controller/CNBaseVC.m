//
//  CNBaseVC.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseVC.h"

@interface CNBaseVC ()

@end

@implementation CNBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addNaviRightItemWithImageName:(NSString *)name {
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

- (void)rightItemAction {}

- (void)openH5Page:(NSString *)h5url title:(nonnull NSString *)title {

}

- (void)dealloc {
    NSLog(@"@%s销毁了%@", __func__, NSStringFromClass([self class]));
}
@end
