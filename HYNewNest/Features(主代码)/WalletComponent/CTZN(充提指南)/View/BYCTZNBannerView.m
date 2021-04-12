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
    titLb.text = @"充提指南 安全简单";
    titLb.font = [UIFont fontPFSB18];
    titLb.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [imgv addSubview:titLb];
    [titLb sizeToFit];
    [titLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgv.mas_right).offset(-20);
        make.top.equalTo(imgv).offset(34);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.userInteractionEnabled = NO;
    [btn setTitle:@"了解一下" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontPFSB12];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundColor:kHexColor(0x19CECE)];
    [btn setImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
    [imgv addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titLb);
            make.top.equalTo(titLb.mas_bottom).offset(10);
            make.width.mas_equalTo(92);
            make.height.mas_equalTo(25);
    }];
    btn.layer.cornerRadius = 12.5;
    btn.layer.masksToBounds = YES;
    [btn jk_setImagePosition:LXMImagePositionRight spacing:2];
}

- (void)tapBanner:(UITouch *)touch {
//    [NNPageRouter jump2HTMLWithStrURL:@"/tutorialReference" title:@"请稍等.." needPubSite:YES];
    UIViewController *vc = [NNControllerHelper getCurrentViewController];
    [vc presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
    }];
}

@end
