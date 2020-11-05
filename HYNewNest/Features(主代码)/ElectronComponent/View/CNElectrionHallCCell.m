//
//  CNElectrionHallCCell.m
//  HYNewNest
//
//  Created by Cean on 2020/8/4.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNElectrionHallCCell.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

@interface CNElectrionHallCCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIButton *favoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *hotIV;

@property (weak, nonatomic) IBOutlet UILabel *platformLb;
@property (weak, nonatomic) IBOutlet UILabel *lineLb;
@property (weak, nonatomic) IBOutlet UILabel *discountLb;

@end

@implementation CNElectrionHallCCell

- (void)setModel:(ElecGameModel *)model {
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL getUrlWithString:model.gameImage] placeholderImage:[UIImage imageNamed:@"1"]];
    self.titleLb.text = model.gameName;
    self.descLb.text = [NSString stringWithFormat:@"热度%@",model.popularity];
    self.favoBtn.selected = model.isFavorite;
    self.hotIV.hidden = !model.isUpHot;
    
    self.platformLb.text = [NSString stringWithFormat:@" %@ ", model.platformName];
    self.lineLb.text = [NSString stringWithFormat:@" %@线 ", model.payLine];
    self.discountLb.hidden = !model.preferenceFlag;
    [self setNeedsLayout];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.platformLb.layer.cornerRadius = 5;
    self.platformLb.layer.masksToBounds = YES;
    self.lineLb.layer.cornerRadius = 5;
    self.lineLb.layer.masksToBounds = YES;
    self.discountLb.layer.cornerRadius = 5;
    self.discountLb.layer.masksToBounds = YES;
}

- (IBAction)collection:(UIButton *)sender {
    !_collectionBlock ?: _collectionBlock(sender, self.model);
}

@end
