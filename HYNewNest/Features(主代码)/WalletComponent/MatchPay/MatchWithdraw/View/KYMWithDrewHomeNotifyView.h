//
//  KYMWithDrewHomeNotifyView.h
//  HYNewNest
//
//  Created by Key.L on 2022/2/25.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithDrewHomeNotifyView : UIView
@property (nonatomic, copy) NSString *canUseCount;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@end

NS_ASSUME_NONNULL_END
