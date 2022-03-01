//
//  KYMWithdrewAmountListView.h
//  HYNewNest
//
//  Created by Key.L on 2022/2/26.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWithdrewAmountModel.h"
NS_ASSUME_NONNULL_BEGIN
@class KYMWithdrewAmountListView;
@protocol KYMWithdrewAmountCellDelegate <NSObject>

- (void)matchWithdrewAmountCellDidSelected:(KYMWithdrewAmountListView *)view indexPath:(NSIndexPath *)indexPath;

@end
@interface KYMWithdrewAmountListView : UIView
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *amountArray;
@property (nonatomic, weak) id<KYMWithdrewAmountCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
