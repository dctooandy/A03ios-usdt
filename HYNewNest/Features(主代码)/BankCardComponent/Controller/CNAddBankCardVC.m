//
//  CNAddBankCardVC.m
//  HYNewNest
//
//  Created by Cean on 2020/8/11.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddBankCardVC.h"
#import "CNNormalInputView.h"
#import "BRPickerView.h"
#import "NSString+Validation.h"
#import "CNBankVerifySmsView.h"
#import "CNCompleteInfoVC.h"
#import "CNWDAccountRequest.h"
#import "CNLoginRequest.h"
#import "CNCompleteInfoVC.h"
#import "NSURL+HYLink.h"
#import <UIImageView+WebCache.h>
#import <IVLoganAnalysis/IVLAManager.h>

@interface CNAddBankCardVC () <CNNormalInputViewDelegate>
/// 账户名
@property (weak, nonatomic) IBOutlet CNNormalInputView *accountView;
/// 卡号
@property (weak, nonatomic) IBOutlet CNNormalInputView *cardView;
/// 银行卡logo
@property (weak, nonatomic) IBOutlet UIImageView *cardIcon;
/// 银行卡logo宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIconW;
/// 银行卡logo 尾部间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIconSpace;
/// 银行名称
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
/// 银行卡类型
@property (weak, nonatomic) IBOutlet UITextField *cardTypeTF;
/// 开户省市
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
/// 支行名称
@property (weak, nonatomic) IBOutlet CNNormalInputView *subBankName;
/// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

/// 模型
@property (nonatomic, strong) SmsCodeModel *smsModel;
@property (nonatomic, strong) CardBinTypeModel *cardModel;
@end

@implementation CNAddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    [self setDelegate];
    [self configUI];
}

- (void)configUI {
    [self.accountView setPlaceholder:@"请输入您的账户姓名"];
    if (!KIsEmptyString([CNUserManager shareManager].userDetail.realName)) {
        self.accountView.text = [CNUserManager shareManager].userDetail.realName;
        self.accountView.userInteractionEnabled = NO;
    }
    [self.cardView setPlaceholder:@"请绑定与账户姓名相同的银行卡号"];
    [self.cardView setKeyboardType:UIKeyboardTypeNumberPad];
    [self.subBankName setPlaceholder:@"请输入您开卡银行（支行）名称"];
    [self setBankLogo:nil];
}

// 设置银行卡logo
- (void)setBankLogo:(nullable UIImage *)image {
    if (image) {
        self.cardIcon.hidden = NO;
        self.cardIconW.constant = 26;
        self.cardIconSpace.constant = 10;
        self.cardIcon.image = image;
    } else {
        self.cardIcon.hidden = YES;
        self.cardIconW.constant = 0;
        self.cardIconSpace.constant = 0;
    }
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.accountView.delegate = self;
    self.cardView.delegate = self;
    self.subBankName.delegate = self;
}

- (void)inputViewTextChange:(CNNormalInputView *)view {
    view.wrongAccout = NO;
    if (self.accountView == view) {//账户名
        if (![view.text validationType:ValidationTypeRealName]) {
            [view showWrongMsg:@"您输入的真实姓名有误"];
        }
    } else if (self.cardView == view) {//银行卡号
        // 识别不出来再显示错误
        if (view.text.length > 12) {
            [self requestCardBinWithBankCardNo];
        }
    } else if (self.subBankName == view) {//支行名称
        
    }
    [self checkSubmitBtnEnable];
}

// 选择银行名称
- (IBAction)choseBankName:(UIButton *)sender {
    [self.view endEditing:YES];
    NSArray *images = @[[UIImage imageNamed:@"zb"],[UIImage imageNamed:@"tx"]];
    [BRImageStringPickerView showStringPickerWithTitle:@"银行选择" dataSource:@[@"中国银行", @"建设银行"] images:images defaultSelValue:self.bankNameTF.text resultBlock:^(id selectValue, NSInteger index) {
        self.bankNameTF.text = selectValue;
        [self setBankLogo:images[index]];
        [self checkSubmitBtnEnable];
    }];
}

// 借记卡/信用卡
- (IBAction)choseCardType:(UIButton *)sender {
    [self.view endEditing:YES];
    [BRStringPickerView showStringPickerWithTitle:@"银行卡类型" dataSource:@[@"借记卡", @"信用卡"] defaultSelValue:self.cardTypeTF.text resultBlock:^(id selectValue, NSInteger index) {
        self.cardTypeTF.text = selectValue;
        [self checkSubmitBtnEnable];
    }];
}

// 选择开户省市
- (IBAction)choseArea:(UIButton *)sender {
    [self.view endEditing:YES];
    NSArray *arr = [self.areaTF.text componentsSeparatedByString:@"/"];
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity defaultSelected:arr isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        self.areaTF.text = [NSString stringWithFormat:@"%@/%@", province.name, city.name];
        [self checkSubmitBtnEnable];
    } cancelBlock:nil];
}

// 提交
- (IBAction)submit:(id)sender {
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYTextAlertView showWithTitle:@"手机绑定" content:@"对不起！系统发现您还没有绑定手机，请先完成手机绑定流程，再进行绑卡操作。" comfirmText:@"确定" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm) {
            if (isComfirm) {
                [self.navigationController pushViewController:[CNCompleteInfoVC new] animated:YES];
            }
        }];
        
    } else {
        // 获取验证码
        [CNBankVerifySmsView showPhone:[CNUserManager shareManager].userDetail.mobileNo
                                finish:^(CNBankVerifySmsView * _Nonnull view, SmsCodeModel *smsModel) {
            
            if(smsModel) {
                self.smsModel = smsModel;
                [self requestValidateId]; // 获取校验码
                [view removeFromSuperview];
            }
        }];
        
    }
}

// 按钮可点击条件
- (void)checkSubmitBtnEnable {
    self.submitBtn.enabled = (self.accountView.text.length > 0)
    && (self.cardView.text.length > 0)
    && (self.bankNameTF.text.length > 0)
    && (self.cardTypeTF.text.length > 0)
    && (self.areaTF.text.length > 0)
    && (self.subBankName.text.length > 0);
}


#pragma mark - Request

/// 获取银行卡信息
- (void)requestCardBinWithBankCardNo {
    WEAKSELF_DEFINE
    NSString *cardNo = self.cardView.text;
    [CNWDAccountRequest getBankCardBinByBankCardNo:cardNo handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg) {
            CardBinTypeModel *cardModel = [CardBinTypeModel cn_parse:responseObj];
            strongSelf.cardModel = cardModel;
            
            strongSelf.bankNameTF.text = cardModel.bankName;
            strongSelf.cardTypeTF.text = cardModel.cardTypeDesc;
            [strongSelf setBankLogo:[UIImage imageNamed:@"Icon Bankcard"]];
            [strongSelf.cardIcon sd_setImageWithURL:[NSURL getUrlWithString:cardModel.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
        } else {
            [strongSelf.cardView showWrongMsg:errorMsg];
        }
    }];
    
}

/// 获取校验码
- (void)requestValidateId {
    [CNLoginRequest verifySMSCodeWithType:CNSMSCodeTypeChangeBank smsCode:self.smsModel.smsCode smsCodeId:self.smsModel.messageId completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            // 更新校验码
            self.smsModel = [SmsCodeModel cn_parse:responseObj];
            [self bindBankCard];
        }
    }];
}

/// 绑卡
- (void)bindBankCard {
    
    [CNWDAccountRequest createAccountBankCardNo:self.cardView.text
                                       bankName:self.bankNameTF.text
                                    accountType:self.cardTypeTF.text
                                 bankBranchName:self.subBankName.text
                                       province:[self.areaTF.text componentsSeparatedByString:@"/"].firstObject
                                           city:[self.areaTF.text componentsSeparatedByString:@"/"].lastObject
                                      messageId:self.smsModel.messageId
                                     validateId:self.smsModel.validateId
                                         expire:self.smsModel.expire
                                        handler:^(id responseObj, NSString *errorMsg) {
        
        if (!errorMsg) {
            [CNHUB showSuccess:@"银行卡绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [IVLAManager singleEventId:@"A03_bankcard_update"];
            });
        }
    }];
}


@end
