//
//  HYVIPReceiveAlertView.m
//  HYNewNest
//
//  Created by zaky on 9/23/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPReceiveAlertView.h"

@interface HYVIPReceiveAlertView ()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation HYVIPReceiveAlertView

+ (void)showReceiveAlertTimes:(NSInteger)times
                         gift:(NSString *)gift
               comfirmHandler:(void (^)(BOOL))handler {
    
    HYVIPReceiveAlertView *a = [[HYVIPReceiveAlertView alloc] initWithTimes:times gift:gift];
    a.frame = [UIScreen mainScreen].bounds;
    a.comfirmBlock = handler;
    [a show];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addCornerAndShadow];
    self.contentView.frame = CGRectMake(AD(30), AD(188), AD(315), AD(238));
    self.leftBtn.frame = CGRectMake(AD(46), self.contentView.bottom + AD(9), AD(138), AD(40));
    self.rightBtn.frame = CGRectMake(self.leftBtn.right + AD(8), self.leftBtn.top, AD(138), AD(40));
}

- (instancetype)initWithTimes:(NSInteger)times
                         gift:(NSString *)gift {
    self = [super init];
    
    self.contentView.backgroundColor = kHexColor(0xF2EDEA);
    
    UIImageView *topLbBack = [UIImageView new];
    topLbBack.image = [UIImage imageNamed:@"编组 21"];
    topLbBack.frame = CGRectMake(AD(108), AD(22), AD(99), AD(8));
    [self.contentView addSubview:topLbBack];
    
    UILabel *title = [UILabel new];
    title.text = @"确认领取";
    title.font = [UIFont fontPFSB16];
    title.textColor = kHexColor(0xB27F48);
    [title sizeToFit];
    title.center = topLbBack.center;
    [self.contentView addSubview:title];
    
    UILabel *subTitle = [UILabel new];
    subTitle.text = [NSString stringWithFormat:@"( 您当前有: %ld次累计身份 )", times];//ex
    subTitle.textColor = kHexColor(0x000000);
    subTitle.font = [UIFont fontPFR12];
    [subTitle sizeToFit];
    subTitle.top = topLbBack.bottom + AD(9);
    subTitle.centerX = topLbBack.centerX;
    [self.contentView addSubview:subTitle];
    
    UIImageView *giftImgv = [UIImageView new];
    giftImgv.image = [UIImage imageNamed:@"1"];//ex
    giftImgv.frame = CGRectMake(AD(97), AD(83), AD(121), AD(61));
    [self.contentView addSubview:giftImgv];
    
    UILabel *giftName = [UILabel new];
    giftName.frame = CGRectMake(AD(97), AD(142), AD(121), AD(29));
    giftName.textAlignment = NSTextAlignmentCenter;
    giftName.text = gift;//ex
    giftName.backgroundColor = [UIColor gradientFromColor:kHexColor(0xA6683B) toColor:kHexColor(0xDA9F5E) withWidth:AD(121)];
    giftName.textColor = kHexColor(0xFFFFFF);
    giftName.font = [UIFont fontPFR14];
    [self.contentView addSubview:giftName];
    
    UILabel *tipsLb = [UILabel new];
    tipsLb.text = @"领取成功之后，累计身份数据将从头开始计算\n确认领取吗？";
    tipsLb.numberOfLines = 2;
    tipsLb.textAlignment = NSTextAlignmentCenter;
    tipsLb.frame = CGRectMake(AD(37), giftName.bottom + AD(11), AD(240), AD(40));
    tipsLb.textColor = kHexColor(0x8F1C34);
    tipsLb.font = [UIFont fontPFM12];
    [self.contentView addSubview:tipsLb];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setTitle:@"不领了，冲击更高奖励" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont fontPFR12];
    [leftBtn setTitleColor:kHexColor(0xCFA461) forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.layer.cornerRadius = AD(5);
    leftBtn.layer.borderWidth = AD(1);
    leftBtn.layer.borderColor = kHexColor(0xCFA461).CGColor;
    [leftBtn addTarget:self action:@selector(didTapLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [self.bgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"确认领取" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontPFR12];
    [rightBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    rightBtn.backgroundColor = kHexColor(0xCFA461);
    rightBtn.layer.cornerRadius = AD(5);
    [rightBtn addTarget:self action:@selector(didTapRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [self.bgView addSubview:rightBtn];
    
    return self;
}

- (void)didTapLeftBtn {
    if (self.comfirmBlock) {
        self.comfirmBlock(NO);
    }
    
    [self dismiss];
}

- (void)didTapRightBtn {
    if (self.comfirmBlock) {
        self.comfirmBlock(YES);
    }
    
    [self dismiss];
}

@end
