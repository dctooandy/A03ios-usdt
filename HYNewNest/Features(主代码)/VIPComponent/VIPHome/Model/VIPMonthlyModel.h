//
//  VIPMonthlyModel.h
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipRhqk :CNBaseModel
/// 累计入会名额
@property (nonatomic , assign) NSInteger              betCount;
/// 赌尊数
@property (nonatomic , strong) NSNumber             * betZunCount;
/// 赌霸数
@property (nonatomic , strong) NSNumber             * betBaCount;
/// 赌神数
@property (nonatomic , strong) NSNumber             * betGoldCount;
/// 赌王数
@property (nonatomic , strong) NSNumber             * betKingCount;
/// 赌圣数
@property (nonatomic , strong) NSNumber             * betSaintCount;
/// 赌侠数
@property (nonatomic , strong) NSNumber             * betXiaCount;
/// 赌尊名
@property (nonatomic , copy) NSString              * betZunName;
/// 赌尊充值
@property (nonatomic , strong) NSNumber             * depositAmount;
//@property (nonatomic , strong) NSNumber             * depositCNYAmount;
/// 赌尊流水
@property (nonatomic , strong) NSNumber              * betAmount;
//@property (nonatomic , strong) NSNumber              * betCNYAmount;

@end


@interface VipScjz :CNBaseModel
/// 累计送出
@property (nonatomic , strong) NSNumber              * ljsc;
@property (nonatomic , strong) NSNumber              * ljscCNY;
/// 累计身份
@property (nonatomic , strong) NSNumber              * ljsf;
@property (nonatomic , strong) NSNumber              * ljsfCNY;
/// 入会礼金
@property (nonatomic , strong) NSNumber              * rhlj;
@property (nonatomic , strong) NSNumber              * rhljCNY;
/// 月度分红
@property (nonatomic , strong) NSNumber              * ydfh;
@property (nonatomic , strong) NSNumber              * ydfhCNY;
/// 至尊转盘
@property (nonatomic , strong) NSNumber              * zzzp;
@property (nonatomic , strong) NSNumber              * prize;
@end


/// 月报模型
@interface VIPMonthlyModel :CNBaseModel
/// 入会情况
@property (nonatomic , strong) VipRhqk              * vipRhqk;
/// 送出价值
@property (nonatomic , strong) VipScjz              * vipScjz;
/// 是否有可领取的入会礼金 空则没有
@property (nonatomic , strong) NSDictionary           * preRequest;
/// 2-7 依次从赌侠到赌尊
@property (nonatomic , strong) NSNumber              * clubLevel;
/// 上月存款
@property (nonatomic , strong) NSNumber             * totalDepositAmount;
//@property (nonatomic , strong) NSNumber             * totalDepositCNYAmount;
/// 上月月份
@property (nonatomic , assign) NSInteger              lastMonth;
/// 上月流水
@property (nonatomic , strong) NSNumber             * totalBetAmount;
//@property (nonatomic , strong) NSNumber             * totalBetCNYAmount;
/// 当前是什么等级
@property (nonatomic , copy) NSString              * betName;
// 0301
@property (nonatomic , strong) NSNumber             * pendingRHLJ; // 入会礼金?
@property (nonatomic , strong) NSNumber             * pendingSXJ; // 私享金?
@end

NS_ASSUME_NONNULL_END
