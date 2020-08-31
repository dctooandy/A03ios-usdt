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

@end
