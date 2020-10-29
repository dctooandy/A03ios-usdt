//
//  CNAddressAddTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddressAddTCell.h"
#import "UILabel+Gradient.h"

@interface CNAddressAddTCell ()
@end

@implementation CNAddressAddTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.titleLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
