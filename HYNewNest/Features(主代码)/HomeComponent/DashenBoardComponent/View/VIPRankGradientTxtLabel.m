//
//  VIPRankGradientTxtLabel.m
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "VIPRankGradientTxtLabel.h"
#import "UILabel+Gradient.h"
#import "BYDashenBoardConst.h"

@implementation VIPRankGradientTxtLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setText:(NSString *)text {
    [super setText:text];
    if ([text isEqualToString:@"赌尊"]) {
        [self setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kDuzunColor1 toColor:kDuzunColor2];
    } else if ([text isEqualToString:@"赌神"]) {
        [self setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kDuGodColor1 toColor:kDuGodColor2];
    } else if ([text isEqualToString:@"赌圣"]) {
        [self setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kDuSaintColor1 toColor:kDuSaintColor2];
    } else if ([text isEqualToString:@"赌王"]) {
        self.textColor = kDuKingColor;
    } else if ([text isEqualToString:@"赌霸"]) {
        self.textColor = kDuBaColor;
    } else if ([text isEqualToString:@"赌侠"]) {
        self.textColor = kDuXiaColor;
    } else {
        [self setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kVIPColor1 toColor:kVIPColor2];
    }
}

@end
