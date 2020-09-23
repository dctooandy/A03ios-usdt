//
//  HYVIPRuleAlertView.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPRuleAlertView.h"

@implementation HYVIPRuleAlertView

+ (void)showCumulateIdentityRule {
    HYVIPRuleAlertView *a = [[HYVIPRuleAlertView alloc] init];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(AD(30), 0.5*(kScreenHeight-AD(337)), AD(315), AD(337));
    [self.contentView addCornerAndShadow];
}

- (instancetype)init {
    self = [super init];

    self.contentView.backgroundColor = kHexColor(0xF2EDEA);
    
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"规则说明";
    lb.font = [UIFont fontPFSB16];
    lb.textColor = kHexColor(0x000000);
    lb.jk_origin = CGPointMake(AD(15), AD(20));
    [lb sizeToFit];
    [self.contentView addSubview:lb];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *close = [[UIImage imageNamed:@"modal-close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:close forState:UIControlStateNormal];
    btn.tintColor = kHexColor(0x000000);
    btn.frame = CGRectMake(AD(285), AD(22), AD(15), AD(15));
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    UILabel *lbContent = [[UILabel alloc] init];
    lbContent.font = [UIFont systemFontOfSize:AD(14)];
    lbContent.textColor = kHexColor(0x2C2C2C);
    lbContent.numberOfLines = 0;
    lbContent.text = @"概念介绍：会员可累计私享会身份兑换奖励；\n活动时间：有效期截止为2021年10月1日；\n清零规则：用户每次领取奖励，将清零之前所有累计的身份；如您获得了5次身份，选择领取了3次的奖励，系统将从零开始计算您的累计身份；\n身份下沉：在领取前，本次累计的身份需下沉计算，如用户获取了2次赌神，1次赌圣，用户只能领取赌圣区的奖励；\n举例：某会员在有效期内已经获得2次赌侠、4次赌王，他可以领取赌侠区3次和6次的奖励，且无论领取3次还是6次，累计身份和身份下沉都将从零开始计算。";
    lbContent.jk_origin = CGPointMake(AD(17), btn.bottom + AD(15));
    lbContent.size = CGSizeMake(AD(285), AD(260));
    [self.contentView addSubview:lbContent];
    
    return self;
}

@end
