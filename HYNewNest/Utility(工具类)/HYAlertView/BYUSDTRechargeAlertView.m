//
//  BYUSDTRechargeAlertView.m
//  HYNewNest
//
//  Created by RM04 on 2021/8/27.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYUSDTRechargeAlertView.h"

@implementation BYUSDTRechargeAlertView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (void)showAlertWithContent:(NSString *)content
                 confirmText:(NSString *)confirmText
              comfirmHandler:(void(^)(BOOL isComfirm))handler {
    BYUSDTRechargeAlertView *alertView = [[BYUSDTRechargeAlertView alloc] initAlertWithContent:content confirmText:confirmText comfirmHandler:handler];
    [alertView show];
}

- (instancetype)initAlertWithContent:(NSString *)content
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
    
    UIButton *switchCNYButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCNYButton setTitle:confirmText forState:UIControlStateNormal];
    [switchCNYButton setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    [switchCNYButton setBackgroundImage:[UIColor gradientImageFromColors:@[kHexColor(0x10B4DD),kHexColor(0x19CECE)]
                                                             gradientType:GradientTypeLeftToRight
                                                                  imgSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [switchCNYButton addTarget:self action:@selector(comfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    switchCNYButton.titleLabel.font = [UIFont fontPFSB18];
    switchCNYButton.layer.cornerRadius = 25;
    switchCNYButton.layer.masksToBounds = true;
    [self.contentView addSubview:switchCNYButton];
    
    [switchCNYButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.leading.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(50);
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
