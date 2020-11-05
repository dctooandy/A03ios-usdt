//
//  HYBuyECoinCheckboxTag.m
//  HYNewNest
//
//  Created by zaky on 11/5/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYBuyECoinCheckboxTag.h"

@implementation HYBuyECoinCheckboxTag

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    HYBuyECoinCheckboxTag *btn = [super buttonWithType:buttonType];
    [btn setupAttributes];
    return btn;
}

- (void)setupAttributes {
    [self setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontPFR12];
    [self setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
    self.backgroundColor = kHexColor(0x161627);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
}

@end
