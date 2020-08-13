//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LineDirection) {
    LineDirectionLeft,
    LineDirectionLeftMiddle,
    LineDirectionTop,
    LineDirectionRight,
    LineDirectionBottom
};

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

- (UIView *)addLineDirection:(LineDirection)dirction
                       color:(UIColor *)color
                       width:(CGFloat)width;

// 移除所有子控件
- (void)removeAllSubViews;

- (void)drawDashLineWidth:(CGFloat)lineLength lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor;

/// 给view添加10px圆角和阴影
- (void)addCornerAndShadow;

@end

CG_INLINE CGRect//注意：这里的代码要放在.m文件最下面的位置
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    CGFloat scale = [UIApplication sharedApplication].keyWindow.frame.size.width/375;
    rect.origin.x = x * scale;
    rect.origin.y = y * scale;
    rect.size.width = width * scale;
    rect.size.height = height * scale;
    return rect;
}


