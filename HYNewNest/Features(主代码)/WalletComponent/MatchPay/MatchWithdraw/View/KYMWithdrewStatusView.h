//
//  KYMWithdrewStatusView.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWidthdrewUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewStatusView : UIView
@property (nonatomic ,assign) KYMWithdrewStep step;
@property (weak, nonatomic) IBOutlet UIView *statusItemView;
@property (nonatomic, strong) NSArray *statusTitleArray;
@property (weak, nonatomic) IBOutlet UILabel *stautsLB1;
@property (weak, nonatomic) IBOutlet UILabel *statusLB2;
@property (weak, nonatomic) IBOutlet UILabel *statusLB3;
@property (weak, nonatomic) IBOutlet UILabel *statusLB4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLB2Width;

@end

NS_ASSUME_NONNULL_END
