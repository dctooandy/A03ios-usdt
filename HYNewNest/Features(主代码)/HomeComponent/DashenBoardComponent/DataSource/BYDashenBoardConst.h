//
//  BYDashenBoardConst.h
//  HYNewNest
//
//  Created by zaky on 12/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#ifndef BYDashenBoardConst_h
#define BYDashenBoardConst_h

typedef NS_ENUM(NSInteger, DashenBoardType) {
    DashenBoardTypeProfitBoard = 0,
    DashenBoardTypeRechargeBoard,
    DashenBoardTypeWithdrawBoard,
    DashenBoardTypeWeekBoard,
    DashenBoardTypeMonthBoard
};

@protocol DashenBoardAutoHeightDelegate
- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight;
@end

#endif /* BYDashenBoardConst_h */
