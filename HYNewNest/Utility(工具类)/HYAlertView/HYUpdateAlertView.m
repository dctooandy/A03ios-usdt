//
//  HYUpdateAlertView.m
//  HYNewNest
//
//  Created by zaky on 8/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYUpdateAlertView.h"
#import "CNTwoStatusBtn.h"

@implementation HYUpdateAlertView

+ (void)showWithVersionString:(NSString *)string isForceUpdate:(BOOL)isForce handler:(void (^)(BOOL isComfirm))handler {
    HYUpdateAlertView *a = [[HYUpdateAlertView alloc] initWithVersionString:string isForceUpdate:isForce handler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithVersionString:(NSString *)string isForceUpdate:(BOOL)isForce handler:(void (^)(BOOL isComfirm))handler {
    self = [super init];
    
    self.comfirmBlock = handler;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(50);
        make.right.equalTo(self.bgView).offset(-50);
        make.height.mas_equalTo(308);
    }];
    
    if (!isForce) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(byebye) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
            make.top.equalTo(self.contentView).offset(8);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"DL-pic-newer"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.contentView).offset(41);
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"发现新版本";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFSB16];
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [self.contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(imgv.mas_bottom).offset(30);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *lblContent = [[UILabel alloc] init];
    if (string.length > 6) {
        lblContent.text = string;
    } else {
        lblContent.text = [NSString stringWithFormat:@"最新版本 V%@",string];
    }
    lblContent.font = [UIFont fontPFR14];
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    [self.contentView addSubview:lblContent];
    [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AD(22));
        make.right.equalTo(self.contentView).offset(AD(-22));
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"立即更新版本" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self.contentView).offset(-23);
    }];
    
    [self.contentView addCornerAndShadow];
        
    return self;
}

- (void)byebye {
    if (self.comfirmBlock) {
        self.comfirmBlock(NO);
    }
    [self dismiss];
}

- (void)comfirmClick {
    if (self.comfirmBlock) {
        self.comfirmBlock(YES);
    }
    [self dismiss];
}

@end
