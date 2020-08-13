//
//  HYOneBtnAlertView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYOneBtnAlertView.h"
#import "CNTwoStatusBtn.h"


@implementation HYOneBtnAlertView

+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          comfirmText:(NSString *)comfirmText
       comfirmHandler:(void(^)(void))handler{
    
    HYOneBtnAlertView *a = [[HYOneBtnAlertView alloc] initWithTitle:title content:content comfirmText:comfirmText comfirmHandler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  comfirmText:(NSString *)comfirmText
               comfirmHandler:(void (^)(void))handler {
    self = [super init];
    self.easyBlock = handler;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(AD(60));
        make.right.equalTo(self.bgView).offset(-AD(60));
        make.height.mas_equalTo(AD(189));//两行文字高度
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = title;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFM16];
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [self.contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.topMargin.height.mas_equalTo(AD(16));
    }];
    
    UILabel *lblContent = [[UILabel alloc] init];
    lblContent.text = content;
    lblContent.font = [UIFont fontPFR14];
    lblContent.numberOfLines = 0;
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.6);
    [self.contentView addSubview:lblContent];
    [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AD(22));
        make.right.equalTo(self.contentView).offset(AD(-22));
        make.topMargin.mas_equalTo(AD(48));
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:comfirmText forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblContent.mas_bottom).offset(AD(20));
        make.left.equalTo(self.contentView).offset(AD(22));
        make.right.equalTo(self.contentView).offset(AD(-22));
        make.height.mas_equalTo(AD(48));
    }];
    
    //更新约束 适配文字高度
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(AD(60));
        make.right.equalTo(self.bgView).offset(-AD(60));
        make.bottom.equalTo(btn.mas_bottom).offset(AD(25));
    }];
    [self.contentView addCornerAndShadow];
    
    return self;
}

- (void)comfirmClick {
    if (self.easyBlock) {
        self.easyBlock();
    }
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
