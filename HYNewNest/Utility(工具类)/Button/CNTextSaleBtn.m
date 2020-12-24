//
//  CNTextSaleBtn.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNTextSaleBtn.h"

@implementation CNTextSaleBtn

@synthesize selColor = _selColor;
@synthesize norColor = _norColor;
@synthesize selFont = _selFont;
@synthesize norFont = _norFont;

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
    if (self.selected) {
        self.titleLabel.font = self.selFont;
    } else {
        self.titleLabel.font = self.norFont;
    }
    [self setTitleColor:self.norColor forState:UIControlStateNormal];
    [self setTitleColor:self.selColor forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = self.selFont;
    } else {
        self.titleLabel.font = self.norFont;
    }
}


#pragma mark - Setter & Getter

- (UIFont *)norFont {
    if (!_norFont) {
        _norFont = [UIFont systemFontOfSize:13];
    }
    return _norFont;
}

- (UIFont *)selFont {
    if (!_selFont) {
        _selFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _selFont;
}

- (UIColor *)norColor {
    if (!_norColor) {
        _norColor = kHexColorAlpha(0xFFFFFF, 0.5);
    }
    return _norColor;
}

- (UIColor *)selColor {
    if (!_selColor) {
        _selColor = kHexColorAlpha(0xFFFFFF, 1.0);
    }
    return _selColor;
}

- (void)setNorColor:(UIColor *)norColor {
    _norColor = norColor;
    [self setTitleColor:norColor forState:UIControlStateNormal];
}

- (void)setSelColor:(UIColor *)selColor {
    _selColor = selColor;
    [self setTitleColor:selColor forState:UIControlStateSelected];
}

- (void)setNorFont:(UIFont *)norFont {
    _norFont = norFont;
    self.titleLabel.font = norFont;
}

- (void)setSelFont:(UIFont *)selFont {
    _selFont = selFont;
    self.titleLabel.font = selFont;
}

@end
