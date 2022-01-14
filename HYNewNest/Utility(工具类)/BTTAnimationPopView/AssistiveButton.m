//
//  AssistiveButton.m
//  HYNewNest
//
//  Created by RM03 on 2022/1/7.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "AssistiveButton.h"
#import "PublicMethod.h"

typedef void (^TimeCompleteBlock)(NSString * timeStr);
@interface AssistiveButton () <CAAnimationDelegate>
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) UILabel *countdownLab;
@end

@implementation AssistiveButton

-(instancetype)initMainBtnWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage position:(CGPoint)position {
    self = [super init];
    if (self) {
        UIImage * closeImage = [UIImage imageNamed:@"ic_new_year_pop_close_btn"];
//        self.mainFrame = CGRectMake(position.x, position.y, backgroundImage.size.width, backgroundImage.size.height);
        self.mainFrame = CGRectMake(position.x, position.y, 132, 132);
        self.superViewRelativePosition = position;
        
        //main Button
//        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 132, 132)];
        [self.powerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.powerButton.tag = 0;
        self.powerButton.adjustsImageWhenHighlighted = NO;
        [self.powerButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_powerButton];
        
//        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.size.width-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(132-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tag = 1;
        closeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:closeBtn];
        
        //configuration
        [self configureDefaultValue];
        [self setFrame:_mainFrame];
        self.center = position;
//        [self configureGesture];
    }
    return self;
}
-(instancetype)initMainBtnWithCustomImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage
{
    self = [super init];
    if (self) {
        UIImage * closeImage = [UIImage imageNamed:@"assisClose"];
        CGFloat assistiveBtnHeight = 190 + 30;
        CGFloat loginBtnViewHeight = 87;
        CGFloat postionY = SCREEN_HEIGHT - kTabbarHeight - assistiveBtnHeight/2 - loginBtnViewHeight;
        CGPoint position = CGPointMake( assistiveBtnHeight/2 + 10, postionY);
        self.mainFrame = CGRectMake(position.x, position.y, 180, 190);
        self.superViewRelativePosition = position;
        
        //main Button
//        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
        self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 190)];
        [self.powerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.powerButton.tag = 0;
        self.powerButton.adjustsImageWhenHighlighted = NO;
        [self.powerButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_powerButton];
        
//        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.size.width-closeImage.size.width, 0, closeImage.size.width, closeImage.size.height)];
        UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(180 - 30, 0, 30, 30)];
        [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tag = 1;
        closeBtn.adjustsImageWhenHighlighted = NO;
        [self addSubview:closeBtn];
        

        UILabel *countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.powerButton.size.height * 0.80, self.powerButton.size.width - 5, 20)];

        countDownLabel.textAlignment = NSTextAlignmentLeft;

        countDownLabel.textColor = kHexColorAlpha(0xFFEC85, 1.0);

        countDownLabel.font = [UIFont systemFontOfSize:13];

        countDownLabel.text = @"5天23小时12分30秒";

        [self addSubview:countDownLabel];
        _countdownLab = countDownLabel;
        [self startTime];
        //configuration
        [self configureDefaultValue];
        [self setFrame:_mainFrame];
        self.center = position;
    }
    return self;
}
-(void)serverTime:(TimeCompleteBlock)completeBlock {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    completeBlock([dateFormatter stringFromDate:timeDate]);
}
-(NSString *)serverHourTime{
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:timeDate];
}
- (void)startTime
{
    WEAKSELF_DEFINE
    [self serverTime:^(NSString *timeStr) {
        if (timeStr.length > 0)
        {
            NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
            BOOL isBeforeDuration = [duractionArray[0] boolValue];
            BOOL isActivityDuration = [duractionArray[1] boolValue];
            if (isBeforeDuration || isActivityDuration)
            {
                __block int timeout = [PublicMethod countDownIntervalWithDurationTag:isActivityDuration];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
                dispatch_source_set_event_handler(_timer, ^{
                    if ( timeout <= 0 )
                    {
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                [weakSelf startRedPackerts];
                            //                [weakSelf.tapGesture setEnabled:YES];
                        });
                    }
                    else
                    {
                        int dInt = (int)timeout / (3600 * 24);      //剩馀天数
                        int leftTime = timeout - (dInt * 3600 * 24);
                        int hInt = (int)leftTime / 3600;            //剩馀时数
                        int mInt = (int)leftTime / 60 % 60;         //剩馀分数
                        int sInt = (int)leftTime % 60;              //剩馀秒数
                        NSString * titleStr;
                        if (isActivityDuration)
                        {
                            titleStr = [NSString stringWithFormat:@"%d小时%d分%d秒",hInt,mInt,sInt];
                        }else
                        {
                            titleStr = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",dInt,hInt,mInt,sInt];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.countdownLab.text = titleStr;
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }else
            {
                // 过了活动期
            }
        }
    }];
}

-(void)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            if (self.mainButtonClickActionBlock) {
                self.mainButtonClickActionBlock();
            }
        }
            break;
        case 1:
        {
            if (self.closeBtnActionBlock) {
                self.closeBtnActionBlock();
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)configureDefaultValue {
    self.radius = SPREAD_RADIUS_DEFAULT;
    self.touchBorderMargin = TOUCHBORDER_MARGIN_DEFAULT;
}

- (void)configureGesture {
    UIPanGestureRecognizer *panGestureRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSpreadButton:)];
    [self addGestureRecognizer:panGestureRecongnizer];
}

- (void)panSpreadButton:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [_animator removeAllBehaviors];
            break;
        case UIGestureRecognizerStateEnded:
            switch (_positionMode) {
                case SpreadPositionModeFixed:
                {
                    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:_superViewRelativePosition];
                    snapBehavior.damping = 0.5;
                    [_animator addBehavior:snapBehavior];
                    break;
                }
                case SpreadPositionModeTouchBorder:
                {
                    CGPoint location = [gesture locationInView:self.superview];
                    if (![self.superview.layer containsPoint:location]) {
                        //outside superView
                        location = self.center;
                    }
                    CGSize superViewSize = self.superview.bounds.size;
                    CGFloat magneticDistance = superViewSize.height * MAGNETIC_SCOPE_RATIO_VERTICAL;
                    CGPoint destinationLocation;
                    if (location.y < magneticDistance) {//上面区域
                        destinationLocation = CGPointMake(location.x, self.bounds.size.width/2 + _touchBorderMargin);
                        if (location.x < self.bounds.size.width/2 + _touchBorderMargin) {
                            destinationLocation.x = self.bounds.size.width/2 + _touchBorderMargin;
                        } else if (location.x > superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin)) {
                            destinationLocation.x = superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin);
                        }
                    } else if (location.y > superViewSize.height - magneticDistance) {//下面
                        destinationLocation = CGPointMake(location.x, superViewSize.height - self.bounds.size.height/2 - _touchBorderMargin - kTabbarHeight);
                        if (location.x < self.bounds.size.width/2 + _touchBorderMargin) {
                            destinationLocation.x = self.bounds.size.width/2 + _touchBorderMargin;
                        } else if (location.x > superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin)) {
                            destinationLocation.x = superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin);
                        }
                    } else if (location.x > superViewSize.width/2) {//右边
                        destinationLocation = CGPointMake(superViewSize.width - (self.bounds.size.width/2 + _touchBorderMargin), location.y);
                    } else {//左边
                        destinationLocation = CGPointMake(self.bounds.size.width/2 + _touchBorderMargin, location.y);
                    }
                    
                    CABasicAnimation *touchBorderAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                    touchBorderAnimation.delegate = self;
                    touchBorderAnimation.removedOnCompletion = NO;//动画完成后不去除Animation
                    touchBorderAnimation.fromValue = [NSValue valueWithCGPoint:location];
                    touchBorderAnimation.toValue = [NSValue valueWithCGPoint:destinationLocation];
                    touchBorderAnimation.duration = ANIMATION_DURING_TOUCHBORDER_DEFAULT;
                    touchBorderAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [self.layer addAnimation:touchBorderAnimation forKey:@"touchBorder"];
                    
                    [CATransaction begin];
                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                    self.layer.position = destinationLocation;
                    [CATransaction commit];
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        default:
        {
            CGPoint location = [gesture locationInView:self.superview];
            if ([self.superview.layer containsPoint:location]) {
                self.center = location;
            }
            break;
        }
    }
}
- (void)setPositionMode:(SpreadPositionMode)positionMode
{
    _positionMode = positionMode;
    if (positionMode != SpreadPositionModeNone)
    {
        [self configureGesture];
    }
}
- (void)didMoveToSuperview {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
}

@end


