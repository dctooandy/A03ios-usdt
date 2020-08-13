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
@end

@implementation CNElectrionHallCCell

- (void)setModel:(ElecGameModel *)model {
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL getUrlWithString:model.gameImage] placeholderImage:[UIImage imageNamed:@"gamepic-1"]];
    self.titleLb.text = model.gameName;
    self.descLb.text = [NSString stringWithFormat:@"热度%@",model.popularity];
    self.favoBtn.selected = model.isFavorite;
    self.hotIV.hidden = !model.isUpHot;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)collection:(UIButton *)sender {
    !_collectionBlock ?: _collectionBlock(sender, self.model);
}

@end
