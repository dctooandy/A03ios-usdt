//
//  HYBonusCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYBonusCell.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

@interface HYBonusCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIView *btmBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UIImageView *toprightTag2Imgv;
@property (weak, nonatomic) IBOutlet UIImageView *toprightTagImgv;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation HYBonusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = KColorRGB(16, 16, 28);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topImgView.backgroundColor = kHexColor(0x1F1F37);
    self.btmBgView.backgroundColor = kHexColor(0x1F1F37);

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *topPath = [UIBezierPath bezierPathWithRoundedRect:self.topImgView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *topMask = [CAShapeLayer layer];
        topMask.path = topPath.CGPath;
        self.topImgView.layer.mask = topMask;
        
        UIBezierPath *btmPath = [UIBezierPath bezierPathWithRoundedRect:self.btmBgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *btmMask = [CAShapeLayer layer];
        btmMask.path = btmPath.CGPath;
        self.btmBgView.layer.mask = btmMask;
    });
}

- (void)setModel:(MyPromoItem *)model {
    _model = model;
    
    self.lblTitle.text = model.title;
    [self.topImgView sd_setImageWithURL:[NSURL getUrlWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"3"]];
    self.lblEndDate.text = [NSString stringWithFormat:@"截止时间:%@",model.endDate];
    
    self.shadowView.hidden = YES;
    self.toprightTagImgv.image = nil;
    self.toprightTag2Imgv.image = nil;
    
    // 置顶
    if (model.isTop == 1) {
        self.toprightTagImgv.image = [UIImage imageNamed:@"zd"];
    }
    // 结束
    else if ([model.imgTip isEqualToString:@"结束"]) {
        self.toprightTagImgv.image = [UIImage imageNamed:@"end"];
        self.toprightTag2Imgv.image = nil;
        self.shadowView.hidden = NO;
        return;
    }
    
    // 长期活动
    if (model.endDate.length == 0) {
        if (model.isTop == 1) {
            self.toprightTag2Imgv.image = [UIImage imageNamed:@"cq"];
        } else {
            self.toprightTagImgv.image = [UIImage imageNamed:@"cq"];
        }
    }
    // 限时活动
    else if ([model.imgTip isEqualToString:@"限时"]) {
        if (model.isTop == 1) {
            self.toprightTag2Imgv.image = [UIImage imageNamed:@"xs"];
        } else {
            self.toprightTagImgv.image = [UIImage imageNamed:@"xs"];
        }
    }
    // 新活动？
    
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

@end
