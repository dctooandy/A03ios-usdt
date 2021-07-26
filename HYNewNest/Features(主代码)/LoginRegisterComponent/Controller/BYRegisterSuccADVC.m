//
//  BYRegisterSuccADVC.m
//  HYNewNest
//
//  Created by zaky on 12/29/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYRegisterSuccADVC.h"
#import "HYNewCTZNViewController.h"

@interface BYRegisterSuccADVC ()

@end

@implementation BYRegisterSuccADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hideNavgation = YES;
}

- (IBAction)didTapGoAround:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didTapGo2BuyCoin:(id)sender {
    //移除指南
//    if ([CNUserManager shareManager].isUsdtMode && [CNUserManager shareManager].userInfo.starLevel == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
//        HYNewCTZNViewController *vc = [HYNewCTZNViewController new];
//        vc.type = 0;
//        [self presentViewController:vc animated:YES completion:nil];
//        return;
//    }
    [NNPageRouter jump2BuyECoin];
}

- (IBAction)didTapGo2SellCoin:(id)sender {
    //移除指南
//    if ([CNUserManager shareManager].isUsdtMode && [CNUserManager shareManager].userInfo.starLevel == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
//        HYNewCTZNViewController *vc = [HYNewCTZNViewController new];
//        vc.type = 1;
//        [self presentViewController:vc animated:YES completion:nil];
//        return;
//    }
    [NNPageRouter jump2Deposit];
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
