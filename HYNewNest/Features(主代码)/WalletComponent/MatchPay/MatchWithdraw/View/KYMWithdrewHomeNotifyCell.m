//
//  KYMWithdrewHomeNotifyCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewHomeNotifyCell.h"

@interface KYMWithdrewHomeNotifyCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *countLB;

@end
@implementation KYMWithdrewHomeNotifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLB.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotClicked)];
    [self.titleLB addGestureRecognizer:gesture];
}
- (void)forgotClicked {
    self.forgotPwdBlock();
}
- (void)setCanUseCount:(NSString *)canUseCount
{
    _canUseCount = canUseCount;
    self.countLB.text = canUseCount;
}
@end
