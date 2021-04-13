//
//  BYNewUsrMissionCell.m
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionCell.h"
#import "BYThreeStatusBtn.h"

@interface BYNewUsrMissionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet BYThreeStatusBtn *aBtn;
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

- (void)setResModel:(Result *)resModel {
    _resModel = resModel;
    _titleLb.text = resModel.title;
    _subTitleLb.text = resModel.subtitle;
    _amountLb.text = [NSString stringWithFormat:@"+%@",resModel.amount];
    
    _aBtn.status = (CNThreeStaBtnStatus)resModel.fetchResultFlag;
    switch (resModel.fetchResultFlag) {
        case -1:
            [_aBtn setTitle:@"去完成" forState:UIControlStateNormal];
            break;
        case 0:
            [_aBtn setTitle:@"待领取" forState:UIControlStateNormal];
            break;
        case 1:
            [_aBtn setTitle:@"已领取" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)didTapBtn:(id)sender {
    MyLog(@"%@", _aBtn.titleLabel.text);
}


@end
