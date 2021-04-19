//
//  HYOneImgBtnAlertView.m
//  HYNewNest
//
//  Created by zaky on 4/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYOneImgBtnAlertView.h"
#import "CNTwoStatusBtn.h"

@implementation HYOneImgBtnAlertView

+ (void)showWithImgName:(NSString *)img
          contentString:(NSString *)content
                btnText:(NSString *)text
                handler:(void (^)(BOOL isComfirm))handler{
    
    HYOneImgBtnAlertView *a = [[HYOneImgBtnAlertView alloc] initWithImgName:img contentString:content handler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithImgName:(NSString *)img contentString:(NSString *)content handler:(void (^)(BOOL isComfirm))handler {
    self = [super init];
    
    self.comfirmBlock = handler;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(30);
        make.right.equalTo(self.bgView).offset(-30);
        make.height.mas_equalTo(345);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(byebye) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:img];
    imgv.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(72);
    }];
    
    UILabel *lblContent = [[UILabel alloc] init];
    lblContent.numberOfLines = 0;
    lblContent.text = content;
    lblContent.font = [UIFont fontPFR14];
    lblContent.textColor = kHexColor(0xCCCCC0);
    lblContent.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:lblContent];
    [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AD(22));
        make.right.equalTo(self.contentView).offset(AD(-22));
        make.top.equalTo(imgv.mas_bottom).offset(20);
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"联系客服" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addCornerAndShadow];
    
    return self;
}

#pragma mark - Public

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
