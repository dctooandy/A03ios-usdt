//
//  HYArticalCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYArticalCell.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

@interface HYArticalCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDateStr;
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HYArticalCell

- (void)setModel:(ArticalModel *)model {
    _model = model;
    self.lblTitle.text = model.titleName;
    self.lblSubTitle.text = model.abstractName;
    self.lblDateStr.text = model.publishDate;
    NSString *urlStr = model.bannerUrl;
    
    [self.imgv sd_setImageWithURL:[NSURL getUrlWithString:urlStr] placeholderImage:[UIImage imageNamed:@"1"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = KColorRGB(16, 16, 28);
    self.lineView.backgroundColor = kHexColorAlpha(0x6D778B, 0.3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = kHexColor(0x333333);
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = KColorRGBA(16, 16, 28, 1);
        } completion:nil];
    }
}


@end
