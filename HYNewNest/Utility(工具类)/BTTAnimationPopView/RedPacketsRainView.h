//
//  RedPacketsRainView.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/3.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"
// 定义弱引用
#define weakSelf(weakSelf)     __weak __typeof(&*self) weakSelf = self;
/**
 显示时动画弹框样式
 */
typedef NS_ENUM(NSInteger, RedPocketsViewStyle) {
    RedPocketsViewBegin = 0,    //活动开始
    RedPocketsViewrRaining,     //活动中
    RedPocketsViewResult,       //活动结果
    RedPocketsViewPrefix        //活动预热
};
typedef NS_ENUM(NSInteger, RedPocketsViewPosition) {
    RedPocketsViewToFront = 0,
    RedPocketsViewToBack
};
NS_ASSUME_NONNULL_BEGIN

@interface RedPacketsRainView : BTTBaseAnimationPopView
- (void)configForRedPocketsViewWithStyle:(RedPocketsViewStyle)style;
@end

NS_ASSUME_NONNULL_END

