//
//  HYBaseAlertView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertEasyBlock)(void);
typedef void(^AlertComfirmBlock)(BOOL isComfirm);

/// 弹窗基类
@interface HYBaseAlertView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) AlertEasyBlock easyBlock;
@property (nonatomic, copy) AlertComfirmBlock comfirmBlock;

-(void)show;
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
