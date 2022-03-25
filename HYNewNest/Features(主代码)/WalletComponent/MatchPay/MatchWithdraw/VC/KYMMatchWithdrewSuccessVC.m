//
//  KYMWithdrewFaildVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMMatchWithdrewSuccessVC.h"
#import "KYMWidthdrewUtility.h"
#import "KYMSubmitButton.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "MBProgressHUD+Add.h"
#import "CNMAlertView.h"
#import "KYMWithdrewRequest.h"
@interface KYMMatchWithdrewSuccessVC ()

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *notifyLB;

@end

@implementation KYMMatchWithdrewSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.submitBtn.enabled = YES;
    self.customerBtn.layer.cornerRadius = 24;
    self.customerBtn.layer.masksToBounds = YES;
    self.customerBtn.layer.borderWidth = 1;
    self.customerBtn.layer.borderColor = [UIColor colorWithRed:0x10 / 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1].CGColor;
    self.notifyLB.text = [NSString stringWithFormat:@"您将获得%0.2lf元取款礼金，24小时到账",[self.amountStr doubleValue]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem.action = @selector(goToBack);
    self.navigationItem.leftBarButtonItem.target = self;
}
- (IBAction)submitBtnClicked:(id)sender {
    [self confirmGetMathWithdraw];
}
- (IBAction)customerBtnClicked:(id)sender {
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil];
        }
    }];
}
- (IBAction)goBackUserCenter:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)confirmGetMathWithdraw
{
    __weak typeof(self)weakSelf = self;
    [CNMAlertView showAlertTitle:@"温馨提示" content:@"老板！请您再次确认是否到账" desc:nil needRigthTopClose:YES commitTitle:@"没有到账" commitAction:^{
        [weakSelf noConfirmGetMathWithdraw];
    } cancelTitle:@"确认到账" cancelAction:^{
        [KYMWithdrewRequest checkReceiveStats:NO transactionId:weakSelf.transactionId callBack:^(BOOL status, NSString *msg) {
            if (status) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:msg toView:nil];
            }
        }];
    }];
    
}
- (void)noConfirmGetMathWithdraw
{
    [KYMWithdrewRequest checkReceiveStats:YES transactionId:self.transactionId callBack:^(BOOL status, NSString *msg) {
        if (status) {
            [self customerBtnClicked:nil];
        } else {
            [MBProgressHUD showError:msg toView:nil];
        }
    }];
}
- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
