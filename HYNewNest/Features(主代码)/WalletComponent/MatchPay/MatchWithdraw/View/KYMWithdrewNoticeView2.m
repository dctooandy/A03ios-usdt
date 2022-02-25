//
//  KYMWithdrewNoticeView2.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewNoticeView2.h"

@interface KYMWithdrewNoticeView2 ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
@implementation KYMWithdrewNoticeView2

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor colorWithRed:0x09 / 255.0 green:0x94 / 255.0 blue:0xE7 / 255.0 alpha:1].CGColor;
    }
    return self;
}

@end
