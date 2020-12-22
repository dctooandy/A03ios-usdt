//
//  DSBWeekMonthListCell.m
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBWeekMonthListCell.h"

@interface DSBWeekMonthListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@end

@implementation DSBWeekMonthListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//TODO: 抽取？ 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = kHexColorAlpha(0x666666, 0.5);
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = kHexColor(0x2C2B40);
        } completion:nil];
    }
}

- (void)setupDataArr:(NSArray *)arr {
    if (arr.count == 3) {
        _titleLb.text = arr[0];
        _usrNameLb.text = arr[1];
        _amountLb.text = arr[2];
    }
}

@end
