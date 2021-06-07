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
#import <IVLoganAnalysis/IVLAManager.h>
#import "CNCompleteInfoVC.h"
#import "CNBindPhoneVC.h"
#import "HYDownloadLinkView.h"
#import "ABCOneKeyRegisterBFBHelper.h"
#import "CNWithdrawRequest.h"
#import "HYTextAlertView.h"

@interface CNAddAddressVC () <CNNormalInputViewDelegate, CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderLineCenterX;

@property (weak, nonatomic) IBOutlet UIButton *btomTipsTitle;
@property (weak, nonatomic) IBOutlet UILabel *btomTipsLb;
@property (weak, nonatomic) IBOutlet CNNormalInputView *platformInputView;
@property (weak, nonatomic) IBOutlet CNNormalInputView *linkInputView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView;

@property (strong,nonatomic) HYDownloadLinkView *linkView;
@end

@implementation CNAddAddressVC

- (HYDownloadLinkView *)linkView {
    if (!_linkView) {
        HYDownloadLinkView *linkView = [[HYDownloadLinkView alloc] initWithFrame:CGRectMake(90, self.codeInputView.bottom, 200, 30) normalText:@"还没有小金库账号？" tapableText:@"一键注册" tapColor:kHexColor(0x10B4DD) hasUnderLine:NO urlValue:nil];
        linkView.tapBlock = ^{
            [[ABCOneKeyRegisterBFBHelper shareInstance] startOneKeyRegisterBFBHandler:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        };
        [self.view addSubview:linkView];
        _linkView = linkView;
    }
    return _linkView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addrType == HYAddressTypeUSDT) {
        [self otherAddress:self.otherBtn];
    } else {
        [self goldAddress:self.goldBtn];
    }
    
    [CNWithdrawRequest getUserMobileStatusCompletionHandler:^(id responseObj, NSString *errorMsg) {
    }];
    [self setDelegate];
}

- (void)viewWillAppear:(BOOL)animated {
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYTextAlertView showWithTitle:@"手机绑定" content:@"对不起！系统发现您还没有绑定手机，请先完成手机绑定流程，再进行添加地址操作。" comfirmText:@"确定" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm) {
            if (isComfirm) {
                CNBindPhoneVC *vc = [CNBindPhoneVC new];
                vc.bindType = CNSMSCodeTypeBindPhone;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    } else {
        // 验证码须传入手机号
        self.codeInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
        self.codeInputView.codeType = CNCodeTypeBankCard;
    }
}

- (void)configUI {
    self.linkView.hidden = YES;
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            
            break;
            
        case HYAddressTypeDCBOX: {
            self.goldBtn.selected = YES;
            self.otherBtn.selected = NO;
            self.title = @"添加小金库";
            // 小金库
            self.borderLineCenterX.constant = 0;
            [self.platformInputView setPlaceholder:@"请输入您的小金库钱包账号"];
            [self.linkInputView setPlaceholder:@"请再次输入金库号"];
            [self.codeInputView setPlaceholder:@"请输入验证码"];
            [self.submitBtn setTitle:@"添加小金库钱包" forState:UIControlStateNormal];
            self.btomTipsTitle.hidden = YES;
            self.btomTipsLb.hidden = YES;
            self.linkView.hidden = NO;
            
            break;
        }
            
        case HYAddressTypeUSDT:
            self.goldBtn.selected = NO;
            self.otherBtn.selected = YES;
            self.title = @"添加USDT地址";
            // 其他地址
            self.borderLineCenterX.constant = kScreenWidth * 0.5;
            [self.platformInputView setPlaceholder:@"请输入平台地址名称"];
            [self.linkInputView setPlaceholder:@"请输入或粘贴钱包地址"];
            [self.codeInputView setPlaceholder:@"请输入验证码"];
            [self.submitBtn setTitle:@"添加USDT钱包" forState:UIControlStateNormal];
            self.btomTipsTitle.hidden = NO;
            self.btomTipsLb.hidden = NO;
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
//    if (![view.code validationType:ValidationTypePhoneCode]) {
//        [view showWrongMsg:@"请输入6位数字验证码"];
//    } else {
//        view.wrongCode = NO;
//    }
    
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
                                                    smsCode:nil
                                                    handler:^(id responseObj, NSString *errorMsg) {
                if (!errorMsg) {
                    [CNTOPHUB showSuccess:@"小金库添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [IVLAManager singleEventId:@"A03_bankcard_update"];
                    });
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
                if (!errorMsg) {
                    [CNTOPHUB showSuccess:@"地址添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [IVLAManager singleEventId:@"A03_bankcard_update"];
                    });
                }
            }];
            break;
        }
            
        default:
            break;
    }
}
@end
