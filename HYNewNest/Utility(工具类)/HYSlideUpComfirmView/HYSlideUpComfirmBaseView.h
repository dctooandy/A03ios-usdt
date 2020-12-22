//
//  HYSlideUpComfirmBaseView.h
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTwoStatusBtn.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SubmitComfirmBlock)(BOOL isComfirm);
typedef void(^SubmitComfirmArgsBlock)(BOOL isComfirm, id args, ...);


@interface HYSlideUpComfirmBaseView : UIView
@property (strong, nonatomic) UIView *topLine; 
// 半透明黑色背景
@property (nonatomic, strong) UIView *bgView;
// 滑出内容块
@property (nonatomic, strong) UIView *contentView;
// 确认按钮
@property (nonatomic, strong) CNTwoStatusBtn *comfirmBtn;
// 标题
@property (nonatomic, strong) UILabel *titleLbl;
// 关闭按钮
@property (strong,nonatomic) UIButton *cancelBtn;

// 确认按钮回调1(优先级1>2)  如果是点击了按钮isComfirm为YES 如果是点击X关闭则为NO
@property (nonatomic, copy) SubmitComfirmBlock submitHandler;

// 确认按钮回调2  isComfirm & 不定参数
@property (nonatomic, copy) SubmitComfirmArgsBlock submitArgsHandler;

/*
- (int)sum:(int)num, ...
{
    int result = num;
    int objNum;
    
    va_list arg_list;
    va_start(arg_list, num);
    while ((objNum = va_arg(arg_list, int))) {
        result += objNum;
    }
    va_end(arg_list);
    return result;
}
复制代码
va_list：用来保存宏 va_start 、va_arg 和 va_end 所需信息的一种类型。为了访问变长参数列表中的参数，必须声明 va_list 类型的一个对象。

va_start：访问变长参数列表中的参数之前使用的宏，它初始化用 va_list 声明的对象，初始化结果供宏va_arg和va_end使用；

va_arg：展开成一个表达式的宏，该表达式具有变长参数列表中下一个参数的值和类型。每次调用 va_arg 都会修改，用 va_list 声明的对象从而使该对象指向参数列表中的下一个参数。

va_end：该宏使程序能够从变长参数列表用宏 va_start 引用的函数中正常返回。
 */

// 在layousubView中修改contentView及其子控件的布局 show已调用
- (instancetype)initWithContentViewHeight:(CGFloat)height
                                    title:(NSString *)title
                           comfirmBtnText:(NSString *)btnTitle;

/// 重写该方法如果需要传递不定参数
- (void)touchupComfirmBtn;

//- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
