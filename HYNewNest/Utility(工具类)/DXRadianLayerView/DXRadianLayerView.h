//
//  DXRadianLayerView.h
//  HYGEntire
//
//  Created by zaky on 26/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DXRadianDirection) {
    DXRadianDirectionBottom     = 0,
    DXRadianDirectionTop        = 1,
    DXRadianDirectionLeft       = 2,
    DXRadianDirectionRight      = 3,
};
@interface DXRadianLayerView : UIView

// 圆弧方向, 默认在下方
@property (nonatomic) DXRadianDirection direction;
// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;

@end

NS_ASSUME_NONNULL_END
