//
//  BYDashenBoardConst.h
//  HYNewNest
//
//  Created by zaky on 12/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#ifndef BYDashenBoardConst_h
#define BYDashenBoardConst_h

#import "VIPRankConst.h"

#define kSepaLineColor kHexColor(0x40405D)

// 庄闲和
#define kZhuanColor kHexColor(0xCD4F49)
#define kXianColor kHexColor(0x2E62CF)
#define kHeColor kHexColor(0x226A0F)

// 赌尊～赌侠/VIP
#define kDuzunColor1 kHexColor(0xF8E08E)
#define kDuzunColor2 kHexColor(0xC39632)
#define kDuGodColor1 kHexColor(0xDAE8EA)
#define kDuGodColor2 kHexColor(0x758A9B)
#define kDuSaintColor1 kHexColor(0xBCB47D)
#define kDuSaintColor2 kHexColor(0x967A3D)
#define kDuKingColor kHexColor(0xF3AF13)
#define kDuBaColor kHexColor(0xF36715)
#define kDuXiaColor kHexColor(0xF83D22)
#define kVIPColor1 kHexColor(0x19CECE)
#define kVIPColor2 kHexColor(0x10B4DD)

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
