//
//  BYGloryTimelineTableViewCell.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/19.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryTimelineTableViewCell.h"
#import "BYDottedLine.h"
#import "NSURL+HYLink.h"
#import <UIImageView+WebCache.h>

@interface BYGloryTimelineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *timelineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet BYDottedLine *dottedlineBackground;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *timelineLabel;

@end

@implementation BYGloryTimelineTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCell:(BYGloryModel *)model {
    [self.contentLabel setText: KIsEmptyString(model.abstractName)?model.titleName:model.abstractName];
    [self.timelineImageView sd_setImageWithURL:[NSURL getUrlWithString:model.bannerUrl]];
    [self.timelineLabel setText:model.publishDate];
    [self hideDottedline:false];
    [self setToDefault];
}

- (void)setToDefault {
    [self.iconImageView setImage:[UIImage imageNamed:@"icon_circle_dim"]];
    [self.maskView setAlpha:0.7];
}

- (void)setMaskAlpha:(CGFloat)alpha{
    if (alpha <= 0.5) {
        [self.iconImageView setImage:[UIImage imageNamed:@"icon_circle_light"]];
    }
    else {
        [self.iconImageView setImage:[UIImage imageNamed:@"icon_circle_dim"]];
    }
    
    [self.maskView setAlpha:MIN(0.7, alpha)];
}

- (void)hideDottedline:(BOOL)hidedn {
    [self.dottedlineBackground setHidden:hidedn];
}

@end
