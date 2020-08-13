//
//  HYTextAlertView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYTextAlertView.h"
#import "UILabel+Gradient.h"

@interface HYTextAlertView()
@property (nonatomic, strong) UIButton *btnComfirm;
@end

@implementation HYTextAlertView

+ (void)showWithTitle:(NSString *)title content:(NSString *)content comfirmText:(NSString *)comfirmText cancelText:(nullable NSString *)cancelText comfirmHandler:(void (^)(BOOL isComfirm))handler {
    HYTextAlertView *a = [[HYTextAlertView alloc] initWithTitle:title content:content comfirmText:comfirmText cancelText:cancelText comfirmHandler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                  comfirmText:(NSString *)comfirmText
                   cancelText:(nullable NSString *)cancelText
               comfirmHandler:(void (^)(BOOL isComfirm))handler {
    self = [super init];
    self.comfirmBlock = handler;
    
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = title;
    lblTitle.frame = CGRectMake(0, AD(16), AD(255), AD(16));
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFM16];
    lblTitle.textColor = kHexColor(0xFFFFFF);
    [self.contentView addSubview:lblTitle];
    
    UILabel *lblContent = [[UILabel alloc] init];
    lblContent.text = content;
    CGFloat height = [content jk_heightWithFont:[UIFont fontPFR14] constrainedToWidth:AD(211)];
    lblContent.frame = CGRectMake(AD(22), AD(48), AD(211), height);
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.font = [UIFont fontPFR14];
    lblContent.numberOfLines = 0;
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    [self.contentView addSubview:lblContent];
    
    UIButton *btnComfirm = [UIButton buttonWithType:UIButtonTypeSystem];
    btnComfirm.frame = CGRectMake(0, lblContent.bottom + AD(28), AD(255), AD(50));
    [btnComfirm setTitle:comfirmText forState:UIControlStateNormal];
    btnComfirm.titleLabel.font = [UIFont fontPFM16];
    [btnComfirm setTitleColor:kHexColor(0x10B4DD) forState:UIControlStateNormal];
    [btnComfirm addLineDirection:LineDirectionTop color:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5]; //上边线
    btnComfirm.tag = 123;
    [btnComfirm addTarget:self action:@selector(comfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnComfirm];
    self.btnComfirm = btnComfirm;
    
    if (cancelText) {
        btnComfirm.frame = CGRectMake(AD(255/2.0), lblContent.bottom + AD(28), AD(255/2.0), AD(50));
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        btnCancel.frame = CGRectMake(0, btnComfirm.y, AD(255/2.0), 50);
        [btnCancel setTitle:cancelText forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont fontPFM16];
        [btnCancel setTitleColor:kHexColorAlpha(0xFFFFFF, 0.9) forState:UIControlStateNormal];
        [btnCancel addLineDirection:LineDirectionTop color:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5]; // 上边线
        [btnCancel addLineDirection:LineDirectionRight color:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5]; //右边线
        [btnCancel addTarget:self action:@selector(comfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnCancel];
    }
    
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(AD(60), 0.5*(kScreenHeight-self.btnComfirm.bottom), AD(255), self.btnComfirm.bottom);
    [self.contentView addCornerAndShadow];
}

- (void)comfirmClick:(UIButton *)sender {
    if (self.comfirmBlock) {
        self.comfirmBlock(sender.tag == 123);
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
