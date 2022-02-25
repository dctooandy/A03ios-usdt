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
    self.layer.borderColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.2].CGColor;
    self.selectedIcon.hidden = YES;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectedIcon.hidden = !selected;
    if (selected) {
        self.layer.borderColor = [UIColor colorWithRed:0x55 / 255.0 green:0xAA / 255.0 blue:0xF5 / 255.0 alpha:1].CGColor;
        self.amoutLB.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:1];
    } else {
        self.layer.borderColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.2].CGColor;
        self.amoutLB.textColor = [UIColor colorWithRed:0x81 / 255.0 green:0x87 / 255.0 blue:0x91 / 255.0 alpha:1];
    }
}
- (void)setAmount:(NSString *)amount
{
    _amount = amount;
    self.amoutLB.text = amount;
}
@end
