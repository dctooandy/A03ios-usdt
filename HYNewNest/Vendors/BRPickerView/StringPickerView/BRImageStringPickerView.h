//
//  BRImageStringPickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"

typedef void(^BRStringResultBlock)(id selectValue ,NSInteger index);
typedef void(^BRStringCancelBlock)(void);

@interface BRImageStringPickerView : BRBaseView

/**  需求需要，增加图片源
 *  1.显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数据源（1.直接传数组：NSArray类型；2.可以传plist文件名：NSString类型，带后缀名，plist文件内容要是数组格式）
 *  @param images          图片数组
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                           images:(NSArray <UIImage *> *)images
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(BRStringResultBlock)resultBlock;



@end
