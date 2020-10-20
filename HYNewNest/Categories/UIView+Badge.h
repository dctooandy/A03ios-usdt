//
//  UIView+Badge.h
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Badge)

- (void)showRedAtOffSetX:(float)offsetX offsetYMultiple:(float)offsetYM OrValue:(NSString *)value;
- (void)hideRedPoint;

- (void)showRightTopImageName:(NSString *)imgName size:(CGSize)size offsetX:(float)offsetX offsetYMultiple:(float)offsetYM;

@end

NS_ASSUME_NONNULL_END
