//
//  CNTextSaleBtn.h
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//  点击文字变大的按钮

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNTextSaleBtn : UIButton

@property (strong,nonatomic) UIColor *selColor; //!<选中颜色
@property (strong,nonatomic) UIColor *norColor; //!<普通颜色
@property (strong,nonatomic) UIFont *selFont; //!<选中字体
@property (strong,nonatomic) UIFont *norFont; //!<普通字体

@end

NS_ASSUME_NONNULL_END
