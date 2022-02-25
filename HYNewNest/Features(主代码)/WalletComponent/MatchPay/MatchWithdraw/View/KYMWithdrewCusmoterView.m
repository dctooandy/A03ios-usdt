//
//  KYMWithdrewCusmoterView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewCusmoterView.h"

@implementation KYMWithdrewCusmoterView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
    }
    return self;
}
- (IBAction)customerBtnClicked:(id)sender {
    self.customerBtnHandle();
}
@end
