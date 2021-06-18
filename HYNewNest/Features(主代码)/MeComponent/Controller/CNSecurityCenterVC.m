//
//  CNSecurityCenterVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNSecurityCenterVC.h"
#import "CNForgotCodeVC.h"
#import "CNChangePwdVC.h"
#import "CNBaseTF.h"
#import "MineBindView.h"
#import "CNUserCenterRequest.h"
#import "BYChangeFundPwdVC.h"
#import "BYModifyPhoneVC.h"

@interface CNSecurityCenterVC ()
@property (weak, nonatomic) IBOutlet CNBaseTF *phoneTF;
@property (weak, nonatomic) IBOutlet CNBaseTF *weixinTF;
@property (weak, nonatomic) IBOutlet CNBaseTF *emailTF;

@end

@implementation CNSecurityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安全中心";
    [self getUserProfile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProfile) name:BYDidUpdateUserProfileNoti object:nil];
}

- (void)getUserProfile {
    [LoadingView show];
    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
        [LoadingView hide];
        [self updateData];
    }];
}

- (void)updateData {
    NSString *phone = [CNUserManager shareManager].userDetail.mobileNo;
    self.phoneTF.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    self.weixinTF.text = [CNUserManager shareManager].userDetail.onlineMessenger2;
    self.emailTF.text = [CNUserManager shareManager].userDetail.email;
}

// 修改手机号
- (IBAction)changePhoneNum:(id)sender {
    [BYModifyPhoneVC modalVcWithSMSCodeType:(self.phoneTF.text.length > 0 ? CNSMSCodeTypeUnbind : CNSMSCodeTypeBindPhone)];
}

// 修改密码
- (IBAction)changePWD:(id)sender {
    [CNChangePwdVC modalVc];
}

// 修改资金密码
- (IBAction)changeFundPWD:(id)sender {
    BYChangeFundPwdVC *vc = [BYChangeFundPwdVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showBindView:(UIButton *)sender {
    WEAKSELF_DEFINE
    MineBindView *bind = [[MineBindView alloc] initWithBindType:sender.tag?HYBindTypeEMail: HYBindTypeWechat comfirmBlock:^(NSString * _Nonnull text) {
        STRONGSELF_DEFINE
        [strongSelf submitBindAccount:text isEMail:sender.tag];
    }];
    [self.view addSubview:bind];
}

- (void)submitBindAccount:(NSString *)account isEMail:(BOOL)isEMail {
    [CNUserCenterRequest modifyUserRealName:nil
                                     gender:nil
                                      birth:nil
                                     avatar:nil
                           onlineMessenger2:isEMail?nil:account
                                      email:isEMail?account:nil
                                    handler:^(id responseObj, NSString *errorMsg) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateData];
        });
    }];
}



@end
