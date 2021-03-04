//
//  CNTwoStatusBtn.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNTwoStatusBtn.h"
#import "UILabel+Gradient.h"

@implementation CNTwoStatusBtn

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
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 0.3) forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageNamed:@"l_btn_hh"] forState:UIControlStateDisabled];
    // 默认样式
//    [self renewStatusStyle];
    self.status = CNTwoStaBtnStatusGradientBG;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height*0.5;
    self.layer.masksToBounds = YES;
}

- (void)renewStatusStyle {
    if (self.status == CNTwoStaBtnStatusGradientLayer) {
        [self setTitleColor:kHexColor(0x19CECE) forState:UIControlStateNormal];
        UIColor *gradColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:90];
        self.layer.borderColor = gradColor.CGColor;
        self.layer.borderWidth = 1.0;
        [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:kHexColorAlpha(0xFFFFFF, 1.0) forState:UIControlStateNormal];
        self.layer.borderWidth = 0.0;
        [self setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
    }
}


#pragma mark - Setter

- (void)setIbStatus:(NSUInteger)ibStatus {
    _ibStatus = ibStatus;
    self.status = (CNTwoStaBtnStatus)ibStatus;
}

- (void)setStatus:(CNTwoStaBtnStatus)status {
    _status = status;
    switch (status) {
        case CNTwoStaBtnStatusNone:
            self.enabled = NO;
            break;
        default:
            self.enabled = YES;
            break;
    }
    [self renewStatusStyle];
}

- (void)setTxtSize:(CGFloat)txtSize {
    self.titleLabel.font = [UIFont systemFontOfSize:txtSize weight:UIFontWeightMedium];
    [self renewStatusStyle];
}


#pragma mark - KVO 高亮状态让边框变成半透明
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == self && [keyPath isEqualToString:@"highlighted"]) {
        [self setIsThirdStatusButtonBorder:(UIButton *)object];
    }
}

- (void)setIsThirdStatusButtonBorder:(UIButton *)button{
    if (self.status == CNTwoStaBtnStatusGradientLayer) {
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
