//
//  HYWithdrawCalculateComView.m
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYWithdrawCalculatorComView.h"

@interface HYWithdrawCalculatorComView ()
@property (nonatomic, strong) NSString * numGiftNum;
@property (nonatomic, assign) NSInteger exchangeRatio;
@property (nonatomic, strong) WithdrawCalculateModel *model;
@end

@implementation HYWithdrawCalculatorComView

+ (void)showWithCalculatorModel:(WithdrawCalculateModel *)model
       exchangeRatioOfAllAmount:(NSInteger)ratio
                  submitHandler:(SubmitComfirmArgsBlock)handler {
    HYWithdrawCalculatorComView *view = [[HYWithdrawCalculatorComView alloc] initWithContentViewHeight:AD(468) title:@"提现明细" comfirmBtnText:@"下一步"];
    view.submitArgsHandler = handler;
    view.exchangeRatio = ratio;
    [view setupWithModel:model];
}

- (instancetype)initWithContentViewHeight:(CGFloat)height title:(NSString *)title comfirmBtnText:(NSString *)btnTitle {
    self = [super initWithContentViewHeight:height title:title comfirmBtnText:btnTitle];
    self.comfirmBtn.enabled = YES;
    return self;
}

// 核心内容
- (void)setupWithModel:(WithdrawCalculateModel *)model{
    self.model = model;
    
    CanWithdrawInfoItem *CNYItem;
    CanWithdrawInfoItem *USDTItem;
    for (CanWithdrawInfoItem *item in model.canWithdrawInfo) {
        if ([item.currency isEqualToString:@"CNY"]) {
            CNYItem = item;
        } else {
            USDTItem = item;
        }
    }
    
    CGFloat topY = self.titleLbl.bottom;
    if ([model.amount floatValue] >= model.exchangeAmountLimit*1.0) {
    
        UILabel *cnyWithdraw = [self commonLabel:@"人民币提现金额"
                                            orgP:CGPointMake(AD(20), topY + AD(20))];
        
        NSString *amount = [NSString stringWithFormat:@"%@ CNY", CNYItem.amount];
        UILabel *lblAmount = [self attributedLabel:amount
                                              orgP: CGPointMake(AD(20), cnyWithdraw.bottom + AD(10))];
        
        UILabel *usdtWithdraw = [self commonLabel:[NSString stringWithFormat:@"USDT提现金额（提现额度%ld%%）", model.creditExchangeRatio]
        orgP:CGPointMake(AD(20), lblAmount.bottom + AD(21))];
        topY = usdtWithdraw.bottom;
        
    } else {
        UILabel *lblBlue = [self commonLabel:[NSString stringWithFormat:@"Tips：提现金额＜%ldCNY将全部提为USDT", model.exchangeAmountLimit]
                                        orgP:CGPointMake(AD(20), topY + AD(30))];
        lblBlue.textColor = kHexColor(0x19CDCE);
        
        UILabel *usdtWithdraw = [self commonLabel:@"USDT提现金额"
                                             orgP:CGPointMake(AD(20), lblBlue.bottom + AD(10) + AD(21))];
        topY = usdtWithdraw.bottom;
    }
    
    NSString *usdtAmount = [NSString stringWithFormat:@"%@ CNY ≈ %@ USDT", USDTItem.srcAmount, USDTItem.amount];
    UILabel *lblUSDTAmount = [self attributedLabel:usdtAmount
                                              orgP:CGPointMake(AD(20), topY + AD(10))];
    
    
    UILabel *usdtGift = [self commonLabel:[NSString stringWithFormat:@"USDT提现增值红包（%ld%%，最高%ldusdt）", model.promoInfo.promoRatio, model.promoInfo.maxAmountPerTime]
                                      orgP:CGPointMake(AD(20), lblUSDTAmount.bottom + AD(21))];
    
    NSString *math;
    CGFloat giftNum = 0.0;
     // 比例转USDT USDT数额红利 自动计算的公式
    if ([model.amount floatValue] >= model.exchangeAmountLimit*1.0) {
        math = [NSString stringWithFormat:@"%@ USDT * %ld%% = %@ USDT", model.promoInfo.refAmount, model.promoInfo.promoRatio, model.promoInfo.amount];
    // 全额转USDT USDT数额比例 手动计算的公式
    } else {
        giftNum = [model.promoInfo.amount floatValue] * self.exchangeRatio * 0.01;
        NSString *numGiftNum = [[NSNumber numberWithDouble:giftNum] jk_toDisplayNumberWithDigit:2];
        math = [NSString stringWithFormat:@"%@ USDT * %ld%% * %ld%% = %@ USDT", model.promoInfo.refAmount,  self.exchangeRatio, model.promoInfo.promoRatio, numGiftNum];
        self.numGiftNum = numGiftNum;
    }
    UILabel *lblMath = [self attributedLabel:math
                                        orgP:CGPointMake(AD(20), usdtGift.bottom + AD(10))];
    
    
    UIView *line = [UIView new];
    line.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.1);
    line.frame = CGRectMake(AD(20), lblMath.bottom + AD(13), kScreenWidth - AD(40), 0.5);
    [self.contentView addSubview:line];
    
    
    UILabel *lblLjtx = [self commonLabel:@"累计提现"
                                    orgP:CGPointMake(AD(20), line.bottom + AD(19))];
    
    NSString *ljtxStr = [NSString stringWithFormat:@"%@ CNY",[model.amount jk_toDisplayNumberWithDigit:0]];
    UILabel *ljtxAmo = [self attributedLabel:ljtxStr orgP:CGPointMake(0, 0)];
    ljtxAmo.right = kScreenWidth - AD(20);
    ljtxAmo.bottom = lblLjtx.bottom;
    
    
    UILabel *lblHBLS = [self commonLabel:@"USDT红包(免流水)："
                                    orgP:CGPointMake(AD(20), lblLjtx.bottom + AD(15))];
    
    NSString *hblsStr = self.numGiftNum ? [NSString stringWithFormat:@"%@ USDT", self.numGiftNum] : [NSString stringWithFormat:@"%@ USDT", model.promoInfo.amount];
    UILabel *hblsAmo = [self attributedLabel:hblsStr orgP:CGPointMake(0, 0)];
    hblsAmo.right = kScreenWidth - AD(20);
    hblsAmo.bottom = lblHBLS.bottom;
}

- (void)touchupComfirmBtn {
    if (self.submitArgsHandler) {
        self.submitArgsHandler(YES, self.numGiftNum ? self.numGiftNum : self.model.promoInfo.amount, nil);
    }
    [self dismiss];
}

#pragma mark - Common UI
- (UILabel *)commonLabel:(NSString *)string orgP:(CGPoint)p {
    UILabel *lblCom = [UILabel new];
    lblCom.text = string;
    lblCom.font = [UIFont fontPFR14];
    lblCom.textColor = kHexColorAlpha(0xFFFFFF, 0.7);
    [lblCom sizeToFit];
    lblCom.jk_origin = p;
    [self.contentView addSubview:lblCom];
    
    return lblCom;
}

- (UILabel *)attributedLabel:(NSString *)string orgP:(CGPoint)p{
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName: kHexColorAlpha(0xFFFFFF, 0.7),
                                 NSFontAttributeName: [UIFont fontPFR14]};
    NSDictionary *highAttr = @{NSForegroundColorAttributeName: kHexColor(0xFFFFFF),
                               NSFontAttributeName: [UIFont fontPFSB22]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:normalAttr];
    [attrStr addAttributes:normalAttr range:[string rangeOfString:@"CNY"]];
    [attrStr addAttributes:normalAttr range:[string rangeOfString:@"USDT"]];
    [attrStr addAttributes:normalAttr range:[string rangeOfString:@"*"]];
    [attrStr addAttributes:normalAttr range:[string rangeOfString:@"="]];
    NSSet *set = [NSSet setWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"≈",@"=",@"%", nil];
    for (int i=0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [string substringWithRange:range];
        if ([set containsObject:str]) {
            [attrStr addAttributes:highAttr range:range];
        }
    }
    
    UILabel *lblAttr = [UILabel new];
    lblAttr.attributedText = attrStr;
    [lblAttr sizeToFit];
    lblAttr.jk_origin = p;
    [self.contentView addSubview:lblAttr];
    
    return lblAttr;
}


@end
