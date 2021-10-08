//
//  BYMultiAccountRuleView.m
//  HYNewNest
//
//  Created by zaky on 7/9/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYMultiAccountRuleView.h"
#import "CNTwoStatusBtn.h"
#import "UILabel+Gradient.h"

@implementation BYMultiAccountRuleView

+ (void)showRuleWithLocatedPoint:(CGPoint)p {
    BYMultiAccountRuleView *a = [[BYMultiAccountRuleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [a setupViewsWithPoint:p];
    [a show];
}

+ (void)showRuleWithLocatedY:(CGFloat)y {
    BYMultiAccountRuleView *a = [[BYMultiAccountRuleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [a setupViewsWithY:y];
    [a show];
}

- (void)setupViewsWithPoint:(CGPoint)p {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(p.y+7);
        make.leading.equalTo(self.bgView).offset(25);
        make.trailing.equalTo(self.bgView).offset(-25);
        make.height.mas_equalTo(240);
    }];
    self.contentView.layer.cornerRadius = 10;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p];
    [path addLineToPoint:CGPointMake(p.x-10, p.y+7)];
    [path addLineToPoint:CGPointMake(p.x+10, p.y+7)];
    [path addLineToPoint:p];
    CAShapeLayer *traLay = [CAShapeLayer layer];
    traLay.path = path.CGPath;
    traLay.fillColor = self.contentView.backgroundColor.CGColor;
    [self.bgView.layer addSublayer:traLay];
    
    UILabel *titleLb = [UILabel new];
    titleLb.text = [CNUserManager shareManager].isUsdtMode?@"USDT账户":@"CNY账户";
    titleLb.font = [UIFont fontPFM16];
    titleLb.textColor = [UIColor whiteColor];
    [titleLb sizeToFit];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(29);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.3);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(40);
        make.top.equalTo(titleLb.mas_bottom).offset(20);
    }];
    
    if ([CNUserManager shareManager].isUsdtMode) {
        UILabel *lb1 = [UILabel new];
        lb1.text = @"·使用USDT钱包 ☑️";
        lb1.textColor = [UIColor whiteColor];
        lb1.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.top.equalTo(line);
        }];
        UILabel *lb2 = [UILabel new];
        lb2.text = @"·首存优惠 ☑️";
        lb2.textColor = [UIColor whiteColor];
        lb2.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.bottom.equalTo(line);
        }];
        UILabel *lb3 = [UILabel new];
        lb3.text = @"·新人大礼包 ☑️";
        lb3.textColor = [UIColor whiteColor];
        lb3.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb3];
        [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.top.equalTo(line);
        }];
        UILabel *lb4 = [UILabel new];
        lb4.text = @"·更多USDT 专属活动 ☑️";
        lb4.textColor = [UIColor whiteColor];
        lb4.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb4];
        [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.bottom.equalTo(line);
        }];
    } else {
        UILabel *lb1 = [UILabel new];
        lb1.text = @"·使用银行卡 ☑️";
        lb1.textColor = [UIColor whiteColor];
        lb1.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.centerY.equalTo(line);
        }];
        UILabel *lb4 = [UILabel new];
        lb4.text = @"·人民币直充上分 ☑️";
        lb4.textColor = [UIColor whiteColor];
        lb4.font = [UIFont fontPFR12];
        [self.contentView addSubview:lb4];
        [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(17);
            make.width.mas_equalTo(AD(150));
            make.height.mas_equalTo(20);
            make.centerY.equalTo(line);
        }];
    }
    
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.left.equalTo(self.contentView).offset(20);
        make.right.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    UILabel *gLb = [UILabel new];
    gLb.text = @"两个账户额度不相通";
    gLb.font = [UIFont fontPFR12];
    [gLb sizeToFit];
    [gLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    [self.contentView addSubview:gLb];
    [gLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(btn.mas_top).offset(-15);
    }];
    
    UIImageView *imgv = [UIImageView new];
    imgv.image = [UIImage imageNamed:@"yellow exclamation"];
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gLb);
        make.right.equalTo(gLb.mas_left).offset(-3);
        make.width.height.mas_equalTo(12);
    }];
}

- (void)setupViewsWithY:(CGFloat)y {
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"编组 17"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y);
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(AD(345));
        make.height.mas_equalTo(AD(267));
    }];

    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgv);
        make.width.mas_equalTo(305);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(imgv).offset(-20);
    }];
}

@end
