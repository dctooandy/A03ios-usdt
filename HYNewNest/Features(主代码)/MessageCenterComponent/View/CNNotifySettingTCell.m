//
//  CNNotifySettingTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNNotifySettingTCell.h"

@implementation CNNotifySettingTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chose:(UIButton *)sender {
    sender.selected = !sender.selected;
    !_btnClick ?: _btnClick(sender.selected);
}


@end
