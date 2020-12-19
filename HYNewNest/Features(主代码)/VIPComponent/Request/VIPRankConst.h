//
//  VIPRankConst.h
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#ifndef VIPRankConst_h
#define VIPRankConst_h


typedef NS_ENUM(NSInteger, VIPRank) {
    VIPRankNone = 0,
    VIPRankNone2 = 1,
    VIPRankDuXia = 2,
    VIPRankDuBa = 3,
    VIPRankDuKing = 4,
    VIPRankDuSaint = 5,
    VIPRankDuGod = 6,
    VIPRankDuZun = 7,
};

static NSString *VIPRankString[] = {
    [VIPRankNone] = @"--",
    [VIPRankNone2] = @"--",
    [VIPRankDuXia] = @"赌侠",
    [VIPRankDuBa] = @"赌霸",
    [VIPRankDuKing] = @"赌王",
    [VIPRankDuSaint] = @"赌圣",
    [VIPRankDuGod] = @"赌神",
    [VIPRankDuZun] = @"赌尊",
};

#endif /* VIPRankConst_h */
