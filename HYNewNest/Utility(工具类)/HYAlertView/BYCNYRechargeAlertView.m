//
//  BYCNYRechargeAlertView.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYCNYRechargeAlertView.h"
#import "UIColor+Gradient.h"

@implementation BYCNYRechargeAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showAlertWithContent:(NSString *)content
                  cancelText:(NSString *)cancelText
                 confirmText:(NSString *)confirmText
              comfirmHandler:(void(^)(BOOL isComfirm))handler {
    BYCNYRechargeAlertView *alertView = [[BYCNYRechargeAlertView alloc] initAlertWithContent:content
                                                                                  cancelText:cancelText
                                                                                 confirmText:confirmText
                                                                              comfirmHandler:handler];
    [alertView show];
    
}

- (instancetype)initAlertWithContent:(NSString *)content
                          cancelText:(NSString *)cancelText
                         confirmText:(NSString *)confirmText
                      comfirmHandler:(void(^)(BOOL isComfirm))handler {
    self = [super init];
    self.frame = [[UIScreen mainScreen] bounds];
    self.comfirmBlock = handler;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
        make.leading.equalTo(self.bgView).offset(25);
        make.trailing.equalTo(self.bgView).offset(-25);
        make.height.mas_equalTo(220);
    }];
    self.contentView.layer.cornerRadius = 10;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setBackgroundImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:dismissButton];
    
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentLabel setText:content];
    [contentLabel setTextColor:kHexColor(0xFFFFFF)];
    [contentLabel setFont:[UIFont fontPFR18]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [contentLabel setNumberOfLines:2];
    [self.contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(60);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(54);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton jk_setBackgroundColor:kHexColor(0x38385F) forState:UIControlStateNormal];
    [closeButton setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:cancelText forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontPFSB18];
    closeButton.layer.cornerRadius = 25;
    closeButton.layer.masksToBounds = true;
    [self.contentView addSubview:closeButton];
    
    UIButton *switchUSDTButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchUSDTButton setTitle:confirmText forState:UIControlStateNormal];
    [switchUSDTButton setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    [switchUSDTButton setBackgroundImage:[UIColor gradientImageFromColors:@[kHexColor(0x10B4DD),kHexColor(0x19CECE)]
                                                             gradientType:GradientTypeLeftToRight
                                                                  imgSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [switchUSDTButton addTarget:self action:@selector(comfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    switchUSDTButton.titleLabel.font = [UIFont fontPFSB18];
    switchUSDTButton.layer.cornerRadius = 25;
    switchUSDTButton.layer.masksToBounds = true;
    
    [self.contentView addSubview:switchUSDTButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.leading.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(50);
        make.trailing.equalTo(switchUSDTButton.mas_leading).offset(-10);
        make.width.equalTo(switchUSDTButton);
    }];
    
    [switchUSDTButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(50);
        make.width.equalTo(closeButton);
    }];
    
    return self;
}

- (void)comfirmClick:(UIButton *)sender {
    if (self.comfirmBlock) {
        self.comfirmBlock(true);
    }
    [self dismiss];
}

@end
