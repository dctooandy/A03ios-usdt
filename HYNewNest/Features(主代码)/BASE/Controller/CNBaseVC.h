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
/// 导航栏右边按钮图片和事件，事件需重写
- (void)addNaviRightItemWithImageName:(NSString *)name;
- (void)rightItemAction;
- (void)openH5Page:(NSString *)h5url title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
