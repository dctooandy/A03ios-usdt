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
        UIImage * closeImage = [UIImage imageNamed:@"ic_new_year_pop_close_btn"];
        CGFloat assistiveBtnHeight = 132 + [UIImage imageNamed:@"ic_new_year_pop_close_btn"].size.height;
        CGFloat loginBtnViewHeight = 87;
        CGFloat postionY = SCREEN_HEIGHT - kTabbarHeight - assistiveBtnHeight/2 - loginBtnViewHeight;
        CGPoint position = CGPointMake( assistiveBtnHeight/2 + 10, postionY);
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
        
        UILabel *countDownTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.powerButton.size.width, 20)];
        UILabel *countDownMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.powerButton.size.height * 0.25, self.powerButton.size.width, 20)];
        UILabel *countDownBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.powerButton.size.height * 0.50, self.powerButton.size.width, 20)];
        UILabel *countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.powerButton.size.height * 0.75, self.powerButton.size.width, 20)];
        countDownTopLabel.textAlignment = NSTextAlignmentCenter;
        countDownMiddleLabel.textAlignment = NSTextAlignmentCenter;
        countDownBottomLabel.textAlignment = NSTextAlignmentCenter;
        countDownLabel.textAlignment = NSTextAlignmentCenter;
        countDownTopLabel.textColor = [UIColor redColor];
        countDownMiddleLabel.textColor = [UIColor redColor];
        countDownBottomLabel.textColor = [UIColor redColor];
        countDownLabel.textColor = [UIColor redColor];
        countDownTopLabel.font = [UIFont systemFontOfSize:12];
        countDownMiddleLabel.font = [UIFont systemFontOfSize:12];
        countDownBottomLabel.font = [UIFont systemFontOfSize:12];
        countDownLabel.font = [UIFont systemFontOfSize:12];
        countDownTopLabel.text = @"虎福贺新春";
        countDownMiddleLabel.text = @"天降红包雨";
        countDownBottomLabel.text = @"倒计时：";
        countDownLabel.text = @"5天23小时12分30秒";
        [self addSubview:countDownTopLabel];
        [self addSubview:countDownMiddleLabel];
        [self addSubview:countDownBottomLabel];
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
            BOOL isBeforeDuration = [PublicMethod checksStartDate:@"2021-01-01" EndDate:@"2022-01-31" serverTime:timeStr];
            BOOL isActivityDuration = [PublicMethod checksStartDate:@"2022-02-01" EndDate:@"2022-02-07" serverTime:timeStr];
            
            if (isBeforeDuration || isActivityDuration)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSDate *startDate;
                NSTimeInterval startDateTime = 0;
                NSTimeInterval secondStartDateTime = 0;
                NSTimeInterval countDownInterval = 0;
                if (!isActivityDuration)
                {
                    // 不到时间,预热
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    startDate = [dateFormatter dateFromString:@"2022-02-01"];
                    startDateTime = [[NSDate date] timeIntervalSinceDate:startDate];
                    countDownInterval = -startDateTime;
                }else
                {
                    // 活动期间
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    startDate = [dateFormatter dateFromString:@"2022-02-01 10:00"];// 第一天早上10点
                    startDateTime = (int)[[NSDate date] timeIntervalSinceDate:startDate] % (60 * 60 * 24);
                    secondStartDateTime = startDateTime - (60 * 60 * 4);

                    if (startDateTime < 0)
                    {
                        //早于10点
                        countDownInterval = -startDateTime;
                    } else if (secondStartDateTime < 0)
                    {
                        //介于10点到14点
                        countDownInterval = -secondStartDateTime;
                    }else
                    {
                        //晚于14点
                        countDownInterval = (60*60*24 - secondStartDateTime);
                    }
                }
                __block int timeout = countDownInterval;
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


