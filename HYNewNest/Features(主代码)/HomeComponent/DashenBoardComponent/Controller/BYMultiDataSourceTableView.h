//
//  BYMultiDataSourceTableView.h
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYDashenBoardConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYMultiDataSourceTableView : UITableView

- (void)changeDataSourceDelegate:(id)dd type:(DashenBoardType)type;

@end

NS_ASSUME_NONNULL_END
