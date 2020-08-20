//
//  HYWithdrawComfirmView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawComfirmView.h"
#import "CNBaseTF.h"
#import "CNAmountInputView.h"
#import "CNNormalInputView.h"
#import "CNTwoStatusBtn.h"

@interface HYWithdrawComfirmView () <CNAmountInputViewDelegate, CNNormalInputViewDelegate>
// UI
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *lblTitle;
@property (weak, nonatomic) CNAmountInputView *inputTF;
@property (nonatomic, weak) CNTwoStatusBtn *btn;
// UI2
@property (weak, nonatomic) CNNormalInputView *nameTF;
// DATA
@property (nonatomic, strong) AccountMoneyDetailModel *amoutModel;
@property (nonatomic, copy) void(^clickBlock)(NSString* text);
// 完成状态 UI
@property (nonatomic, strong) UIView *succView;
@property (nonatomic, strong) UIImageView *depositSuccssImgv;
@property (nonatomic, weak) CNTwoStatusBtn *secondBtn;
@end

@implementation HYWithdrawComfirmView

- (void)commonViewsSetup {
    // 半透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavPlusStaBarHeight)];
    bgView.backgroundColor = kHexColorAlpha(0x000000, 0.4);
    [self addSubview:bgView];
    
      // 主背景
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavPlusStaBarHeight, kScreenWidth, 426+kSafeAreaHeight)];
    self.mainView = mainView;
    mainView.tag = 150;
    mainView.backgroundColor = kHexColor(0x212137);
    [self addSubview:mainView];
      
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mainView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = mainView.bounds;
    mainView.layer.mask = layer;
    [bgView addSubview:mainView];
    
    // 标题
    UILabel *lblSex = [[UILabel alloc] init];
    lblSex.frame = CGRectMake(0, 0, kScreenWidth, 50);
    lblSex.text = [CNUserManager shareManager].isUsdtMode?@"提币金额":@"提款金额";
    lblSex.textAlignment = NSTextAlignmentCenter;
    lblSex.font = [UIFont fontPFM16];
    lblSex.textColor = [UIColor whiteColor];
    [lblSex jk_addBottomBorderWithColor:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5];
    [mainView addSubview:lblSex];
    self.lblTitle = lblSex;
    
    // 关闭按钮
    UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancle setImage:[UIImage imageNamed:@"modal-close"] forState:UIControlStateNormal];
    btnCancle.frame = CGRectMake(CGRectGetWidth(bgView.frame)-30-25, 10, 30, 30);
    [btnCancle addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnCancle];
    
    //btn
    CNTwoStatusBtn *btn = [[CNTwoStatusBtn alloc] initWithFrame:CGRectMake(30, 272, kScreenWidth - 60, 48)];
    self.btn = btn;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = kScreenHeight-kNavPlusStaBarHeight - 345 - kSafeAreaHeight;
    }];
}

/// 输入真名
- (instancetype)initRealNameSubmitBlock:(void (^)(NSString * _Nonnull))block {
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    
    self.clickBlock = block;
    [self commonViewsSetup];
    
    // lable
    UILabel *lblMon = [[UILabel alloc] init];
    lblMon.text = @"首次转账支付，需绑定您的真实姓名，绑定后不可修改，且必须和提款银行卡姓名一致";
    lblMon.frame = CGRectMake(23, CGRectGetMaxY(self.lblTitle.frame)+24, AD(329), AD(50));
    lblMon.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    lblMon.font = [UIFont fontPFR14];
    lblMon.numberOfLines = 2;
    [self.mainView addSubview:lblMon];
    
    // input
    CNNormalInputView *inputView = [[CNNormalInputView alloc] initWithFrame:CGRectMake(30, lblMon.bottom + 9, kScreenWidth-60, 89)];
    self.nameTF = inputView;
    inputView.delegate = self;
    [inputView setPlaceholder:@"请输入您的真实姓名"];
    [self.mainView addSubview:inputView];
    
    return self;
}

/// 输入金额
- (instancetype)initWithAmountModel:(nullable AccountMoneyDetailModel *)amoutModel
                        sumbitBlock:(nullable void(^)(NSString *withdrawAmout))block{
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    
    self.amoutModel = amoutModel;
    self.clickBlock = block;
    [self commonViewsSetup];
    
    // money
    UILabel *lblMon = [[UILabel alloc] init];
    lblMon.text = [CNUserManager shareManager].isUsdtMode?@"可提币金额":@"可提现金额";
    lblMon.frame = CGRectMake(30, CGRectGetMaxY(self.lblTitle.frame)+32, kScreenWidth-60, 17);
    lblMon.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
    lblMon.font = [UIFont fontPFR15];
    [self.mainView addSubview:lblMon];
    
    UILabel *lblAmo = [[UILabel alloc] init];
    if (amoutModel) {
        lblAmo.text = [amoutModel.withdrawBal jk_toDisplayNumberWithDigit:6];
    }
    lblAmo.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
    lblAmo.font = [UIFont fontDBOfMIDSize];
    [lblAmo sizeToFit];
    lblAmo.x = lblMon.x;
    lblAmo.y = lblMon.bottom + AD(4);
    [self.mainView addSubview:lblAmo];
    
    UILabel *lblUnit = [[UILabel alloc] init];
    if (amoutModel) {
        lblUnit.text = amoutModel.currency;
    }
    lblUnit.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
    lblUnit.font = [UIFont fontPFR14];
    [lblUnit sizeToFit];
    lblUnit.x = lblAmo.right + AD(4);
    lblUnit.bottom = lblAmo.bottom;
    [self.mainView addSubview:lblUnit];
    
    //input
    CNAmountInputView *inputView = [[CNAmountInputView alloc] initWithFrame:CGRectMake(30, lblUnit.bottom, kScreenWidth-60, 89)];
    self.inputTF = inputView;
    inputView.delegate = self;
    inputView.codeType = CNAmountTypeWithdraw;
    if (amoutModel) {
        inputView.model = self.amoutModel;
    }
    [inputView setPlaceholder:@"请输入提款金额"];
    [self.mainView addSubview:inputView];
    
    return self;
}


#pragma mark - ACTION

- (void)showRechargeWaiting {
    [self showStatusCommonViews];
    
    self.lblTitle.text = @"支付等待";
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.textAlignment = NSTextAlignmentCenter;
    contentLb.text = @"尊敬的客户，请根据您的存款结果选择！";
    contentLb.font = [UIFont fontPFM16];
    contentLb.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
    [contentLb sizeToFit];
    contentLb.y = self.depositSuccssImgv.bottom;
    contentLb.centerX = self.succView.centerX;
    [self.succView addSubview:contentLb];
    
    UILabel *content2Lb = [[UILabel alloc] init];
    content2Lb.textAlignment = NSTextAlignmentCenter;
    content2Lb.text = @"到账时间约1~10分钟。如长时间未到款请联系客服";
    content2Lb.font = [UIFont fontPFR14];
    content2Lb.textColor = kHexColorAlpha(0x888888, 0.8);
    [content2Lb sizeToFit];
    content2Lb.y = contentLb.bottom + 10;
    content2Lb.centerX = self.succView.centerX;
    [self.succView addSubview:content2Lb];
    
    [self.secondBtn setTitle:@"完成支付" forState:UIControlStateNormal];
}

- (void)showSuccessWithdraw {
    [self showStatusCommonViews];
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.textAlignment = NSTextAlignmentCenter;
    contentLb.numberOfLines = 2;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontPFM16], NSForegroundColorAttributeName: kHexColorAlpha(0xFFFFFF, 0.8)};
    NSString *fullStr = @"您的提款，正在受理中\n预计5分钟后到账";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullStr attributes:attr];
    NSRange range = [fullStr rangeOfString:@"5分钟"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(0x10B4DD) range:range];
    contentLb.attributedText = attrStr;
    [contentLb sizeToFit];
    contentLb.y = self.depositSuccssImgv.bottom;
    contentLb.centerX = self.succView.centerX;
    [self.succView addSubview:contentLb];
}

- (void)showStatusCommonViews {
    // 成功状态view
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.y -= 81;
    }];
    
    UIView *succView = [[UIView alloc] init];
    succView.backgroundColor = kHexColor(0x212137);
    succView.frame = CGRectMake(0, 50, kScreenWidth, 426+kSafeAreaHeight-50);
    self.succView = succView;
    [self.mainView addSubview:succView];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    imgv.contentMode = UIViewContentModeCenter;
    imgv.image = [UIImage imageNamed:@"deposit-success"];
    self.depositSuccssImgv = imgv;
    [succView addSubview:imgv];
    
    
    // 俩按钮
    CGFloat LRMargin = 40;
    CGFloat BtnMargin = 30;
    CGFloat BtnWIdth = (kScreenWidth - LRMargin*2 - BtnMargin)*0.5;
    
//    CNTwoStatusBtn *topBtn = [[CNTwoStatusBtn alloc] initWithFrame:CGRectMake(kScreenWidth-LRMargin-BtnWIdth, contentLb.bottom+56, BtnWIdth, 48)];
    CNTwoStatusBtn *topBtn = [[CNTwoStatusBtn alloc] initWithFrame:CGRectMake(kScreenWidth-LRMargin-BtnWIdth, succView.height-kSafeAreaHeight-24-48, BtnWIdth, 48)];
    [topBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont fontPFM14];
    topBtn.tag = 1;
    [topBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    topBtn.enabled = YES;
    [succView addSubview:topBtn];
    self.secondBtn = topBtn;
      
    UIButton *botoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [botoomBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [botoomBtn.titleLabel setFont: [UIFont fontPFR14]];
    [botoomBtn setTitleColor:kHexColor(0x10B4DD) forState:UIControlStateNormal];
    botoomBtn.layer.cornerRadius = 22;
    botoomBtn.layer.borderWidth = 1;
    botoomBtn.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    botoomBtn.frame = CGRectMake(LRMargin, topBtn.y, BtnWIdth, 48);
    botoomBtn.tag = 0;
    [botoomBtn addTarget:self action:@selector(jump2Kefu) forControlEvents:UIControlEventTouchUpInside];
    [succView addSubview:botoomBtn];
}


- (void)submitClick {
    if (self.clickBlock) {
        self.clickBlock(self.inputTF ? self.inputTF.money : self.nameTF.text);
    }
    if (self.nameTF.text) {
        [self removeView];
    }
}

- (void)jump2Kefu {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}

- (void)removeView{
    UIView *mainView = [self viewWithTag:150];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = kScreenHeight-kNavPlusStaBarHeight;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}


#pragma mark - DELEGATE

- (void)amountInputViewTextChange:(CNAmountInputView *)view {
    self.btn.enabled = (view.correct && view.money.length > 0);
}

- (void)inputViewTextChange:(CNNormalInputView *)view {
    if (![view.text validationType:ValidationTypeRealName]) {
        [view showWrongMsg:@"您输入的真实姓名有误"];
        self.btn.enabled = NO;
    } else {
        view.wrongAccout = NO;
        self.btn.enabled = YES;
    }
}

@end
