//
//  BYMyBonusTableViewController.h
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyBounsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyBonusTableViewDelegate <NSObject>

- (void)refreshBegin;
@optional
- (void)applyPromoWithRequestId:(NSString *)requestIdString;

@end
@interface BYMyBonusTableViewController : UITableViewController
@property (nonatomic, weak) id<MyBonusTableViewDelegate> delegate;
@property (nonatomic, strong) NSArray <BYMyBounsModel *>* promos;

@end

NS_ASSUME_NONNULL_END
