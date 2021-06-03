//
//  BYYuEBaoTransAlertView.m
//  HYNewNest
//
//  Created by zaky on 5/29/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYYuEBaoTransAlertView.h"
#import "CNTwoStatusBtn.h"

@implementation BYYuEBaoTransAlertView

+ (void)showTransAlertTransAmount:(NSNumber *)amount
                         interest:(nullable NSString *)interset
                  intersetNexTime:(nullable NSString *)timeStr
                        easyBlock:(nonnull AlertEasyBlock)block {
    BYYuEBaoTransAlertView *a = [[BYYuEBaoTransAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    a.easyBlock = block;
    [a setupViewsWithAmount:amount interest:interset intersetNexTime:timeStr];
    [a show];
}

- (void)setupViewsWithAmount:(NSNumber *)amount
                    interest:(nullable NSString *)interset
             intersetNexTime:(nullable NSString *)timeStr {
    //公共
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
        make.height.mas_equalTo(280);
    }];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"cg"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(74);
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(52);
        make.bottom.equalTo(self.contentView).offset(-33);
    }];
    
    UIColor *yeloCor = kHexColor(0xDD8215);
    UIColor *normCor = kHexColor(0xC5DCFF);
    UIColor *blueCor = kHexColor(0x15A0D4);
    UIFont *font = [UIFont fontPFR14];
    NSString *amountStr = [NSString stringWithFormat:@"%@USDT", amount];
    NSString *str = [NSString stringWithFormat:@"成功转%@%@到%@", interset?@"入":@"出", amountStr, interset?@"余额宝":@"可提币金额"];

    UILabel *mainLb = [[UILabel alloc] init];
    mainLb.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:normCor}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:yeloCor range:[str rangeOfString:amountStr]];
    mainLb.attributedText = attrStr;
    [self.contentView addSubview:mainLb];
    [mainLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(btn.mas_top).offset(-40);
        make.height.mas_equalTo(18);
    }];
    
    if (interset) {
        NSString *str = [NSString stringWithFormat:@"下次自然利息结算时间\n%@", timeStr];
        UILabel *lbTop = [[UILabel alloc] init];
        lbTop.numberOfLines = 2;
        lbTop.text = str;
        lbTop.font = [UIFont fontPFR12];
        lbTop.textColor = kHexColor(0x5B5BAA);
        [lbTop sizeToFit];
        [self.contentView addSubview:lbTop];
        [lbTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.centerX.equalTo(self.contentView);
        }];
        
        if (interset.floatValue > 0) {
            NSString *intersetStr = [NSString stringWithFormat:@"利息收益为%@USDT", interset];
            UILabel *secondLb = [[UILabel alloc] init];
            secondLb.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:intersetStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:normCor}];
            [attrStr addAttribute:NSForegroundColorAttributeName value:blueCor range:[intersetStr rangeOfString:interset]];
            secondLb.attributedText = attrStr;
            [self.contentView addSubview:secondLb];
            [secondLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(mainLb.mas_bottom).offset(2);
                make.height.mas_equalTo(18);
            }];
        }
        
    } else {
        [imgv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(52);
        }];
        
        UILabel *lbTop = [[UILabel alloc] init];
        lbTop.text = @"恭喜你";
        lbTop.font = [UIFont fontPFM16];
        lbTop.textColor = normCor;
        [lbTop sizeToFit];
        [self.contentView addSubview:lbTop];
        [lbTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgv.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
        
        [mainLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_top).offset(-30);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addCornerAndShadow];
}

- (void)comfirmClick {
    if (self.easyBlock) {
        self.easyBlock();
    }
    [self dismiss];
}

@end
