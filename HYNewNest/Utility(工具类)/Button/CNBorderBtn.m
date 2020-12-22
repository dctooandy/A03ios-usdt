//
//  CNBorderBtn.m
//  HYNewNest
//
//  Created by zaky on 12/16/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBorderBtn.h"

@implementation CNBorderBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
//    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:kHexColor(0x6020DB) forState:UIControlStateNormal];
//    [self setTitleColor:kHexColorAlpha(0x10B4DD, 1.0) forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont fontPFSB12];
    
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = kHexColor(0x6020DB).CGColor;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = kHexColorAlpha(0x6020DB, 0.5).CGColor;
    } else {
        self.layer.borderColor = kHexColor(0x6020DB).CGColor;
    }
}

@end
