//
//  KYMSelectChannelCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMSelectChannelCell.h"

@interface KYMSelectChannelCell ()
@property (weak, nonatomic) IBOutlet UIView *selectedIcon;

@end
@implementation KYMSelectChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedIcon.layer.cornerRadius = 10;
    self.selectedIcon.layer.borderWidth = 1;
    self.selectedIcon.layer.borderColor = [UIColor colorWithRed:0x66 / 255.0 green:0x66 / 255.0 blue:0x66 / 255.0 alpha:1].CGColor;
    self.selectedIcon.layer.masksToBounds = YES;
    self.selectedIcon.backgroundColor = [UIColor colorWithRed:0x27 / 255.0 green:0x27 / 255.0 blue:0x49 / 255.0 alpha:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedIcon.layer.borderWidth = 0;
        self.selectedIcon.layer.borderColor = [UIColor colorWithRed:0x66 / 255.0 green:0x66 / 255.0 blue:0x66 / 255.0 alpha:0].CGColor;
        self.selectedIcon.backgroundColor = [UIColor colorWithRed:0x10 / 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1];
    } else {
        self.selectedIcon.layer.borderWidth = 1;
        self.selectedIcon.layer.borderColor = [UIColor colorWithRed:0x66 / 255.0 green:0x66 / 255.0 blue:0x66 / 255.0 alpha:1].CGColor;
        self.selectedIcon.backgroundColor = [UIColor colorWithRed:0x27 / 255.0 green:0x27 / 255.0 blue:0x49 / 255.0 alpha:0];
    }
}

@end
