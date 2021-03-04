//
//  CNTwoStatusBtn.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNTwoStaBtnStatus) {
    /* enable为NO时的样式
     */
    CNTwoStaBtnStatusNone = 0,
    
    /* 渐变背景 白色文字 默认样式
     */
    CNTwoStaBtnStatusGradientBG,
    
    /* 渐变边框 蓝色文字 需要手动修改的样式
     */
    CNTwoStaBtnStatusGradientLayer,
};

@interface CNTwoStatusBtn : UIButton
@property (assign,nonatomic) CNTwoStaBtnStatus status; // 样式

@property (assign,nonatomic) IBInspectable NSUInteger ibStatus; // 样式适配器（用于在xib中调试）
@property (assign,nonatomic) IBInspectable CGFloat txtSize; // 文字大小
@end

NS_ASSUME_NONNULL_END
