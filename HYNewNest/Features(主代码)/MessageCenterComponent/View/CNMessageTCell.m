//
//  CNMessageTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMessageTCell.h"
#import "UIColor+Gradient.h"

@implementation CNMessageTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLb.font = [UIFont systemFontOfSize:AD(12)];
    self.markLabel.backgroundColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:CGRectGetWidth(self.markLabel.frame)];
    self.markLabel.layer.cornerRadius = 5;
    self.markLabel.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
