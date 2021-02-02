//
//  DSBGameRoundResModel.h
//  HYNewNest
//
//  Created by zaky on 1/26/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"
#import <BGFMDB/BGFMDB.h>

NS_ASSUME_NONNULL_BEGIN

/// 第一次取到的数据组 里的单场数据
@interface RoundResItem :CNBaseModel
@property (nonatomic , strong) NSNumber              * banker_val;
@property (nonatomic , strong) NSNumber              * player_val;
@property (nonatomic , strong) NSNumber              * card_num;
@property (nonatomic , strong) NSNumber              * pair;  //0=无对子 1=庄对 2=闲对 3=庄闲对
@property (nonatomic , assign) NSInteger              timestamp;

@end

/// 推送过来的单局数据
@interface RoundPushModel : CNBaseModel
@property (nonatomic , copy) NSString              * vid;
@property (nonatomic , assign) NSInteger               round;
@property (nonatomic , copy) NSString              * gmcode;

@property (nonatomic , strong) NSNumber              * banker_val;
@property (nonatomic , strong) NSNumber              * player_val;
@property (nonatomic , strong) NSNumber              * card_num;
@property (nonatomic , strong) NSNumber              * pair;  //0=无对子 1=庄对 2=闲对 3=庄闲对
@property (nonatomic , assign) NSInteger              timestamp;
- (RoundResItem *)makeRoundResItem;
@end


UIKIT_EXTERN NSString *DBName_DSBGameRoundResults;

@interface DSBGameRoundResModel : CNBaseModel
@property (nonatomic , copy) NSString              * vid;   // table
@property (nonatomic , copy) NSString              * gameType;
@property (nonatomic , copy) NSString              * shoeCode;
@property (nonatomic , copy) NSString              * dealer;
@property (nonatomic , copy) NSString              * gmcode;
@property (nonatomic , assign) NSInteger              roundCount;
@property (nonatomic , strong) NSDictionary<NSString *, RoundResItem *> * roundRes; // 字典key忽略 value需要再次手动转为RoundResItem
@property (nonatomic , assign) NSInteger              seconds;
@end

NS_ASSUME_NONNULL_END
