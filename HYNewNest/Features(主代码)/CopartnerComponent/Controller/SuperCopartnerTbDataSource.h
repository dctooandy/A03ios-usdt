//
//  SuperCopartnerTbDataSource.h
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperCopartnerTbConst.h"
#import "SCMyBonusModel.h"
#import "SCMyRebateModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SuperCopartnerDelegate <NSObject>
- (void)dataSourceReceivedMyBonus:(SCMyBonusModel *)model;
@end

@interface SuperCopartnerTbDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak,nonatomic) id<SuperCopartnerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type isHomePage:(BOOL)isHome;
- (void)changeType:(SuperCopartnerType)type;

@end

NS_ASSUME_NONNULL_END
