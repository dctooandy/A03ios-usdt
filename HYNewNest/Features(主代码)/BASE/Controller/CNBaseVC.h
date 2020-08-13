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
-(void)addNaviLeftItemNil;
/// 导航栏右边按钮图片和事件，事件需重写
- (void)addNaviRightItemWithTitle:(NSString *)title;
- (void)addNaviRightItemWithImageName:(NSString *)name;
- (void)openH5Page:(NSString *)h5url title:(NSString *)title;
- (void)rightItemAction;

/// 用于首页游戏页面内容高度
@property (nonatomic, assign, readonly) CGFloat totalHeight;
@end

NS_ASSUME_NONNULL_END
