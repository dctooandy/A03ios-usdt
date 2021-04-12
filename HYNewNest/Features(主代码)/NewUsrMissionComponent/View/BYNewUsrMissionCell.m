//
//  BYNewUsrMissionCell.m
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionCell.h"
#import "CNTwoStatusBtn.h"

@interface BYNewUsrMissionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *aBtn;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgv;

@end

@implementation BYNewUsrMissionCell

- (void)setIsUpgradeTask:(BOOL)isUpgradeTask {
    _isUpgradeTask = isUpgradeTask;
    if (isUpgradeTask) {
        _tagImgv.image = [UIImage imageNamed:@"_progress"];
    } else {
        _tagImgv.image = [UIImage imageNamed:@"_limited time"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
