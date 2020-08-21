//
//  HYRechargeEditView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargeEditView.h"
#import <Masonry/Masonry.h>
#import "HYRechProcButton.h"
#import "HYRechargeHelper.h"
#import <UIImageView+WebCache.h>

@interface HYRechargeEditView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWayName;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWayLimit;

@property (weak, nonatomic) IBOutlet UIView *protocolBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTfViewTopMargin;

@property (weak, nonatomic) IBOutlet UIView *amountTfBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUponAmoTf;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (nonatomic, assign) BOOL isAmountRight;

@property (nonatomic, strong) DepositsBankModel *deposModel;
@property (nonatomic, strong) NSArray *protocols; // 所有协议
@property (nonatomic, strong) NSArray *protocolAddrs; // 所有协议分别对应的转账地址

/// 用户的金额
@property (nonatomic, copy, readwrite) NSString *rechargeAmount;
/// 选中的协议
@property (nonatomic, copy, readwrite) NSString *selectedProtocol;
@property (nonatomic, copy, readwrite) NSString *selectProtocolAddress;
@end

@implementation HYRechargeEditView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.contentView.backgroundColor = kHexColor(0x212137);
    [self.contentView addCornerAndShadow];
    
    [self setupTextFieldView];
}

- (void)setupTextFieldView {
    self.amountTfBgView.layer.cornerRadius = 5;
    self.amountTfBgView.layer.borderColor = kHexColorAlpha(0xFFFFFF, 0.3).CGColor;
    self.amountTfBgView.layer.borderWidth = 0.5;
    
    [self.tfAmount setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfAmount setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfAmount addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)setupProtocolView {
    CGFloat ItemMargin = 16;
    CGFloat ItemWidht = (kScreenWidth - 15*2 - 14*2 - ItemMargin*2)/3.0;
    
    HYRechProcButton *firstBtn;
    for (__block int i=0; i<self.protocols.count; i++) {
        HYRechProcButton *proBtn = [[HYRechProcButton alloc] init];
        [proBtn setTitle:self.protocols[i] forState:UIControlStateNormal];
        [proBtn addTarget:self action:@selector(protocolSelected:) forControlEvents:UIControlEventTouchUpInside];
        proBtn.tag = i;
        
        [self.protocolBgView addSubview:proBtn];
        proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * (i%3), (i/3) * (40+16), ItemWidht, 40);
        
        if (i==0) {
            firstBtn = proBtn;
        }
    }
    // 选中第一个
    [self protocolSelected:firstBtn];
    
    // tmd小金库要隐藏
    if ([HYRechargeHelper isOnlinePayWayDCBox:self.deposModel]) {
        self.protocolBgView.hidden = YES;
        self.amountTfViewTopMargin.constant = 22;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(249-62);
        }];
    } else {
        self.protocolBgView.hidden = NO;
        self.amountTfViewTopMargin.constant = 86;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(249);
        }];
    }
}


#pragma mark - TextField

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    NSString *tipText = @"";
    // 校验金额
    if ([text floatValue] < (float)self.deposModel.minAmount) {
        tipText = [NSString stringWithFormat:@"请输入≥%ld%@的数额", self.deposModel.minAmount, self.deposModel.currency];;
        self.isAmountRight = NO;
        
    } else if ([text floatValue] > (float)self.deposModel.maxAmount){
        tipText = [NSString stringWithFormat:@"超过最大充币额度%ld%@", self.deposModel.maxAmount, self.deposModel.currency];
        self.isAmountRight = NO;
        
    } else {
        self.isAmountRight = YES;
    }
    // 改变UI
    if (!self.isAmountRight) {
        self.lblUponAmoTf.text = tipText;
        self.lblUponAmoTf.textColor = kHexColor(0xFF5D5B);
        self.amountTfBgView.layer.borderColor = kHexColor(0xFF5D5B).CGColor;
        
    } else {
        self.lblUponAmoTf.text = @"充币额度";
        self.lblUponAmoTf.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
        self.amountTfBgView.layer.borderColor = kHexColorAlpha(0xFFFFFF, 0.3).CGColor;
    }
    // 通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeIsAmountRight:)]) {
        [self.delegate didChangeIsAmountRight:self.isAmountRight];
    }
}


#pragma mark - ACTION

- (void)protocolSelected:(UIButton *)aBtn {
    for (UIButton *btn in self.protocolBgView.subviews) {
        btn.selected = NO;
    }
    aBtn.selected = YES;
    self.selectedProtocol = _protocols[aBtn.tag];
    self.selectProtocolAddress = _protocolAddrs[aBtn.tag];
}

- (IBAction)didTapSwitchBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSwitchBtnModel:)]) {
        [self.delegate didTapSwitchBtnModel:self.deposModel];
    }
}


#pragma mark - SET&GET

- (void)setupDepositModel:(DepositsBankModel *)model {
    _deposModel = model;
    
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:model.bankIcon]];
    _tfAmount.placeholder = [NSString stringWithFormat:@"请输入≥%ld%@的数额", model.minAmount, model.currency];
    if ([model.bankname caseInsensitiveCompare:@"dcbox"] == NSOrderedSame) {
        _lblPayWayName.text = @"小金库";
    } else if ([HYRechargeHelper isUSDTOtherBankModel:model]){
        _lblPayWayName.text = @"钱包扫码";
    } else {
        _lblPayWayName.text = model.bankname;
    }
    _lblPayWayLimit.text = [NSString stringWithFormat:@"(%@)", [HYRechargeHelper amountTipUSDT:model]];
    
    
    //protocols
    NSString *pros = model.usdtProtocol;
    NSArray *proStrArr = [pros componentsSeparatedByString:@";"];

    NSMutableArray *protocolsArr = @[].mutableCopy;
    NSMutableArray *protocolAddrsArr = @[].mutableCopy;

    int j = 0;
    for (NSInteger i=proStrArr.count-1; i>=0; i--) { //倒序。。
        NSString *depositor = proStrArr[i];
        NSString *firstStr = [depositor componentsSeparatedByString:@":"].firstObject;
        NSString *lastStr = [depositor componentsSeparatedByString:@":"].lastObject;
        [protocolsArr addObject:firstStr];
        [protocolAddrsArr addObject:lastStr];
        
        if (j==0) {
            self.selectedProtocol = firstStr;
            self.selectProtocolAddress = lastStr;
        }
        j++;
    }
    
    self.protocols = protocolsArr;
    self.protocolAddrs = protocolAddrsArr;
    
    [self setupProtocolView];
}

- (NSString *)rechargeAmount {
    return self.tfAmount.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
