//
//  BTTAnimationPopView.h
//  Hybird_1e3c3b
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 显示时动画弹框样式
 */
typedef NS_ENUM(NSInteger, BTTAnimationPopStyle) {
    BTTAnimationPopStyleNO = 0,               ///< 无动画
    BTTAnimationPopStyleScale,                ///< 缩放动画，先放大，后恢复至原大小
    BTTAnimationPopStyleShakeFromTop,         ///< 从顶部掉下到中间晃动动画
    BTTAnimationPopStyleShakeFromBottom,      ///< 从底部往上到中间晃动动画
    BTTAnimationPopStyleShakeFromLeft,        ///< 从左侧往右到中间晃动动画
    BTTAnimationPopStyleShakeFromRight,       ///< 从右侧往左到中间晃动动画
    BTTAnimationPopStyleCardDropFromLeft,     ///< 卡片从顶部左侧开始掉落动画
    BTTAnimationPopStyleCardDropFromRight,    ///< 卡片从顶部右侧开始掉落动画
};

/**
 移除时动画弹框样式
 */
typedef NS_ENUM(NSInteger, BTTAnimationDismissStyle) {
    BTTAnimationDismissStyleNO = 0,               ///< 无动画
    BTTAnimationDismissStyleScale,                ///< 缩放动画
    BTTAnimationDismissStyleDropToTop,            ///< 从中间直接掉落到顶部
    BTTAnimationDismissStyleDropToBottom,         ///< 从中间直接掉落到底部
    BTTAnimationDismissStyleDropToLeft,           ///< 从中间直接掉落到左侧
    BTTAnimationDismissStyleDropToRight,          ///< 从中间直接掉落到右侧
    BTTAnimationDismissStyleCardDropToLeft,       ///< 卡片从中间往左侧掉落
    BTTAnimationDismissStyleCardDropToRight,      ///< 卡片从中间往右侧掉落
    BTTAnimationDismissStyleCardDropToTop,        ///< 卡片从中间往顶部移动消失
};

NS_ASSUME_NONNULL_BEGIN

@interface BTTAnimationPopView : UIView

/** 显示时点击背景是否移除弹框，默认为NO。 */
@property (nonatomic) BOOL isClickBGDismiss;
/** 显示时是否监听屏幕旋转，默认为NO */
@property (nonatomic) BOOL isObserverOrientationChange;
/** 显示时背景的透明度，取值(0.0~1.0)，默认为0.5 */
@property (nonatomic) CGFloat popBGAlpha;

/// 动画相关属性参数
/** 显示时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat popAnimationDuration;
/** 隐藏时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat dismissAnimationDuration;
/** 显示完成回调 */
@property (nullable, nonatomic, copy) void(^popComplete)(void);
/** 移除完成回调 */
@property (nullable, nonatomic, copy) void(^dismissComplete)(void);

/**
 通过自定义视图来构造弹框视图
 
 @param customView 自定义视图
 */
- (nullable instancetype)initWithCustomView:(UIView *_Nonnull)customView
                                   popStyle:(BTTAnimationPopStyle)popStyle
                               dismissStyle:(BTTAnimationDismissStyle)dismissStyle;

/**
 显示弹框
 */
- (void)pop;

/**
 移除弹框
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
