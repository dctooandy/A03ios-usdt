//
//  CNServerView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@class CNServerView;
/// 按钮代理事件
@protocol CNServerViewDelegate <NSObject>
- (void)serverView:(CNServerView *)server callBack:(NSString *)phone code:(NSString *)code messageId:(NSString *)messageId;
@end

@interface CNServerView : CNBaseXibView
+ (void)showServerWithDelegate:(id <CNServerViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
