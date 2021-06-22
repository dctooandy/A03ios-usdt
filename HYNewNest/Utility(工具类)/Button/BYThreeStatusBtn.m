//
//  BYThreeStatusBtn.m
//  HYNewNest
//
//  Created by zaky on 4/13/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYThreeStatusBtn.h"

@implementation BYThreeStatusBtn


#pragma mark - View Life Cycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 监听
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    // 默认属性
    self.titleLabel.font = [UIFont systemFontOfSize:self.txtSize?:16 weight:UIFontWeightMedium];
    
    // 默认样式
    [self renewStatusStyle];
//    self.status = CNThreeStaBtnStatusGradientBackground;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cornerRadius > 0) {
        self.layer.cornerRadius = self.cornerRadius;
    }else{
        self.layer.cornerRadius = self.height*0.5;
    }
    self.layer.masksToBounds = YES;
}


#pragma mark - Setter

- (void)setIbStatus:(NSInteger)ibStatus {
    _ibStatus = ibStatus;
    self.status = (CNThreeStaBtnStatus)ibStatus;
}

- (void)setStatus:(CNThreeStaBtnStatus)status {
    _status = status;
    [self renewStatusStyle];
}

- (void)setTxtSize:(CGFloat)txtSize {
    self.titleLabel.font = [UIFont systemFontOfSize:txtSize weight:UIFontWeightMedium];
    [self renewStatusStyle];
}


#pragma mark - Custom
- (void)renewStatusStyle {
    if (self.status == CNThreeStaBtnStatusGradientBorder) {
        CGFloat txtWidth = [self.titleLabel.text jk_widthWithFont:self.titleLabel.font constrainedToHeight:self.height];
        UIColor *gradColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:txtWidth];
        
        [self setTitleColor:gradColor forState:UIControlStateNormal];
        self.layer.borderColor = gradColor.CGColor;
        self.layer.borderWidth = 1.0;
        [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal]; // 无背景
        
    } else if (self.status == CNThreeStaBtnStatusGradientBackground) {
        [self setTitleColor:kHexColorAlpha(0xFFFFFF, 1.0) forState:UIControlStateNormal];
        self.layer.borderWidth = 0.0;
        // 渐变色背景
        if (self.cornerRadius > 0) {
            UIImage *bgimg = [UIColor gradientImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeUprightToLowleft imgSize:CGSizeMake(self.width, self.height)];
            [self setBackgroundImage:bgimg forState:UIControlStateNormal];
        } else {
            [self setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
        }
        
    } else {
        [self setTitleColor:kHexColorAlpha(0xFFFFFF, 0.3) forState:UIControlStateNormal];
        self.layer.borderWidth = 0.0;
        [self setBackgroundImage:[UIImage imageNamed:@"l_btn_hh"] forState:UIControlStateNormal]; // 灰色背景
    }
}


#pragma mark - KVO 高亮状态让边框变成半透明
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == self && [keyPath isEqualToString:@"highlighted"]) {
        [self setIsThirdStatusButtonBorder:(UIButton *)object];
    }
}

- (void)setIsThirdStatusButtonBorder:(UIButton *)button{
    // 只需要修改border样式的点击效果
    if (self.status == CNThreeStaBtnStatusGradientBorder) {
        if (button.state == UIControlStateNormal) {
            UIColor *gradColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:self.width];
            self.layer.borderColor = gradColor.CGColor;
            self.layer.borderWidth = 1.0;
        }
        else if (button.state == UIControlStateHighlighted) {
            UIColor *gradColor = [UIColor gradientFromColor:kHexColorAlpha(0x10B4DD, 0.3) toColor:kHexColorAlpha(0x19CECE, 0.3) withWidth:self.width];
            self.layer.borderColor = gradColor.CGColor;
            self.layer.borderWidth = 1.0;
        }
    }
}

@end
