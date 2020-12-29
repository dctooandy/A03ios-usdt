//
//  BYRegisterSuccADVC.m
//  HYNewNest
//
//  Created by zaky on 12/29/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYRegisterSuccADVC.h"

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
    [self.navigationController popToRootViewControllerAnimated:NO];
    [NNPageRouter jump2BuyECoin];
}

- (IBAction)didTapGo2SellCoin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
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
