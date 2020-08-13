//
//  CNAlertPickerView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//  数组弹框列表选择器

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNAlertPickerView : CNBaseXibView
+ (void)showList:(NSArray<NSString *> *)list title:(NSString *)title finish:(void(^)(NSString *selectText))finish;
@end

NS_ASSUME_NONNULL_END
