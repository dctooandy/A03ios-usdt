//
//  DSBWeekMonthListDataSource.h
//  HYNewNest
//
//  Created by zaky on 12/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYDashenBoardConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBWeekMonthListDataSource : NSObject

- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView type:(DashenBoardType)type;

// settype之后就会刷新tableview 这里多个数据源公用一个tableView
@property (assign,nonatomic) DashenBoardType type;
@end

NS_ASSUME_NONNULL_END
