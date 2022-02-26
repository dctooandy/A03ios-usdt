//
//  KYMWithdrewAmountListCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountListCell.h"

@interface KYMWithdrewAmountListCell ()
@property (weak, nonatomic) IBOutlet UILabel *amoutLB;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;

@end
@implementation KYMWithdrewAmountListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithRed:0x10/ 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1].CGColor;
    self.selectedIcon.hidden = YES;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectedIcon.hidden = !selected;
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0x10/ 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1];
        self.amoutLB.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0x10/ 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:0];
        self.amoutLB.textColor = [UIColor colorWithRed:0x11 / 255.0 green:0xB5 / 255.0 blue:0xDD / 255.0 alpha:1];
    }
}
- (void)setAmount:(NSString *)amount
{
    _amount = amount;
    self.amoutLB.text = amount;
}
@end
