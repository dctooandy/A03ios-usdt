//
//  ABCOneKeyRegisterBFBHelper.m
//  HYGEntire
//
//  Created by zaky on 18/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "ABCOneKeyRegisterBFBHelper.h"
#import "HYTextAlertView.h"
#import "GTMBase64.h"

#import "CNLoginRequest.h"
#import "CNWDAccountRequest.h"
#import "CNVerifyMsgAlertView.h"

@interface ABCOneKeyRegisterBFBHelper ()
@property (nonatomic, copy) AddBFBBlock addBFBBlock;
@property (strong,nonatomic) SmsCodeModel *phoneModel;
@property (copy,nonatomic) NSString *accountNo; //!<创建的账号ID
@property (weak,nonatomic) CNVerifyMsgAlertView *alertView;
@end

@implementation ABCOneKeyRegisterBFBHelper

static ABCOneKeyRegisterBFBHelper *_instance;
static dispatch_once_t onceToken;
+(id)shareInstance{
      dispatch_once(&onceToken, ^{
      if(_instance == nil)
          _instance = [[ABCOneKeyRegisterBFBHelper alloc] init];
    });
     return _instance;
}

+(void)attempDealloc{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
        MyLog(@"【ABCOneKeyRegisterBFBHelper XXOO】");
        onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
        _instance = nil;
    });
}

/// 一键注册
- (void)startOneKeyRegisterBFBHandler:(AddBFBBlock)addBFBBlock {
    __block NSString *phone = [CNUserManager shareManager].userDetail.mobileNo;
    [HYTextAlertView showWithTitle:@"授权许可" content:[NSString stringWithFormat:@"小金库申请获得您在平台绑定的手机号：%@，仅用于账号注册，小金库承诺会保护您的账户隐私，不会向任何平台提供您的信息。", phone] comfirmText:@"确认授权" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
        if (!isComfirm) {
            return;
        }
        
        CNVerifyMsgAlertView *alertView = [CNVerifyMsgAlertView showPhone:phone reSendCode:^{
            [self sendVerifyCode:nil];
                
        } finish:^(NSString * _Nonnull smsCode) {
            [self createBitollAccountSuccessHandler:^{
                [self bindBitollAccount:self.accountNo messageId:self.phoneModel.messageId smsCode:smsCode handler:^{
                    if (addBFBBlock) {
                        addBFBBlock();
                        [ABCOneKeyRegisterBFBHelper attempDealloc];
                        [CNVerifyMsgAlertView removeAlertView];
                    }
                }];
            }];
        }];
        self.alertView = alertView;
    }];

    
}

/// 发送验证码
- (void)sendVerifyCode:(nullable void(^)(void))successHandler {
    [CNLoginRequest getSMSCodeByLoginNameType:CNSMSCodeTypeChangeBank completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            SmsCodeModel *smsModel = [SmsCodeModel cn_parse:responseObj];
            self.phoneModel = smsModel;
            if (successHandler) {
                successHandler();
            }
        }
    }];
}

/// 创建小金库
- (void)createBitollAccountSuccessHandler:(void(^)(void))successHandler {
    if (!self.phoneModel) {
        [kKeywindow jk_makeToast:@"请点击发送验证码" duration:3 position:JKToastPositionCenter];
        return;
    }
    [CNWDAccountRequest createGoldAccountHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *b64AccountNo = responseObj[@"accountNo"];
            self.accountNo = [GTMBase64 decodeBase64String:b64AccountNo];
            if (successHandler) {
                successHandler();
            }
        }
//        else {
//            if ([errorMsg isEqualToString:@"验证码输入错误"]) {
//                [CNHUB showError:@"验证码输入错误 请重新发送"];
//                [self.alertView resetCodeView];
//            }
//        }
    }];

}


// 绑定创建的小金库账户
- (void)bindBitollAccount:(NSString *)accountNo messageId:(NSString *)messageId smsCode:(NSString *)smsCode handler:(void(^)(void))successHandler {
    [CNWDAccountRequest createAccountDCBoxAccountNo:self.accountNo isOneKey:YES validateId:nil messageId:messageId smsCode:smsCode handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            // 绑定成功
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil];
            [CNTOPHUB showSuccess:[NSString stringWithFormat:@"金库号 %@ 绑定成功", accountNo]];
            if (successHandler) {
                successHandler();
            }
        } else {
//            [CNHUB showError:@"系统错误 绑定失败"];
            [ABCOneKeyRegisterBFBHelper attempDealloc];
        }
    }];

}

@end
