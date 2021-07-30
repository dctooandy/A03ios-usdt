//
//  CreditQueryResultModel.h
//  INTEDSGame
//
//  Created by Robert on 12/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import "CNBaseModel.h"

/** 交易记录类型 */
typedef NS_ENUM(NSInteger,TransactionRecordType) {
    /*
     充值
     */
    transactionRecord_rechargeType = 1,
    
    /*
      提现
     */
    transactionRecord_withdrawType = 2,
    
    /*
      洗码
     */
    transactionRecord_XMType = 3,
    
    /*
      优惠领取
     */
    transactionRecord_activityType = 4,
    
    /*
      余额宝
     */
    transactionRecord_yuEBaoDeposit,
    TransactionRecord_yuEBaoWithdraw,
    
    /*
      投注记录
     */
    transactionRecord_betRecordType = 8,
    
};

/** 交易记录状态 */
typedef NS_ENUM(NSInteger,TransactionProgressState) {
    // 等待支付
    transactionProgress_waitPayState = 0,
    
    // 处理中
    transactionProgress_processingState = 1,
    
    // 成功
    transactionProgress_successState = 2,
    
    // 处理失败
    transactionProgress_failedState = 3,
    
    // 超时
    transactionProgress_timeoutType = 4,
    
    // 待核
    transactionProgress_waitCheckState = 9
};

@protocol CreditQueryDataModel

@end

@interface CreditQueryDataModel : CNBaseModel
/** 自定义参数 */
@property (nonatomic, strong, readonly) UIColor *statsColor;
@property (nonatomic, assign, readonly) BOOL isWaitingStatus;
@property (nonatomic, copy, readonly) NSString *gameKindName;
@property (nonatomic, copy, readonly) NSString *gamePlatName;
/*************** */

@property (copy, nonatomic) NSString *rate;
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *arrivalAmount;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *createDate;
@property (assign, nonatomic)  TransactionProgressState flag; //??? not fit with status
/** 状态描述 */
@property (copy, nonatomic) NSString *flagDesc;

/** 流水号 */
@property (copy, nonatomic) NSString *referenceId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *itemIcon;
@property (copy, nonatomic) NSString *accountNo;
@property (copy, nonatomic) NSString *bankName;
@property (assign, nonatomic) TransactionRecordType type;

/** 提现流水号 */
@property (copy, nonatomic) NSString *requestId;

#pragma mark - 积分兑换交易记录
@property (copy, nonatomic) NSString *remindFlag;
@property (copy, nonatomic) NSString *typeIntegral;
@property (copy, nonatomic) NSString *integral;
@property (copy, nonatomic) NSString *integralCash;

#pragma mark - 电游交易记录
@property (copy, nonatomic) NSString *billNo;
@property (copy, nonatomic) NSString *billTime;
@property (copy, nonatomic) NSString *cusAccount;
@property (copy, nonatomic) NSString *gameKind;
@property (copy, nonatomic) NSString *gameType;
@property (copy, nonatomic) NSString *gmCode;
@property (copy, nonatomic) NSString *payoutAmount;
@property (copy, nonatomic) NSString *betAmount;
@property (copy, nonatomic) NSString *platformId;
@property (copy, nonatomic) NSString *playType;
@property (copy, nonatomic) NSString *playTypeName;
@property (copy, nonatomic) NSString *remainAmount;
@property (copy, nonatomic) NSString *validAccount;

#pragma mark - 红利交易记录
@property (copy,nonatomic) NSString *titleName;

#pragma mark - 转账记录
@property (copy,nonatomic) NSString *transCode;

#pragma mark - 小金库 产生利息记录
@property (copy,nonatomic) NSString *refrenceId;
@property (copy,nonatomic) NSString *afterAmount;
@property (copy,nonatomic) NSString *changeType;
@property (copy,nonatomic) NSString *createdTime;
@property (copy,nonatomic) NSString *beforeAmount;

#pragma mark - 洗码
@property (copy, nonatomic) NSString *platform;

#pragma mark - 余额宝
@property (assign,nonatomic) NSInteger status; //!<转账状态，0待审批，1审批通过，-1后台拒绝，-9确认失败
@property (copy,nonatomic) NSString *yebStatusTxt;
@end

@interface CreditQueryResultModel : CNBaseModel

@property (copy, nonatomic) NSMutableArray <CreditQueryDataModel *> *data;

@property (assign, nonatomic) NSInteger pageNo;

@property (assign, nonatomic) NSInteger pageSize;

@property (assign, nonatomic) NSInteger totalPage;

@property (assign, nonatomic) NSInteger totalRow;

@end
