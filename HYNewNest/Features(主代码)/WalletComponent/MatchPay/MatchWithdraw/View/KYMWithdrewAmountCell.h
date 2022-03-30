//
//  KYMWithdrewAmountCell.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWithdrewAmountModel.h"
NS_ASSUME_NONNULL_BEGIN

@class KYMWithdrewAmountCell;
@protocol KYMWithdrewAmountCellDelegate <NSObject>

- (void)matchWithdrewAmountCellDidSelected:(KYMWithdrewAmountCell *)cell indexPath:(NSIndexPath *)indexPath;

@end
@interface KYMWithdrewAmountCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *amountArray;
@property (nonatomic, weak) id<KYMWithdrewAmountCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
