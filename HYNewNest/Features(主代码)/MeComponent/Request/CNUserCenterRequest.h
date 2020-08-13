//
//  CNUserCenterRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"

#import "UserSubscribItem.h"
#import "BetAmountModel.h"
#import "ChooseAvatarsModel.h"
#import "OtherAppModel.h"
#import "ArticalModel.h"
#import "CreditQueryResultModel.h"
#import "UserSuggestionModel.h"
#import "AgentRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNUserCenterRequest : CNBaseNetworking


/// 修改用户信息
/// @param realName 真实姓名
/// @param gender 性别
/// @param birth 生日
/// @param avatar 头像
/// @param onlineMessenger2 微信号
/// @param handler 回调
+ (void)modifyUserRealName:(nullable NSString *)realName
                    gender:(nullable NSString *)gender
                     birth:(nullable NSString *)birth
                    avatar:(nullable NSString *)avatar
          onlineMessenger2:(nullable NSString *)onlineMessenger2
                     email:(nullable NSString *)email
                   handler:(HandlerBlock)handler;


/// 获取所有可修改头像
+ (void)getAllAvatarsHanlder:(HandlerBlock)handler;


/// 获取投注额
+ (void)requestBetAmountHandler:(HandlerBlock)handler;


/// 获取本月优惠和本月洗码
+ (void)requestMonthPromoteAndXimaHandler:(HandlerBlock)handler;


///获取用户账户余额
+(void)requestAccountBalanceHandler:(HandlerBlock)handler;


/// 获取其它游戏app
+ (void)requestOtherGameAppListHandler:(HandlerBlock)handler;


/// 查询用户限红
+ (void)queryLimitBonusValueHandler:(HandlerBlock)handler;

/// 修改限红
/// @param content 内容：20-50000，1000-100000，2000-200000，10000-500000，20000-1000000
/// @param handler 回调
+ (void)changeLimitBonusContent:(NSString *)content
                        handler:(HandlerBlock)handler;


/// 获取站内信  也用ArticleModel
/// @param pageNo 页码
/// @param pageSize 每页数量
/// @param handler 回调
+ (void)queryLetterPageNo:(NSInteger)pageNo
                 pageSize:(NSInteger)pageSize
                  handler:(HandlerBlock)handler;


/// 查询用户订阅
/// @param handler 回调
+ (void)queryUserSubscribHandler:(HandlerBlock)handler;


/// 用户更改订阅
/// @param subscribes 订阅数组
/// @param handler 回调
+ (void)modifyUserSubscribArray:(NSArray <UserSubscribItem *>*)subscribes
                        handler:(HandlerBlock)handler;


/// 取消未完成的提现订单
/// @param referenceId 实际上是requestId
/// @param handler 回调
+ (void)cancelWithdrawBillRequestId:(NSString *)referenceId
                            handler:(HandlerBlock)handler;


/// 催单
/// @param referenceId 单号（？这里充提接口入参不一致）
/// @param type 类型
/// @param handler 回调
+ (void)reminderBillReferenceId:(NSString *)referenceId
                           type:(NSInteger)type
                        handler:(HandlerBlock)handler;


/// 提交意见反馈
/// @param content 反馈内容
/// @param handler 回调
+ (void)submitSugestionContent:(NSString *)content
                       handler:(HandlerBlock)handler;


/// 查询意见反馈
/// @param handler 回调
+ (void)querySuggestionHandler:(HandlerBlock)handler;


/// 好友推荐
/// @param handler 回调
+ (void)queryAgentRecordsHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
