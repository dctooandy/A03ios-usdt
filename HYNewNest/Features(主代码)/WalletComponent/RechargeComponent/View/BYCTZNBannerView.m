//
//  BYCTZNBannerView.m
//  HYNewNest
//
//  Created by zaky on 3/31/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYCTZNBannerView.h"
#import "HYNewCTZNViewController.h"

@implementation BYCTZNBannerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"ctzn-banner"];
    imgv.userInteractionEnabled = YES;
    imgv.layer.cornerRadius = 10;
    imgv.layer.masksToBounds = YES;
    [self addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    [imgv addGestureRecognizer:tap];
    
    UILabel *titLb = [UILabel new];
    titLb.text = @"充提指南";
    titLb.font = [UIFont fontPFSB18];
    titLb.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [imgv addSubview:titLb];
    [titLb sizeToFit];
    [titLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgv.mas_right).offset(-59);
        make.top.equalTo(imgv).offset(34);
    }];
    
    UILabel *detalLb = [UILabel new];
    detalLb.text = @"安全简单，了解一下";
    detalLb.font = [UIFont fontPFSB12];
    detalLb.textColor = kHexColorAlpha(0xFFFFFF, 0.7);
    [imgv addSubview:detalLb];
    [detalLb sizeToFit];
    [detalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titLb).offset(-10);
        make.top.equalTo(titLb.mas_bottom).offset(7);
    }];
    
    UIImageView *imgIcon = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"right1"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgIcon.image = img;
    imgIcon.tintColor = kHexColorAlpha(0xFFFFFF, 0.8);
    [imgv addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detalLb);
        make.left.equalTo(detalLb.mas_right).offset(4);
        make.height.width.mas_equalTo(18);
    }];
}

- (void)tapBanner:(UITouch *)touch {
    [NNPageRouter jump2HTMLWithStrURL:@"/tutorialReference" title:@"请稍等.." needPubSite:YES];
//    UIViewController *vc = [NNControllerHelper getCurrentViewController];
//    [vc presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
//    }];
}

@end
