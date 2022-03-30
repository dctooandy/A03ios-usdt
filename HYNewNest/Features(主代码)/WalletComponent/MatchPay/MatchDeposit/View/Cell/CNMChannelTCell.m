//
//  CNMChannelTCell.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/15/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMChannelTCell.h"

@interface CNMChannelTCell ()
@property (weak, nonatomic) IBOutlet UIImageView *channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UILabel *discountLb;
@property (weak, nonatomic) IBOutlet UIImageView *recommendIcon;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@end

@implementation CNMChannelTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.selectIcon setHighlighted:selected];
}

//- (void)setChannel:(BTTMeMainModel *)channel {
//    _channel = channel;
//    self.channelLogo.image = [UIImage imageNamed:channel.iconName];
//    self.discountLb.text = (channel.paymentType == CNPaymentFast) ? @"返利0.5%" : nil;
//    self.channelTitle.text = channel.name;
//    self.recommendIcon.hidden = (channel.paymentType != CNPaymentFast);
//}

@end
