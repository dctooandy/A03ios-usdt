//
//  HYNewCTZNCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYNewCTZNCell.h"
#import <UIImageView+WebCache.h>

@interface HYNewCTZNCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgv;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *bottomBtn;
@end

@implementation HYNewCTZNCell

- (void)setModel:(CTZNModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    
    [self.videoImgv sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"1"]];
    [self.bottomBtn setTitle:model.type forState:UIControlStateNormal];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.type attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:AD(12)], NSForegroundColorAttributeName:kHexColor(0xFFFFFF)}];
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@", model.title] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AD(12)], NSForegroundColorAttributeName:kHexColor(0xFFFFFF)}];
    [attrStr appendAttributedString:detail];
    self.lblDetail.attributedText = attrStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.bottomBtn.enabled = YES;
    self.bottomBtn.layer.cornerRadius = 20;
    self.bottomBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickActionBtn:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(self.model.type);
    }
}

- (IBAction)didClickPlayBtn:(id)sender {
    if (self.playBlock) {
        self.playBlock();
    }
}

@end
