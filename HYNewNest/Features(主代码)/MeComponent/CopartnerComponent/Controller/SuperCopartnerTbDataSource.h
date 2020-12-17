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

@interface SuperCopartnerTbDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (assign,nonatomic) NSInteger itemCount;


//@property (nonatomic, copy) SCBlock scSuccesBlock;

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type;
- (void)changeType:(SuperCopartnerType)type;

@end

NS_ASSUME_NONNULL_END
