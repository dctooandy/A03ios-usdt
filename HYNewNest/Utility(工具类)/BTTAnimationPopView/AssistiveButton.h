//
//  AssistiveButton.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/7.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistiveButton : UIView
typedef enum {
    SpreadPositionModeFixed,
    SpreadPositionModeTouchBorder,
    SpreadPositionModeNone
}SpreadPositionMode;

#define SPREAD_RADIUS_DEFAULT 100.0f
#define TOUCHBORDER_MARGIN_DEFAULT 10.0f
#define ANIMATION_DURING_TOUCHBORDER_DEFAULT 0.5f
#define MAGNETIC_SCOPE_RATIO_VERTICAL 0.15

@property (assign, nonatomic) SpreadPositionMode positionMode;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat touchBorderMargin;
@property (assign, nonatomic) CGPoint superViewRelativePosition;
@property (strong, nonatomic) UIButton *powerButton;
@property (assign, nonatomic) CGRect mainFrame;

typedef void (^MainButtonClickActionBlock)(void);
typedef void (^CloseBtnActionBlock)(void);
typedef void (^TenSecondActionBlock)(void);
@property (copy, nonatomic) MainButtonClickActionBlock mainButtonClickActionBlock;
@property (copy, nonatomic) CloseBtnActionBlock closeBtnActionBlock;
@property (copy, nonatomic) TenSecondActionBlock tenSecondActionBlock;
-(instancetype)initMainBtnWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage position:(CGPoint)position;
-(instancetype)initMainBtnWithCustomImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage;
- (void)refetchTimeForRainning;
@end

