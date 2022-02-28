//
//  CNMDepositBaseVC.m
//  HYNewNest
//
//  Created by cean on 2/26/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNMDepositBaseVC.h"

@interface CNMDepositBaseVC ()

@end

@implementation CNMDepositBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kHexColor(0x10101C);
}

- (void)showLoading {
    [LoadingView showLoadingViewWithToView:nil needMask:YES];
}

- (void)hideLoading {
    [LoadingView hideLoadingViewForView:nil];
}

- (void)showError:(NSString *)msg {
    [CNTOPHUB showError:msg];
}

- (void)showSuccess:(NSString *)msg {
    [CNTOPHUB showSuccess:msg];
}

@end
