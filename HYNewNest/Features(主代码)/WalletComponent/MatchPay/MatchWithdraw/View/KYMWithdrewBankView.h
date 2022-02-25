//
//  KYMWithdrewBankView.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWidthdrewUtility.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewBankView : UIView
@property (nonatomic ,assign) KYMWithdrewStep step;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *accoutName;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *withdrawType;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *submitTime;
@property (weak, nonatomic) IBOutlet UILabel *confirmTime;
@property (weak, nonatomic) IBOutlet UIStackView *confirmTimeStack;

@end

NS_ASSUME_NONNULL_END
