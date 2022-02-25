//
//  KYMWithdrewAmountView.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWidthdrewUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewAmountView : UIView
@property (nonatomic ,assign) KYMWithdrewStep step;
@property (copy, nonatomic) NSString *amount;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *amountStatusLB1;
@property (weak, nonatomic) IBOutlet UILabel *amountStatusLB2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountStatusLB2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountStatusLB2Top;
@end

NS_ASSUME_NONNULL_END
