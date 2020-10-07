//
//  CNFeedBackRightTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNFeedBackRightTCell.h"

@implementation CNFeedBackRightTCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 获取内容的宽高, 左右和父视图间隔 （40+18）, 上下间隔 10
    CGFloat maxWidth = kScreenWidth - 58*2;
    CGSize textSize = [self.contentLb.text jk_sizeWithFont:self.contentLb.font constrainedToWidth:maxWidth];
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, textSize.width+36, textSize.height+20) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    layer.path = path.CGPath;
    self.textBGView.layer.mask = layer;
}

@end
