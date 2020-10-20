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

@interface HYSlideUpComfirmBaseView : UIView
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
// 确认按钮回调1
@property (nonatomic, copy) void(^submitHandler)(void);
// 外传参数
@property (nonatomic, strong) id args;
// 确认按钮回调2
@property (nonatomic, copy) void(^submitArgsHandler)(id anyData);

// 在layousubView中修改contentView及其子控件的布局 show已调用
- (instancetype)initWithContentViewHeight:(CGFloat)height
                                    title:(NSString *)title
                           comfirmBtnText:(NSString *)btnTitle;
//- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
