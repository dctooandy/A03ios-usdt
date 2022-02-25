//
//  KYMWithdrewHomeNotifyCell.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewHomeNotifyCell : UICollectionViewCell
@property (nonatomic, strong) void(^forgotPwdBlock)(void);
@property (nonatomic, copy) NSString *canUseCount;
@end

NS_ASSUME_NONNULL_END
