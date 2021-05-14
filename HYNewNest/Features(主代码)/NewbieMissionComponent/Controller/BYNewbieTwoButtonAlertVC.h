//
//  BYNewbieTwoButtonVC.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum  {
    BYNewbieAlertTypeDespositAndBet = 0,
    BYNewbieAlertTypeWithdrawal
} BYNewbieAlertType;

@interface BYNewbieTwoButtonAlertVC : UIViewController
@property (nonatomic, assign) BYNewbieAlertType type;
@end

NS_ASSUME_NONNULL_END
