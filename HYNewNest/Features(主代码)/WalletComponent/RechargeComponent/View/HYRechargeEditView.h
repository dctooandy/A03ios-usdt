//
//  HYRechargeEditView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseXibView.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HYRechargeEditViewDelegate <NSObject>

/// 点了切换按钮
- (void)didTapSwitchBtnModel:(DepositsBankModel *)depositModel;
/// 金额是否符合充值条件 改变
- (void)didChangeIsAmountRight:(BOOL)isAmountRight;

@end

/*
 * 充值 选择协议 填写金额的View
 */
@interface HYRechargeEditView : CNBaseXibView

/// 用户的金额
@property (nonatomic, copy, readonly) NSString *rechargeAmount;
/// 选中的协议
@property (nonatomic, copy, readonly) NSString *selectedProtocol;
@property (nonatomic, copy, readonly) NSString *selectProtocolAddress;

/// 代理
@property (nonatomic, weak) id<HYRechargeEditViewDelegate> delegate;
/// 赋值
- (void)setupDepositModel:(DepositsBankModel *)model;
@end

NS_ASSUME_NONNULL_END
