//
//  HYVIPRuleAlertView.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPRuleAlertView.h"

@interface HYVIPRuleAlertView ()
@property (assign, nonatomic) RuleAlertKind kind;
@end

@implementation HYVIPRuleAlertView

+ (void)showCumulateIdentityRule {
    HYVIPRuleAlertView *a = [[HYVIPRuleAlertView alloc] initWithKind:RuleAlertKindVIPCumulateIdentity];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

+ (void)showFriendShareV2Rule {
    HYVIPRuleAlertView *a = [[HYVIPRuleAlertView alloc] initWithKind:RuleAlertKindSuperCopartner];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithKind:(RuleAlertKind)kind {
    self = [super init];
    _kind = kind;
    [self setup];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.kind == RuleAlertKindVIPCumulateIdentity) {
        self.contentView.frame = CGRectMake(AD(30), 0.5*(kScreenHeight-AD(337)), AD(315), AD(337));
        [self.contentView addCornerAndShadow];
        
    } else {
        self.contentView.frame = CGRectMake(12.5, 0.5*(kScreenHeight-395), kScreenWidth-25, 395);
        [self.contentView addCornerAndShadow];
    }
}

- (void)setup {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *close = [[UIImage imageNamed:@"modal-close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:close forState:UIControlStateNormal];
    btn.tintColor = kHexColor(0x000000);
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    
    if (self.kind == RuleAlertKindVIPCumulateIdentity) {
        btn.frame = CGRectMake(AD(285), AD(20), AD(15), AD(15));
        self.contentView.backgroundColor = kHexColor(0xF2EDEA);
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"规则说明";
        lb.font = [UIFont fontPFSB16];
        lb.textColor = kHexColor(0x000000);
        lb.jk_origin = CGPointMake(AD(15), AD(20));
        [lb sizeToFit];
        [self.contentView addSubview:lb];
        
        UILabel *lbContent = [[UILabel alloc] init];
        lbContent.font = [UIFont systemFontOfSize:AD(14)];
        lbContent.textColor = kHexColor(0x2C2C2C);
        lbContent.numberOfLines = 0;
        lbContent.text = @"概念介绍：会员可累计私享会身份兑换奖励；\n活动时间：有效期截止为2021年10月1日；\n清零规则：用户每次领取奖励，将清零之前所有累计的身份；如您获得了5次身份，选择领取了3次的奖励，系统将从零开始计算您的累计身份；\n身份下沉：在领取前，本次累计的身份需下沉计算，如用户获取了2次赌神，1次赌圣，用户只能领取赌圣区的奖励；\n举例：某会员在有效期内已经获得2次赌侠、4次赌王，他可以领取赌侠区3次和6次的奖励，且无论领取3次还是6次，累计身份和身份下沉都将从零开始计算。";
        lbContent.jk_origin = CGPointMake(AD(17), btn.bottom + AD(15));
        lbContent.size = CGSizeMake(AD(285), AD(260));
        [self.contentView addSubview:lbContent];
        
        
    } else {
        
        btn.frame = CGRectMake(AD(321), 17, AD(14), AD(14));
        self.contentView.backgroundColor = kHexColor(0xFFFFFF);
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"规则说明";
        lb.font = [UIFont fontPFSB16];
        lb.textColor = kHexColor(0x6020DB);
        [lb sizeToFit];
        lb.frame = CGRectMake(AD(143), 17, 70, 16);
        [self.contentView addSubview:lb];
        
        UILabel *lbContent = [[UILabel alloc] init];
        lbContent.font = [UIFont systemFontOfSize:AD(12)];
        lbContent.textColor = kHexColor(0x000000);
        lbContent.numberOfLines = 0;
        lbContent.text = @"1. 本活动推荐人需达到2星级及以上才能获得奖励；星级推荐奖金将在被推荐人晋级次日24小时内产生；\n2. 推荐礼金有效期为30天，有3倍流水可提现；\n3. 若被推荐人跳级晋升，推荐人可获得被推荐人已达成星级的所有推荐礼金奖励；举例：被推荐人从3星级升级到5星级，则推荐人可获得56+98推荐礼金；\n4. 系统会根据用户的IP、电话、支付方式等判定是否为同一人；\n5. 一个用户只能被推荐一次，且推荐人和被推荐人不能被系统判定为同一人；\n6. 不同被推荐人用户被系统判定为同一人，会触发系统套利风控，可能会被取消奖励；\n7. 合作代理发展的下线不适用此优惠；\n8. 实物奖品可按照全国参考零售价八折折现为账户余额，折现额度3倍流水可提现；\n9. 为避免文字理解差异，币游国际保留对本活动的最终解释权。";
        lbContent.jk_origin = CGPointMake(AD(26), 49);
        lbContent.size = CGSizeMake(AD(298), 327);
        [self.contentView addSubview:lbContent];
    }
    
}

@end
