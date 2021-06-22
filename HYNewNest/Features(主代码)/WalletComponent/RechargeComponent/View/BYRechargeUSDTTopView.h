//
//  BYRechargeUSDTTopView.h
//  HYNewNest
//
//  Created by zaky on 3/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

///deprecated
@protocol BYRechargeUSDTViewDelegate <NSObject>
- (void)didSelectOneProtocol:(NSString *)selectedProtocol;
/// 点了充值按钮
- (void)didTapDepositBtnModel:(DepositsBankModel *)model amount:(NSString *)amountStr protocol:(NSString *)protocolStr;
@end

@interface BYRechargeUSDTTopView : UITableViewCell

@property (weak,nonatomic) id<BYRechargeUSDTViewDelegate> delegate;

//@property (nonatomic, copy, readonly) NSString *rechargeAmount; //!< 用户写入的金额
//@property (nonatomic, copy, readonly) NSString *selectedProtocol; //!< 选中的协议

@property (strong,nonatomic,nullable) DepositsBankModel * deposModel; //!< 模型
//@property (assign,nonatomic) NSInteger lineIdx; //!< 行数 必须赋值

//@property (copy,nonatomic) void(^didTapTopBgActionBlock)(NSInteger lineIdx); //!< 点击头部回调
@end

NS_ASSUME_NONNULL_END
