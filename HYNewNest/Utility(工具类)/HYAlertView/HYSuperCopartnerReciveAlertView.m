//
//  HYSuperCopartnerReciveAlertView.m
//  HYNewNest
//
//  Created by zaky on 12/18/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYSuperCopartnerReciveAlertView.h"

@interface HYSuperCopartnerReciveAlertView ()
@property (strong,nonatomic) UIButton *Xbtn;
@end

@implementation HYSuperCopartnerReciveAlertView

+ (void)showReceiveAlert {
    HYSuperCopartnerReciveAlertView *a = [[HYSuperCopartnerReciveAlertView alloc] init];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(AD(23), kNavPlusStaBarHeight + AD(188), AD(340), AD(255));
    [self.contentView addCornerAndShadow];
    
    self.Xbtn.frame = CGRectMake(AD(176), self.contentView.bottom + AD(12), AD(34), AD(34));
}

- (instancetype)init {
    self = [super init];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:({
        UIImageView *topImgv = [UIImageView new];
        topImgv.image = [UIImage imageNamed:@"矩形备份 3"];
        topImgv.frame = CGRectMake(AD(-1), AD(-1), AD(342), AD(44));
        topImgv.contentMode = UIViewContentModeScaleAspectFill;
        topImgv;
    })];
    
    [self.contentView addSubview:({
        UILabel *topLb = [UILabel new];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"恭喜你" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLTDHK--GBK1-0" size:14], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        topLb.attributedText = str;
        topLb.frame = CGRectMake(AD(150), AD(14), AD(45), AD(17));
        topLb;
    })];
    
    [self.contentView addSubview:({
        UILabel *oneLb = [UILabel new];
        oneLb.text = @"获得上月好友累投";
        oneLb.font = [UIFont fontPFLight:AD(12)];
        oneLb.textAlignment = NSTextAlignmentCenter;
        oneLb.frame = CGRectMake(0, AD(48), AD(340), AD(17));
        oneLb;
    })];
    
    //TODO: fake
    [self.contentView addSubview:({
        UILabel *rankLb = [UILabel new];
        rankLb.text = @"一等奖";
        rankLb.font = [UIFont fontPFSB14];
        rankLb.textColor = kHexColor(0x6020DB);
        rankLb.textAlignment = NSTextAlignmentCenter;
        rankLb.frame = CGRectMake(0, AD(65), AD(340), AD(20));
        rankLb;
    })];
    
    [self.contentView addSubview:({
        UIImageView *giftImgv = [UIImageView new];
        giftImgv.image = [UIImage imageNamed:@"mac"];
        giftImgv.frame = CGRectMake(AD(80), AD(86), AD(180), AD(108));
        giftImgv;
    })];
    
    [self.contentView addSubview:({
        UILabel *giftLb = [UILabel new];
        giftLb.text = @"Macbook pro 13.3英寸  256GB";
        giftLb.textAlignment = NSTextAlignmentCenter;
        giftLb.font = [UIFont fontPFSB12];
        giftLb.frame = CGRectMake(0, AD(199), AD(340), AD(17));
        giftLb;
    })];
    
    [self.contentView addSubview:({
        UILabel *timeLb = [UILabel new];
        timeLb.text = @"请于2020年11月31号24:00:00前联系客服领取，过期视为放弃！";
        timeLb.textAlignment = NSTextAlignmentCenter;
        timeLb.font = [UIFont fontPFLight:10];
        timeLb.textColor = kHexColor(0x6020DB);
        timeLb.frame = CGRectMake(0, AD(235), AD(340), AD(14));
        timeLb;
    })];
    
    self.Xbtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[UIImage imageNamed:@"wihteClose"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.Xbtn];
    
    return self;
}

@end
