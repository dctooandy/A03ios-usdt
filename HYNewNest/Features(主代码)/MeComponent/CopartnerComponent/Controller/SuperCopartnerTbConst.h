//
//  SuperCoparttnerTbConst.h
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#ifndef SuperCopartnerTbConst_h
#define SuperCopartnerTbConst_h

typedef enum : NSInteger {
    SuperCopartnerTypeMyBonus = 0, // 我的奖金
    SuperCopartnerTypeMyRecommen,  // 我的推荐
    SuperCopartnerTypeSXHBonus,    // 私享会礼金
    SuperCopartnerTypeStarGifts,   // 星级礼金
    SuperCopartnerTypeCumuBetRank, // 本月累投
    
    SuperCopartnerTypeMyGifts // 我的奖品
} SuperCopartnerType;

//typedef void(^SCBlock)(BOOL success, SuperCopartnerType currType);

#endif /* SuperCopartnerTbConst_h */
