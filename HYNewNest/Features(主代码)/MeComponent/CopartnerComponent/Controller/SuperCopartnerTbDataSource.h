//
//  SuperCopartnerTbDataSource.h
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperCopartnerTbConst.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SuperCopartnerDelegate <NSObject>

//- (void)didReceiveCumulateBetAmount:(NSNumber *)betAmount;

@end

@interface SuperCopartnerTbDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, copy) SCBlock scSuccesBlock;

@property (weak,nonatomic) id<SuperCopartnerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type isHomePage:(BOOL)isHome;
- (void)changeType:(SuperCopartnerType)type;

@end

NS_ASSUME_NONNULL_END
