//
//  LTSegmentedBar.h
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSegmentedBarConfig : NSObject

@property (nonatomic, strong) UIColor *segmentedBarBackgroundColor;

@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIFont  *itemNormalFont;
@property (nonatomic, strong) UIFont  *itemSelectFont;
/// 每个按钮的宽度按屏幕宽度平均分 （如果设置了该值 按钮平均宽度 点击不会滚动）
@property (nonatomic, assign) BOOL itemWidthFit;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat indicatorHeight;
/// 每个indicator宽度 （如果设置了该值就不会随文字宽度改变）
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat indicatorExtraW;

@property (nonatomic, strong) UIColor *splitLineColor;

+ (instancetype)defaultConfig;


@end


@class LTSegmentedBar;
@protocol LTSegmentedBarDelegate <NSObject>

/**
 代理方法, 将内部的点击数据传递给外部
 
 @param segmentedBar    segmentedBar
 @param toIndex         选中的索引(从0开始)
 @param fromIndex       上一个索引
 */
- (void)segmentBar: (LTSegmentedBar *)segmentedBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end


@interface LTSegmentedBar : UIView

@property (nonatomic, weak) id<LTSegmentedBarDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSArray <NSString *>*items;
/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectedIndex;

+ (LTSegmentedBar *)segmentedBarWithFrame:(CGRect)frame;
- (void)updateWithConfig: (void(^)(LTSegmentedBarConfig *config))configBlock;

@end



