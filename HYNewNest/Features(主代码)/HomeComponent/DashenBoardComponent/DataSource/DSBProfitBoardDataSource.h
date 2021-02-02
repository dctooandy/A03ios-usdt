//
//  DSBProfitBoardDataSource.h
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYDashenBoardConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBProfitBoardDataSource : NSObject

@property (assign,nonatomic) DashenBoardType type;
@property (assign,nonatomic) NSInteger curPage; //!<用户左右滑动的页数
- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView;

//- (void)didChooseProfitBoard;

@end

NS_ASSUME_NONNULL_END
