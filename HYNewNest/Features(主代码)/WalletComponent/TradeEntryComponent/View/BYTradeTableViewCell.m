//
//  BYWithdrawYuEBaoTableViewCell.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYTradeTableViewCell.h"
#import "UILabel+Gradient.h"

@interface BYTradeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *tradeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end

@implementation BYTradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setupGradientColorFrom:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithItem:(TradeEntrySetTypeItem *)item row:(NSInteger)row {

    self.suggestionImageView.hidden = row == 0 ? false : true;
    self.tradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%li", item.icon, row]];
    self.titleLabel.text = item.name;
    self.subTitleLabel.text = item.text;
}

@end
