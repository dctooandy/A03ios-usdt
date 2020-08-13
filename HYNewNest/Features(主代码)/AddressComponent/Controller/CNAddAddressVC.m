//
//  CNAddAddressVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddAddressVC.h"
#import "CNNormalInputView.h"
#import "CNCodeInputView.h"
#import "NSString+Validation.h"

@interface CNAddAddressVC () <CNNormalInputViewDelegate, CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderLineCenterX;

@property (weak, nonatomic) IBOutlet CNNormalInputView *platformInputView;
@property (weak, nonatomic) IBOutlet CNNormalInputView *linkInputView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView;
@end

@implementation CNAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加小金库";
    
    if (self.addrType == HYAddressTypeUSDT) {
        [self otherAddress:self.otherBtn];
    } else {
        [self goldAddress:self.goldBtn];
    }
    
    [self setDelegate];
    
    // 验证码须传入手机号
    self.codeInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
    self.codeInputView.codeType = CNCodeTypeBankCard;
}

- (void)configUI {
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            
            break;
            
        case HYAddressTypeDCBOX:
            self.goldBtn.selected = YES;
            self.otherBtn.selected = NO;
            // 小金库
            self.borderLineCenterX.constant = 0;
            [self.platformInputView setPlaceholder:@"请输入币付宝账号"];
            [self.linkInputView setPlaceholder:@"请再次输入金库号"];
            [self.codeInputView setPlaceholder:@"请输入验证码"];
            break;
            
        case HYAddressTypeUSDT:
            self.goldBtn.selected = NO;
            self.otherBtn.selected = YES;
            // 其他地址
            self.borderLineCenterX.constant = kScreenWidth * 0.5;
            [self.platformInputView setPlaceholder:@"请输入平台地址称"];
            [self.linkInputView setPlaceholder:@"请输入或粘贴您的USDT收款链接"];
            [self.codeInputView setPlaceholder:@"请输入验证码"];
            break;
            
        default:
            break;
    }

}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.platformInputView.delegate = self;
    self.linkInputView.delegate = self;
    self.codeInputView.delegate = self;
}

- (void)inputViewTextChange:(CNNormalInputView *)view {
    view.wrongAccout = NO;
    
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            
            break;
        case HYAddressTypeDCBOX:
            if (self.platformInputView == view) {//第一行
                if (![view.text validationType:ValidationTypeUSDTAddress]) {
                    [view showWrongMsg:@"钱包地址是字母数字组合6-80位"];
                }
            } else if (self.linkInputView == view) {//第二行
                if (![self.platformInputView.text isEqualToString:view.text]) {
                    [view showWrongMsg:@"两次地址输入必须一致"];
                }
            }
            break;
        case HYAddressTypeUSDT:
            if (self.linkInputView == view) {
                if (![view.text validationType:ValidationTypeUSDTAddress]) {
                    [view showWrongMsg:@"钱包地址是字母数字组合6-80位"];
                }
            }
            break;
        default:
            break;
    }

    // 按钮可点击条件
    self.submitBtn.enabled = (!self.platformInputView.wrongAccout)
    && (!self.linkInputView.wrongAccout)
    && (self.codeInputView.correct)
    && (self.platformInputView.text.length > 0)
        && (self.linkInputView.text.length > 0)
        && (self.codeInputView.correct);
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    if (![view.code validationType:ValidationTypePhoneCode]) {
        [view showWrongMsg:@"请输入6位数字验证码"];
    } else {
        view.wrongCode = NO;
    }
    
    // 按钮可点击条件
    self.submitBtn.enabled = (!self.platformInputView.wrongAccout)
    && (!self.linkInputView.wrongAccout)
    && (self.codeInputView.correct)
    && (self.platformInputView.text.length > 0)
        && (self.linkInputView.text.length > 0)
        && (self.codeInputView.correct);
}

// 小金库地址
- (IBAction)goldAddress:(UIButton *)sender {
    self.addrType = HYAddressTypeDCBOX;
    [self configUI];
}

// 其他地址
- (IBAction)otherAddress:(UIButton *)sender {
    self.addrType = HYAddressTypeUSDT;
    [self configUI];
}

// 去下载
- (IBAction)submit:(id)sender {
    
    switch (_addrType) {
        case HYAddressTypeBANKCARD:{
            
            break;
        }
            
        case HYAddressTypeDCBOX:{
            [CNWDAccountRequest createAccountDCBoxAccountNo:self.platformInputView.text
                                                   isOneKey:NO
                                                 validateId:self.codeInputView.smsModel.validateId
                                                  messageId:self.codeInputView.smsModel.messageId
                                                    handler:^(id responseObj, NSString *errorMsg) {
                if (KIsEmptyString(errorMsg)) {
                    [CNHUB showSuccess:@"小金库添加成功"];
                    [CNLoginRequest getUserInfoByTokenCompletionHandler:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            break;
        }
            
        case HYAddressTypeUSDT: {
            [CNWDAccountRequest createAccountUSDTAccountNo:self.linkInputView.text
                                                 bankAlias:self.platformInputView.text
                                                validateId:self.codeInputView.smsModel.validateId
                                                 messageId:self.codeInputView.smsModel.messageId
                                                   handler:^(id responseObj, NSString *errorMsg) {
                if (KIsEmptyString(errorMsg)) {
                    [CNHUB showSuccess:@"地址添加成功"];
                    [CNLoginRequest getUserInfoByTokenCompletionHandler:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            break;
        }
            
        default:
            break;
    }
}
@end
