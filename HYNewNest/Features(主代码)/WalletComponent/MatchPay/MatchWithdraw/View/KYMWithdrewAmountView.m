//
//  KYMWithdrewAmountView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountView.h"

@interface KYMWithdrewAmountView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountWidth;

@end
@implementation KYMWithdrewAmountView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
    }
    return self;
}
- (void)setAmount:(NSString *)amount
{
    _amount = amount;
    self.amountLB.text = [KYMWidthdrewUtility getMoneyString:[amount doubleValue]] ;
    self.amountWidth.constant = [self.amountLB.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.amountLB.font} context:nil].size.width + 1; 
}
- (void)setStep:(KYMWithdrewStep)step
{
    _step = step;
    switch (step) {
        case KYMWithdrewStepOne:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case KYMWithdrewStepTwo:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case KYMWithdrewStepThree:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";
            break;
        case KYMWithdrewStepFour:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
//            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";
            break;
        case KYMWithdrewStepFive:
            self.amountStatusLB1.hidden = NO;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 22;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            self.amountStatusLB2.text = @"由于您未在规定时间确认，系统判断您已确认到账\n如提现未到账或金额不符，请及时联系客服";
            break;
        case KYMWithdrewStepSix: {
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 1;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            NSString *amount = [NSString stringWithFormat:@"恭喜老板！获得取款返利金%0.2lf元\n每周一统一发放",[self.amount doubleValue] * 0.005];
            self.amountStatusLB2.text = amount;
            break;
        }
        default:
            break;
    }
}

@end
