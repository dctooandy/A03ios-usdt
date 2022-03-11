//
//  HYRechargeCNYEditView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/11.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseXibView.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HYRechargeCNYEditViewDelegate <NSObject>

/// 点了切换按钮
- (void)didTapSwitchBtnModel:(PayWayV3PayTypeItem *)paytypeItem;
/// 是否符合充值条件 改变
- (void)didChangeIsStatusRight:(BOOL)isStatusRight;


@end

/*
* 充值 选择/填写 金额/付款人/转账银行 的View
*/
@interface HYRechargeCNYEditView : CNBaseXibView
/// 用户的金额
@property (nonatomic, copy, readonly) NSString *rechargeAmount;
/// 付款人
@property (nonatomic, copy, readonly) NSString *depositor;
@property (nonatomic, copy, readonly) NSString *depositorId;

@property (nonatomic, copy) NSArray *matchAmountList;

/// 代理
@property (nonatomic, weak) id<HYRechargeCNYEditViewDelegate> delegate;

/// 赋值
- (void)setupPayTypeItem:(PayWayV3PayTypeItem *)itemModel
               bankModel:(nullable OnlineBanksModel *)bankModel
             amountModel:(nullable AmountListModel *)amountModel;
//- (void)setupBQBankModel:(BQBankModel *)model;

/// 清空已填数据
- (void)clearAmountData;

@end

NS_ASSUME_NONNULL_END
