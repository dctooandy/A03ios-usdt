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
#import "HYWideOneBtnAlertView.h"
#import "BYBindRealNameVC.h"
#import "HYTextAlertView.h"

@interface CNSecurityCenterVC ()
@property (weak, nonatomic) IBOutlet CNBaseTF *phoneTF;
@property (weak, nonatomic) IBOutlet CNBaseTF *weixinTF;
@property (weak, nonatomic) IBOutlet CNBaseTF *emailTF;
@property (weak, nonatomic) IBOutlet CNBaseTF *realNameTF;

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
    CNUserDetailModel *userDetail = [CNUserManager shareManager].userDetail;
    NSString *phone = userDetail.mobileNo;
    self.phoneTF.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    self.weixinTF.text = userDetail.onlineMessenger2;
    self.realNameTF.text = userDetail.realName;
    self.emailTF.text = userDetail.email;
}

// 修改手机号
- (IBAction)changePhoneNum:(id)sender {
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYTextAlertView showWithTitle:@"手机绑定" content:@"对不起！系统发现您还没有绑定手机，请先完成手机绑定流程，再进行添加地址操作。" comfirmText:@"确定" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm) {
            if (isComfirm) {
                [BYModifyPhoneVC modalVcWithSMSCodeType:CNSMSCodeTypeBindPhone];
            }
        }];
        
    } else {
        [BYModifyPhoneVC modalVcWithSMSCodeType:(self.phoneTF.text.length > 0 ? CNSMSCodeTypeUnbind : CNSMSCodeTypeBindPhone)];
    }
//    [BYModifyPhoneVC modalVcWithSMSCodeType:(self.phoneTF.text.length > 0 ? CNSMSCodeTypeUnbind : CNSMSCodeTypeBindPhone)];
}

// 修改密码
- (IBAction)changePWD:(id)sender {
    [CNChangePwdVC modalVc];
}

// 修改资金密码
- (IBAction)changeFundPWD:(id)sender {
    [BYChangeFundPwdVC modalVc];
}

- (IBAction)showBindView:(UIButton *)sender {
    
        WEAKSELF_DEFINE
        MineBindView *bind = [[MineBindView alloc] initWithBindType:sender.tag?HYBindTypeEMail: HYBindTypeWechat comfirmBlock:^(NSString * _Nonnull text) {
            STRONGSELF_DEFINE
            [strongSelf submitBindAccount:text isEMail:sender.tag];
        }];
        [self.view addSubview:bind];
    
}

- (IBAction)bindRealNameClicked:(id)sender {
    [BYBindRealNameVC modalVCBindRealName];
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
