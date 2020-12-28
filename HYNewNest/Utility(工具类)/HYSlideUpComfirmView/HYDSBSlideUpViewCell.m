//
//  HYDSBSlideUpViewCell.m
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYDSBSlideUpViewCell.h"

@implementation HYDSBSlideUpViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = kHexColor(0x202238);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
