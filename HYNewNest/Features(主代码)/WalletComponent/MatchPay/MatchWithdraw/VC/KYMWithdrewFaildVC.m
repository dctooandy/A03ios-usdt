//
//  KYMWithdrewFaildVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewFaildVC.h"
#import "KYMWidthdrewUtility.h"
#import "KYMSubmitButton.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "MBProgressHUD+Add.h"
@interface KYMWithdrewFaildVC ()

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet KYMSubmitButton *submitBtn;

@end

@implementation KYMWithdrewFaildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.submitBtn.enabled = YES;
    [self.submitBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    self.customerBtn.layer.cornerRadius = 24;
    self.customerBtn.layer.masksToBounds = YES;
    self.customerBtn.layer.borderWidth = 1;
    self.customerBtn.layer.borderColor = [UIColor colorWithRed:0x10 / 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1].CGColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem.action = @selector(goToBack);
    self.navigationItem.leftBarButtonItem.target = self;
}
- (IBAction)submitBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)customerBtnClicked:(id)sender {
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil];
        }
    }];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
