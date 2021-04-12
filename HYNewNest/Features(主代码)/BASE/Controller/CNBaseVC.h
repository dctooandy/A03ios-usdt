//
//  CNBaseVC.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNBaseVC : UIViewController
{
    BOOL _hasRecord;     //第一次进入页面 手动赋值  用于记录
    NSDate *_launchDate; //刚进入页面时间 手动赋值  用于计时
}
-(void)addNaviLeftItemNil;
/// 导航栏右边按钮图片和事件，事件需重写
- (void)addNaviRightItemWithTitle:(NSString *)title;
- (void)addNaviRightItemWithImageName:(NSString *)name;
- (void)addNaviRightItemButton:(UIButton *)button;
- (void)rightItemAction;

/// 用于首页游戏页面内容高度
@property (nonatomic, assign, readonly) CGFloat totalHeight;
@end

NS_ASSUME_NONNULL_END
