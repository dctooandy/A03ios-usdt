//
//  KYMSelectChannelCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMSelectChannelCell.h"

@interface KYMSelectChannelCell ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;

@end
@implementation KYMSelectChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mainView.layer.cornerRadius = 8;
    self.mainView.layer.borderWidth = 0.99;
    self.mainView.layer.borderColor = [UIColor colorWithRed:0xE7 / 255.0 green:0xE8 / 255.0 blue:0xE8 / 255.0 alpha:1].CGColor;
    self.selectedIcon.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedIcon.hidden = !selected;
    if (selected) {
        self.mainView.layer.borderColor = [UIColor colorWithRed:0x55 / 255.0 green:0xAA / 255.0 blue:0xF5 / 255.0 alpha:1].CGColor;
    } else {
        self.mainView.layer.borderColor = [UIColor colorWithRed:0xE7 / 255.0 green:0xE8 / 255.0 blue:0xE8 / 255.0 alpha:1].CGColor;
    }
}

@end
