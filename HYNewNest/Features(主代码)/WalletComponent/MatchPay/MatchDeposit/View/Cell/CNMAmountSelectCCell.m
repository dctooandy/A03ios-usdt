//
//  CNMAmountSelectCCell.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/16/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMAmountSelectCCell.h"

@implementation CNMAmountSelectCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    self.bgView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.amountLb.textColor = UIColor.whiteColor;
        self.bgView.backgroundColor = kHexColor(0x10B4DD);
    } else {
        self.amountLb.textColor = kHexColor(0x10B4DD);
        self.bgView.backgroundColor = [UIColor clearColor];
    }
}
@end
