//
//  CNElectrionHallCCell.h
//  HYNewNest
//
//  Created by Cean on 2020/8/4.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElecGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNElectrionHallCCell : UICollectionViewCell

@property (nonatomic, copy) void (^collectionBlock)(UIButton *btn, ElecGameModel *model);
@property (nonatomic, strong) ElecGameModel *model;
@end

NS_ASSUME_NONNULL_END
