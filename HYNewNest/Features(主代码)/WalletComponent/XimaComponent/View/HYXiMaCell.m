//
//  HYXiMaCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYXiMaCell.h"

@interface HYXiMaCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@end

@implementation HYXiMaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgView addCornerAndShadow];
    self.backgroundColor = kHexColor(0x10101C);
    self.bgView.backgroundColor = kHexColor(0x212137);
    
}

-  (void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    if (isChoose) {
        [self.imgvIcon setImage:[UIImage imageNamed:@"select"]];
    } else {
        [self.imgvIcon setImage:[UIImage imageNamed:@"unSelect"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
