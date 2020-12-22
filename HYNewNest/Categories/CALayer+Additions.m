//
//  CALayer+Additions.m
//  HYNewNest
//
//  Created by zaky on 12/9/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

/// 用于xib中User Defined Runtime Attributes设置颜色
- (void)setBorderColorFromUIColor:(UIColor *)color {

    self.borderColor = color.CGColor;

}

@end
