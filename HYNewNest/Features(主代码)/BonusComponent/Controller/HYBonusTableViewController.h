//
//  HYBonusTableViewController.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPromoItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BonusTableViewDelegate <NSObject>

- (void)refreshBegin;

@end

@interface HYBonusTableViewController : UITableViewController
@property (nonatomic, weak) id<BonusTableViewDelegate> delegate;
@property (nonatomic, strong) NSArray <MyPromoItem *>* promos;

@end

NS_ASSUME_NONNULL_END
