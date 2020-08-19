//
//  UILabel+hiddenText.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (hiddenText)

@property (nonatomic, copy) NSString *originText;
@property (nonatomic, assign) BOOL isOriginTextHidden;

/// 文字变成*****
- (void)hideOriginText;

/// 文字复原
- (void)showOriginText;

@end

NS_ASSUME_NONNULL_END
