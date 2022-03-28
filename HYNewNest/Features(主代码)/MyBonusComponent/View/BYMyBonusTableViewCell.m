//
//  BYMyBonusTableViewCell.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBonusTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

@interface BYMyBonusTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
//@property (weak, nonatomic) IBOutlet UIView *btmBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@end
@implementation BYMyBonusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = KColorRGB(16, 16, 28);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topImgView.backgroundColor = kHexColor(0x1F1F37);
//    self.btmBgView.backgroundColor = kHexColor(0x1F1F37);

}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *topPath = [UIBezierPath bezierPathWithRoundedRect:self.topImgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *topMask = [CAShapeLayer layer];
        topMask.path = topPath.CGPath;
        self.topImgView.layer.mask = topMask;
        
//        UIBezierPath *btmPath = [UIBezierPath bezierPathWithRoundedRect:self.btmBgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *btmMask = [CAShapeLayer layer];
//        btmMask.path = btmPath.CGPath;
//        self.btmBgView.layer.mask = btmMask;
    });
}
- (void)setModel:(BYMyBounsModel *)model {
    _model = model;
    
    [self.topImgView sd_setImageWithURL:[NSURL getUrlWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"banner--sport-2"]];
    self.lblEndDate.text = [NSString stringWithFormat:@"有效期:%@至%@",model.shortCreatedDate,model.shortMaturityDate];
    
    self.currencyLabel.text = model.currency;
    self.amountLabel.text = model.amount;
    NSString *betAmountString = model.betAmount;
    if ([model.promotionName containsString:@"存送"])
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内充值满%@%@再领取红包,%@倍流水取款,逾期作废",betAmountString,model.currency,betAmountString];
    }else
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内领取红包,%@倍流水取款,逾期作废",betAmountString];
    }
    //测试用
//    model.status = @"4";
    if ([model.status isEqualToString:@"1"])
    {
        [self.actionButton setTitle:@"立即领取" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"2"])
    {
        [self.actionButton setTitle:@"已领取" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"3"])
    {
        [self.actionButton setTitle:@"已过期" forState:UIControlStateNormal];
    }else
    {
        [self.actionButton setTitle:@"前往充值" forState:UIControlStateNormal];
    }
   
    
}


// 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = kHexColor(0x333333);
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = KColorRGB(16, 16, 28);
        } completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapMoreAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"前往充值"])
    {
        if (self.goDepositAction)
        {
            self.goDepositAction();
        }
    }else if ([sender.titleLabel.text isEqualToString:@"立即领取"])
    {
        if (self.goFetchAction)
        {
            self.goFetchAction(_model.requestId);
        }
    }
}

@end
