//
//  VIPCardCCell.m
//  HYNewNest
//
//  Created by zaky on 8/31/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCardCCell.h"
#import "UILabel+Gradient.h"

@interface VIPCardCCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvCard;
@property (weak, nonatomic) IBOutlet UILabel *lbDuzun;

@end

@implementation VIPCardCCell

- (void)setCardName:(NSString *)cardName {
    _cardName = cardName;
    [self.imgvCard setImage:[UIImage imageNamed:cardName]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.lbTitle setupGradientColorFrom:kHexColor(0xFFFCCC) toColor:kHexColor(0xFACB79)];
    
}


- (void)setDuzunName:(NSString *)duzunName {
    _duzunName = duzunName;
    if (duzunName.length > 0) {
        self.lbDuzun.hidden = NO;
        self.lbDuzun.text = [NSString stringWithFormat:@"　%@　", duzunName];
        [self.lbDuzun sizeToFit];
        self.lbDuzun.backgroundColor = [UIColor gradientFromColor:kHexColorAlpha(0xB66DFB, 0.0) toColor:kHexColorAlpha(0x634AA9, 1.0) withWidth:self.lbDuzun.width];
    } else {
        self.lbDuzun.hidden = YES;
    }
}


@end
