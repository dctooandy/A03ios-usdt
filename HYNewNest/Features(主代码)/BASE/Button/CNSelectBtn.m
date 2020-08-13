//
//  CNSelectBtn.m
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNSelectBtn.h"

@interface CNSelectBtn ()
@property (nonatomic, strong) UIImageView *iv;
@end

@implementation CNSelectBtn

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
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 0.5) forState:UIControlStateNormal];
    [self setTitleColor:kHexColorAlpha(0x10B4DD, 1.0) forState:UIControlStateSelected];
    
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.currentTitleColor.CGColor;
    
    // 添加对勾
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
    [iv sizeToFit];
    CGFloat x = self.bounds.size.width - 17;
    CGFloat y = self.bounds.size.height - 17;
    iv.frame = CGRectMake(x, y, 17, 17);
    [self addSubview:iv];
    self.iv = iv;
    self.iv.hidden = !self.selected;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderColor = selected ? kHexColorAlpha(0x10B4DD, 1.0).CGColor: kHexColorAlpha(0xFFFFFF, 0.5).CGColor;
    self.iv.hidden = !selected;
}
@end
