//
//  BYVocherTVCell.m
//  HYNewNest
//
//  Created by zaky on 3/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYVocherTVCell.h"
#import "NSString+Font.h"

@interface BYVocherTVCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLb;
@property (weak, nonatomic) IBOutlet UILabel *streamLb;
@property (weak, nonatomic) IBOutlet UILabel *totalStreamLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progsView;

@property (weak, nonatomic) IBOutlet UILabel *suportGameRightLb;
@property (weak, nonatomic) IBOutlet UIImageView *suportGameRightArr;

@property (weak, nonatomic) IBOutlet UILabel *suportGameDetailLb;

@property (weak, nonatomic) IBOutlet UIButton *btmDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmDetailBtnHCons;

@end

@implementation BYVocherTVCell

- (void)setIsExpand:(BOOL)isExpand {
    _isExpand = isExpand;
    if (isExpand) {
        _suportGameRightLb.hidden = YES;
        _suportGameRightArr.hidden = YES;
        _btmDetailBtn.hidden = NO;
        _btmDetailBtnHCons.constant = 30;
        _suportGameDetailLb.hidden = NO;
        _suportGameDetailLb.text = @"AG旗舰  AG国际  AG彩票AG旗舰  AG国际  AG彩票AG旗舰  AG国际  AG彩票AG旗舰  AG国际  AG彩票";
//        [_suportGameDetailLb sizeToFit];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } else {
        _suportGameRightLb.hidden = NO;
        _suportGameRightArr.hidden = NO;
        _btmDetailBtn.hidden = YES;
        _btmDetailBtnHCons.constant = 0;
        _suportGameDetailLb.hidden = YES;
        _suportGameDetailLb.text = @"";
        [_suportGameDetailLb sizeToFit];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleBtn jk_setImagePosition:LXMImagePositionRight spacing:0];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Action

- (IBAction)didTapDetailBtn:(id)sender {
}


- (IBAction)didTapRuleBtn:(id)sender {
}


- (IBAction)didTapExpandBtn:(id)sender {
    if (self.changeCellHeightBlock) {
        self.changeCellHeightBlock(YES);
    }
}

- (IBAction)didTapBtmBtn:(id)sender {
    if (self.changeCellHeightBlock) {
        self.changeCellHeightBlock(NO);
    }
}

@end
