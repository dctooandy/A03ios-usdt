//
//  KYMWithdrewBankView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewBankView.h"

@implementation KYMWithdrewBankView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
        self.confirmTimeStack.hidden = YES;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor colorWithRed:0x3A / 255.0 green:0x3D / 255.0 blue:0x46 / 255.0 alpha:1].CGColor;

    }
    return self;
}
- (void)setStep:(KYMWithdrewStep)step
{
    _step = step;
    if (step == KYMWithdrewStepFive || step == KYMWithdrewStepSix) {
        self.confirmTimeStack.hidden = NO;
    }
}

@end
