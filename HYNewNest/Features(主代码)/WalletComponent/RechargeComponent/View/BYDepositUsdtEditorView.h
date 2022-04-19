//
//  BYDepositUsdtEditorView.h
//  HYNewNest
//
//  Created by zaky on 6/22/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BYDepositUsdtEditorDelegate <NSObject>
- (void)didSelectOneProtocol:(NSString *)selectedProtocol;
- (void)depositAmountIsRight:(BOOL)isRight;
@end

@interface BYDepositUsdtEditorView : CNBaseXibView
@property (weak,nonatomic) id<BYDepositUsdtEditorDelegate> delegate;
@property (nonatomic, copy) NSString *amount_list; //快捷输入金额
@property (nonatomic, copy) NSString *rechargeAmount; //!< 用户写入的金额
@property (nonatomic, copy, readonly) NSString *selectedProtocol; //!< 选中的协议
@property (strong,nonatomic,nullable) DepositsBankModel * deposModel; //!< 模型
@property (strong,nonatomic,nullable) PayWayV3PayTypeItem * paywaysV3Model; //!< 模型
@end

NS_ASSUME_NONNULL_END
