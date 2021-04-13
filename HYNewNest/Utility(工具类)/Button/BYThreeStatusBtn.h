//
//  BYThreeStatusBtn.h
//  HYNewNest
//
//  Created by zaky on 4/13/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, CNThreeStaBtnStatus) {
    /* 渐变色边框 蓝色文字 需要手动修改的样式 （去完成）
     */
    CNThreeStaBtnStatusGradientBorder = -1,
    
    /* 渐变色背景 白色文字 默认样式 （待领取）
     */
    CNThreeStaBtnStatusGradientBackground = 0,
    
    /* 蓝灰色背景 深灰色文字 (已完成 已结束)
     */
    CNThreeStaBtnStatusDark = 1,
};

// 三个样式的按钮 均可点击, enabled状态不要随便修改
@interface BYThreeStatusBtn : UIButton
@property (assign,nonatomic) CNThreeStaBtnStatus status; //!<样式
@property (assign,nonatomic) IBInspectable NSInteger ibStatus; //!< 样式适配器（用于在xib中调试）
@property (assign,nonatomic) IBInspectable CGFloat txtSize; //!< 文字大小
@end

NS_ASSUME_NONNULL_END
