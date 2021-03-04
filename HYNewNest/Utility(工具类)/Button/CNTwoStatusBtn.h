//
//  CNTwoStatusBtn.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNTwoStatusBtn : UIButton
@property (assign,nonatomic) BOOL isThirdStatusEnable; // 按钮样式不同
@property (assign,nonatomic) IBInspectable CGFloat txtSize;
@end

NS_ASSUME_NONNULL_END
