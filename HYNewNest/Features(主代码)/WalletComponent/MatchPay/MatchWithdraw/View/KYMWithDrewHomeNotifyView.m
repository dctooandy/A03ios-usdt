//
//  KYMWithDrewHomeNotifyView.m
//  HYNewNest
//
//  Created by Key.L on 2022/2/25.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "KYMWithDrewHomeNotifyView.h"

@interface KYMWithDrewHomeNotifyView ()
@property (weak, nonatomic) IBOutlet UILabel *notLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notLBHeight;

@end
@implementation KYMWithDrewHomeNotifyView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
    }
    return self;
}
- (void)setCanUseCount:(NSString *)canUseCount
{
    _canUseCount = canUseCount;
    self.countLB.text = canUseCount;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.notLBHeight.constant = [self.notLB.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.notLB.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.notLB.font} context:nil].size.height + 1;
   
}
@end
