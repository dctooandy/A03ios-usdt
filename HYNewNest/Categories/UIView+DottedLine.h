//
//  UIView+DottedLine.h
//  HYGEntire
//
//  Created by zaky on 25/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DottedLine)

- (void)addDottedLineWithView:(UIView *)view borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor;

@end

NS_ASSUME_NONNULL_END
