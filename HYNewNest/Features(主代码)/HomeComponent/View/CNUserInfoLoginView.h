//
//  CNUserInfoLoginView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"


typedef enum : NSInteger {
//    CNActionTypeBuy = 0,        //买
    CNActionTypeDeposit = 0,    //充
    CNActionTypeWithdraw,   //提
//    CNActionTypeSell,       //卖
    CNActionTypeXima,       //洗
} CNActionType;

/// 按钮代理事件
@protocol CNUserInfoLoginViewDelegate <NSObject>

- (void)switchAccountAction;
- (void)buttonArrayAction:(CNActionType)type;
- (void)loginAction;
- (void)registerAction;
- (void)questionAction;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CNUserInfoLoginView : CNBaseXibView
@property (nonatomic, weak) id delegate;


// 加载金额
- (void)reloadBalance;
// 用户登录状态变化
- (void)updateLoginStatusUIIsRefreshing:(BOOL)isRefreshing;
// 切换模式UI改
- (void)switchAccountUIChange;
//刷新
- (void)refreshBottomBtnsStatus;

@end

NS_ASSUME_NONNULL_END
