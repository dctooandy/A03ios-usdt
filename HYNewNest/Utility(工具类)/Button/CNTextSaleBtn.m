//
//  CNTextSaleBtn.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNTextSaleBtn.h"

@implementation CNTextSaleBtn

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
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 0.5) forState:UIControlStateNormal];
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 1.0) forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}
@end
