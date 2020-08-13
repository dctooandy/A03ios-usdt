//
//  CNChoseImageCCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNChoseImageCCell.h"

@implementation CNChoseImageCCell
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageV.layer.borderWidth = 3;
        self.imageV.layer.borderColor = kHexColor(0x19CECE).CGColor;
    } else {
        self.imageV.layer.borderWidth = 2;
        self.imageV.layer.borderColor = kHexColor(0x6D778B).CGColor;
    }
}
@end
