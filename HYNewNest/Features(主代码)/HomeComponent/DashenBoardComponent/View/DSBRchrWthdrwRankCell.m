//
//  DSBRchrWthdrwRankCell.m
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRchrWthdrwRankCell.h"
#import "VIPRankGradientTxtLabel.h"

@interface DSBRchrWthdrwRankCell()

@property (weak, nonatomic) IBOutlet UILabel *rankLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *clubRankLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;


@end

@implementation DSBRchrWthdrwRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = kHexColor(0x1C1B34);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupIndexRow:(NSInteger)row dataArr:(NSArray *)arr {
    if (arr.count == 4) {
        _rankLb.text = [NSString stringWithFormat:@"%ld", row + 4];
        _nameLb.text = arr[0];
        _clubRankLb.text = arr[1];
        _amountLb.text = arr[2];
        _timeLb.text = arr[3];
        
        // 上下文裁图片圆角
        _headImv.image = [UIImage imageNamed:@"icon"];
    }
}

@end
