//
//  ChargeManualMessgeView.h
//  HYGEntire
//
//  Created by zaky on 17/06/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ChargeMsgType) {
    ChargeMsgTypeManual = 0, //手动充值 需要附言 废弃了
    
    ChargeMsgTypeDCBOX,   //小金库
    ChargeMsgTypeOTHERS,  //其它钱包
};

/// 充值完成底部弹出控件
@interface ChargeManualMessgeView : UIView
@property (nonatomic, copy)void(^clickBlock)(BOOL isSure);

/// 地址和附言
- (instancetype)initWithAddress:(NSString *)address amount:(NSString *)amount retelling:(nullable NSString *)retelling type:(ChargeMsgType)chargeType;

@end

NS_ASSUME_NONNULL_END
