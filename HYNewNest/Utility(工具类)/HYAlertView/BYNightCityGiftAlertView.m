//
//  BYNightCityGiftAlertView.m
//  HYNewNest
//
//  Created by zaky on 7/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNightCityGiftAlertView.h"
#import "UIColor+Gradient.h"

@interface BYNightCityGiftAlertView()

@property (strong,nonatomic) UIButton *btn;

@end

@implementation BYNightCityGiftAlertView

+ (void)showAlertViewHandler:(AlertComfirmBlock)block {
    BYNightCityGiftAlertView *a = [[BYNightCityGiftAlertView alloc] init];
    a.comfirmBlock = block;
    [a setupViews];
    [a show];
}

- (void)setupViews {
    self.frame = [[UIScreen mainScreen] bounds];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView).offset(-30);
        make.leading.equalTo(self.bgView).offset(30);
        make.trailing.equalTo(self.bgView).offset(-30);
        make.height.mas_equalTo(267);
    }];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = kHexColor(0xFFFFFF);
    
    UIImageView *imgv = [UIImageView new];
    imgv.image = [UIImage imageNamed:@"icon_jb"];
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.topMargin.mas_equalTo(17);
        make.width.mas_equalTo(89);
        make.height.mas_equalTo(99);
    }];
    
    UILabel *title = [UILabel new];
    title.text = @"欢迎回归";
    title.textColor = kHexColor(0x658CFF);
    title.font = [UIFont fontPFM16];
    [title sizeToFit];
    [self.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(imgv.mas_bottom).offset(16);
    }];
    
    UILabel *contet = [UILabel new];
    contet.text = @"送您1张币游不夜城抽奖券";
    contet.textColor = kHexColor(0x000000);
    contet.font = [UIFont fontPFR12];
    [contet sizeToFit];
    [self.contentView addSubview:contet];
    [contet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(title.mas_bottom).offset(2);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"去抽奖" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontPFSB18];
    self.btn = btn;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(63);
    }];
    [btn addTarget:self action:@selector(didTapGoNightCity) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *clobtn = [[UIButton alloc] init];
    [clobtn setImage:[UIImage imageNamed:@"icon_witBg_close"] forState:UIControlStateNormal];
    [self.bgView addSubview:clobtn];
    [clobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.contentView.mas_bottom).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    [clobtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIColor *gcolor = [UIColor gradientColorImageFromColors:@[kHexColor(0x55A1FF),kHexColor(0x865FFF)] gradientType:GradientTypeUprightToLowleft imgSize:CGSizeMake(self.contentView.width, 63)];
    [self.btn setBackgroundColor:gcolor];
}

- (void)didTapGoNightCity {
    if (self.comfirmBlock) {
        self.comfirmBlock(true);
    }
    [self dismiss];
}

@end
