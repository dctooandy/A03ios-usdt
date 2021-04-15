//
//  HYWideOneBtnAlertView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWideOneBtnAlertView.h"
#import "CNTwoStatusBtn.h"

@interface HYWideOneBtnAlertView ()
@end

@implementation HYWideOneBtnAlertView

+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          comfirmText:(NSString *)comfirmText
       comfirmHandler:(nullable void(^)(void))handler{
    
    HYWideOneBtnAlertView *a = [[HYWideOneBtnAlertView alloc] initWithTitle:title content:content comfirmText:comfirmText comfirmHandler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  comfirmText:(NSString *)comfirmText
               comfirmHandler:(nullable void (^)(void))handler {
    self = [super init];
    self.easyBlock = handler;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(AD(15));
        make.right.equalTo(self.bgView).offset(-AD(15));
        make.height.mas_equalTo(AD(345));
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = title;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AD(16)];
    lblTitle.textColor = kHexColor(0xFFFFFF);
    [self.contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(AD(50));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.1);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(lblTitle.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"tips-close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.height.width.mas_equalTo(AD(50));
    }];
    
    UILabel *lblContent = [[UILabel alloc] init];
    lblContent.text = content;
    lblContent.font = [UIFont systemFontOfSize:AD(15)];
    lblContent.numberOfLines = 0;
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.6);
    [self.contentView addSubview:lblContent];
    [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AD(30));
        make.right.equalTo(self.contentView).offset(AD(-30));
        make.top.equalTo(lblTitle.mas_bottom).offset(AD(31));
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:comfirmText forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblContent.mas_bottom).offset(AD(32));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(AD(232));
        make.height.mas_equalTo(comfirmText.length?AD(48):0);
    }];
    
    //更新约束 适配文字高度
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(AD(15));
        make.right.equalTo(self.bgView).offset(-AD(15));
        make.bottom.equalTo(btn.mas_bottom).offset(AD(32));
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
