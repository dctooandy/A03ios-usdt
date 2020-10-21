//
//  HYWithdrawActivityAlertView.m
//  HYNewNest
//
//  Created by zaky on 10/17/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYWithdrawActivityAlertView.h"
#import "CNTwoStatusBtn.h"
#import "HYWithdrawViewController.h"
#import "UILabel+Gradient.h"

@interface HYWithdrawActivityAlertView ()
@property (strong,nonatomic) UIImageView * topIcon;
@property (nonatomic, strong) UIButton *btnNowShow;
@property (nonatomic, assign) BOOL isGift;
@end

@implementation HYWithdrawActivityAlertView


#pragma mark - LAZY

- (UIImageView *)topIcon {
    if (!_topIcon) {
        UIImageView *imgv = [UIImageView new];
        imgv.contentMode = UIViewContentModeCenter;
        imgv.backgroundColor = kHexColor(0x343452);
        imgv.layer.cornerRadius = AD(34.5);
        imgv.layer.masksToBounds = YES;
        [self.bgView addSubview:imgv];
        _topIcon = imgv;
    }
    return _topIcon;
}



#pragma mark - CLASS

+ (void)showWithAmountPercent:(NSInteger)aPercent
                  giftPercent:(NSInteger)gPercent
                   mostAmount:(NSInteger)mAmount
                      handler:(void(^)(void))handler{
    
    HYWithdrawActivityAlertView *a = [[HYWithdrawActivityAlertView alloc] initWithAmountPercent:aPercent giftPercent:gPercent mostAmount:mAmount];
    a.frame = [UIScreen mainScreen].bounds;
    a.easyBlock = handler;
    [a show];
}

+ (void)showHandedOutGiftUSDTAmount:(NSNumber *)amount handler:(void(^)(void))handler{
    
    HYWithdrawActivityAlertView *a = [[HYWithdrawActivityAlertView alloc] initWithGiftAmount:amount];
    a.frame = [UIScreen mainScreen].bounds;
    a.easyBlock = handler;
    a.isGift = YES;
    [a show];
}


#pragma mark - VIEW LIFE

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = self.isGift?AD(283):AD(327);
    self.contentView.frame = CGRectMake(AD(30), 0.5*(kScreenHeight-height), AD(315), height);
    [self.contentView addCornerAndShadow];
    
    self.topIcon.frame = CGRectMake(AD(153), 0.5*(kScreenHeight-height)-AD(35), AD(69), AD(69));
   
}

- (instancetype)initWithGiftAmount:(NSNumber *)amount {
    self = [super init];
    
    self.topIcon.image = [UIImage imageNamed:@"icon_lh"];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.text = @"USDT提现增值发放啦!";
    lblTitle.font = [UIFont fontPFR16];
    [lblTitle sizeToFit];
    lblTitle.centerX = AD(315)*0.5;
    lblTitle.top = AD(51);
    [lblTitle setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    [self.contentView addSubview:lblTitle];
    
    UILabel *lblContent = [UILabel new];
    
    lblContent.text = [NSString stringWithFormat:@"提现增值礼金%@USDT\n提案已生成，等待审批", amount];
    lblContent.font = [UIFont fontPFSB18];
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    lblContent.numberOfLines = 2;
    [lblContent sizeToFit];
    lblContent.centerX = AD(315)*0.5;
    lblContent.top = lblTitle.bottom + AD(30);
    [self.contentView addSubview:lblContent];
    
    CNTwoStatusBtn *goBtn = [CNTwoStatusBtn new];
    goBtn.frame = CGRectMake(AD(28), lblContent.bottom + AD(40), AD(315) - AD(56), AD(48));
    [goBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goToSee) forControlEvents:UIControlEventTouchUpInside];
    goBtn.enabled = YES;
    [self.contentView addSubview:goBtn];
    
    return self;
    
}

- (instancetype)initWithAmountPercent:(NSInteger)aPercent giftPercent:(NSInteger)gPercent mostAmount:(NSInteger)mAmount {
    
    self = [super init];

    self.topIcon.image = [UIImage imageNamed:@"icon_take"];
    
    UIButton *btnNotShow = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNotShow setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [btnNotShow setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [btnNotShow setTitle:@" 不再提示" forState:UIControlStateNormal];
    btnNotShow.titleLabel.font = [UIFont fontPFR14];
    [btnNotShow sizeToFit];
    btnNotShow.right = AD(327) - AD(30);
    btnNotShow.top = AD(10);
    [btnNotShow addTarget:self action:@selector(didClickNotShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnNotShow];
    self.btnNowShow = btnNotShow;
    self.btnNowShow.selected = [[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowQKFLUserDefaultKey];
    
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.numberOfLines = 2;
    lblTitle.text = [NSString stringWithFormat:@"USDT账户增值计划\n额外增收%ld%%", (long)gPercent];
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFSB21];
    lblTitle.frame = CGRectMake(0, btnNotShow.bottom + AD(29), AD(315), AD(65));
    [self.contentView addSubview:lblTitle];
    
    UILabel *lblContent = [UILabel new];
    lblContent.numberOfLines = 0;
    lblContent.text = [NSString stringWithFormat:@"即日起您提现额度的%ld%%，将会按实时汇率转入您的USDT账户，并获得USDT转入金额的%ld%%增值礼金，单日最高可得%ldUSDT。", (long)aPercent, gPercent, mAmount];
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    lblContent.font = [UIFont systemFontOfSize:AD(14)];
    lblContent.frame = CGRectMake(AD(21), lblTitle.bottom + AD(25), AD(315)-AD(42), AD(80));
    [self.contentView addSubview:lblContent];
    
    CNTwoStatusBtn *goBtn = [CNTwoStatusBtn new];
    goBtn.frame = CGRectMake(AD(28), lblContent.bottom + AD(40), AD(315) - AD(56), AD(48));
    [goBtn setTitle:@"去提现" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goWithdraw) forControlEvents:UIControlEventTouchUpInside];
    goBtn.enabled = YES;
    [self.contentView addSubview:goBtn];
    
    return self;
}


#pragma mark - ACTION

- (void)goWithdraw {
    [[NSUserDefaults standardUserDefaults] setBool:self.btnNowShow.selected forKey:HYNotShowQKFLUserDefaultKey];
    if (self.easyBlock) {
        self.easyBlock();
    }
    [self dismiss];
}

- (void)goToSee {
    if (self.easyBlock) {
        self.easyBlock();
    }
    [self dismiss];
}

- (void)didClickNotShow:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)dismiss {
    [self record];
    [super dismiss];
}

- (void)record {
    [[NSUserDefaults standardUserDefaults] setBool:self.btnNowShow.selected forKey:HYNotShowCTZNEUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
        

}

@end
