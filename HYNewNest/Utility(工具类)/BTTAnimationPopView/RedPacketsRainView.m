//
//  RedPacketsRainView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/3.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "RedPacketsRainView.h"
@interface RedPacketsRainView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLab;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *redPocketsRainView;
@property (weak, nonatomic) IBOutlet UIView *cardsBonusView;
@property (weak, nonatomic) IBOutlet UIButton *showCardsButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CALayer *moveLayer;
@property (nonatomic, assign) NSInteger redPacketsResultCount;
@property (nonatomic, assign) NSInteger selectedRedPacketNum;
@property (nonatomic, assign) RedPocketsViewStyle viewStyle;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation RedPacketsRainView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRed:)];
    
    _tapGesture = tap;
    [self.tapGesture setEnabled:NO];
}
- (void)configForRedPocketsView:(RedPocketsViewStyle)style
{
    _viewStyle = style;
    switch (self.viewStyle) {
        case RedPocketsViewBegin:
            self.selectedRedPacketNum = 0;
            [self startTime];
            break;
        case RedPocketsViewResult:
            [self.tapGesture setEnabled:NO];
            self.redPacketsResultCount = 0;
            [self showResult];
            break;
            
        default:
            break;
    }
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (IBAction)showCardsBonus:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.cardsBonusView setAlpha:(sender.tag == 1) ? 1.0 : 0.0];
        [self.redPocketsRainView setAlpha:(sender.tag == 1) ? 0.0 : 1.0];
    }];
//    if (sender.tag == 1)
//    {
//        [self switchWithView:self.redPocketsRainView withPosition:RedPocketsViewToBack];
//        [self switchWithView:self.cardsBonusView withPosition:RedPocketsViewToFront];
//    }else
//    {
//        [self switchWithView:self.redPocketsRainView withPosition:RedPocketsViewToFront];
//        [self switchWithView:self.cardsBonusView withPosition:RedPocketsViewToBack];
//    }
    
}

- (void)startTime
{
    weakSelf(weakSelf)
    self.titleLabel.text = @"抢红包啦";
    __block int timeout = 1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf startRedPackerts];
                [weakSelf.tapGesture setEnabled:YES];
            });
        }
        else
        {
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countdownLab.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)startRedPackerts
{
    [self.redPocketsRainView addGestureRecognizer:self.tapGesture];
    float t = (arc4random() % 10) + 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/t) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    [self.timer fire];
    //红包下落10秒倒数
    self.titleLabel.text = @"红包结束倒数计时";
    
    weakSelf(weakSelf)
    __block int timeout = 10;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endAnimation];
            });
        }
        else
        {
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countdownLab.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)showRain
{
    UIImageView * imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"dsb_rb_bg"];
    imageV.frame = CGRectMake(0, -75, 44 , 62.5 );
    self.moveLayer = [CALayer new];
    self.moveLayer.bounds = imageV.frame;
    self.moveLayer.anchorPoint = CGPointMake(0, 0);
    self.moveLayer.position = CGPointMake(0, -75 );
    self.moveLayer.contents = (id)imageV.image.CGImage;
    [self.redPocketsRainView.layer addSublayer:self.moveLayer];
    [self addAnimation];
}
- (void)addAnimation
{
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % (int)self.width, 0)];
    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % (int)self.width, (int)self.height)];
    moveAnimation.values = @[A,B];
    moveAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    moveAnimation.repeatCount = 1;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.moveLayer addAnimation:moveAnimation forKey:@"p"];
    
    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tranAnimation.duration = arc4random() % 200 / 100.0 + 3.5;
    //为了避免旋转动画完成后再次回到初始状态。
    [tranAnimation setFillMode:kCAFillModeForwards];
    [tranAnimation setRemovedOnCompletion:NO];
    [self.moveLayer addAnimation:tranAnimation forKey:nil];
}
- (void)endAnimation
{
    [self.timer invalidate];
    [self.tapGesture setEnabled:NO];
    for (NSInteger i = 0; i < self.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        [layer setHidden:YES];
        [layer removeAllAnimations];
    }
    [self showResult];
}
-(void)showResult
{
    [self.closeButton setHidden:NO];
    WEAKSELF_DEFINE
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.titleLabel.text = @"红包加总";
        weakSelf.countdownLab.text = [NSString stringWithFormat:@"+%ld金币",(long)self.redPacketsResultCount];
        
    });
    [self.showCardsButton setHidden:NO];
}
- (void)clickRed:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    
    for (int i = 0 ; i < self.redPocketsRainView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        
        if ([[layer presentationLayer] hitTest:point] != nil && self.selectedRedPacketNum != i && ![layer isKindOfClass:[UILabel layerClass]])
        {
            NSLog(@"%d",i);
            self.selectedRedPacketNum = i;
//            BOOL hasRedPacketd = !(i % 3) ;
            BOOL hasRedPacketd = YES ;
            UIImageView * newPacketIV = [UIImageView new];
            if (hasRedPacketd)
            {
                newPacketIV.image = [UIImage imageNamed:@"dsb_content_108"];
                newPacketIV.frame = CGRectMake(0, 0, 44 , 62.5);
            }
            else
            {
                newPacketIV.image = [UIImage imageNamed:@"dsb_rb_close"];
                newPacketIV.frame = CGRectMake(0, 0, 45.5, 76.5);
            }
            layer.contents = (id)newPacketIV.image.CGImage;
            [layer removeAnimationForKey:@"p"];
            CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * A = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(self.width/2, self.height)];
            moveAnimation.values = @[A,B];
            moveAnimation.duration = 1.0;
            moveAnimation.repeatCount = 1;
            moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [layer addAnimation:moveAnimation forKey:@"p"];
            
            UIView * alertView = [UIView new];
            alertView.layer.cornerRadius = 5;
            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
            [self.redPocketsRainView addSubview:alertView];
            
            UILabel * label = [UILabel new];
            label.font = [UIFont systemFontOfSize:17];
            
            if (!hasRedPacketd)
            {
                label.text = @"旺旺年！人旺旺";
                label.textColor = [UIColor whiteColor];
            }
            else
            {
                self.redPacketsResultCount += i;
                NSString * string = [NSString stringWithFormat:@"+%d金币",i];
                NSString * iString = [NSString stringWithFormat:@"%d",i];
                NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:27]
                                      range:NSMakeRange(0, 1)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangTC-Semibold" size:32]
                                      range:NSMakeRange(1, iString.length)];
                [attributedStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:17]
                                      range:NSMakeRange(1 + iString.length, 2)];
                label.attributedText = attributedStr;
                label.textColor = COLOR_RGBA(255,223,14, 1);
            }
            
            [alertView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(alertView.mas_centerX);
                make.centerY.equalTo(alertView.mas_centerY);
            }];
            
            [UIView animateWithDuration:1 animations:^{
                alertView.alpha = 0;
                alertView.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
//                layer.opacity = 0;
            } completion:^(BOOL finished) {
                [alertView removeFromSuperview];
            }];
        }
    }
}
-(void)switchWithView: (UIView*)currentView withPosition:(RedPocketsViewPosition)positionValue
{
    CFTimeInterval durationValue = 0.5;
    CABasicAnimation *zPosition = [CABasicAnimation animation];
    zPosition.keyPath = @"zPosition";
    zPosition.fromValue = [NSNumber numberWithDouble: (positionValue == RedPocketsViewToFront) ? -1.0 : 1.0];
    zPosition.toValue = [NSNumber numberWithDouble:(positionValue == RedPocketsViewToFront) ? 1.0 : -1.0];
    zPosition.duration = durationValue;

    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.values = @[ @0, (positionValue == RedPocketsViewToFront) ? @-0.25 : @0.25, @0 ];
    rotation.duration = durationValue;
    rotation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
    ];

    CAKeyframeAnimation *position = [CAKeyframeAnimation animation];
    position.keyPath = @"position";
    position.values = @[
        [NSValue valueWithCGPoint:CGPointZero],
        [NSValue valueWithCGPoint:CGPointMake((positionValue == RedPocketsViewToFront) ? -300 : 300, (positionValue == RedPocketsViewToFront) ? 20 : -20)],
        [NSValue valueWithCGPoint:CGPointZero]
    ];
    position.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
    ];
    position.additive = YES;
    position.duration = durationValue;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ zPosition, rotation, position ];
    group.duration = durationValue;
    group.repeatCount = 1;
    
//    CABasicAnimation *makeBiggerAnim=[CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    makeBiggerAnim.fromValue=[NSNumber numberWithDouble:20.0];
//    makeBiggerAnim.toValue=[NSNumber numberWithDouble:40.0];
//
//    CABasicAnimation *fadeAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeAnim.fromValue=[NSNumber numberWithDouble:1.0];
//    fadeAnim.toValue=[NSNumber numberWithDouble:0.0];
//
//    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    rotateAnim.fromValue=[NSNumber numberWithDouble:0.0];
//    rotateAnim.toValue=[NSNumber numberWithDouble:M_PI_4];
//
//    // Customizing the group with duration etc, will apply to all the
//    // animations in the group
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.duration = 0.2;
//    group.repeatCount = 1;
//    group.autoreverses = YES;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    group.animations = @[makeBiggerAnim, fadeAnim, rotateAnim];
    
    [currentView.layer addAnimation:group forKey:@"shuffle"];
    currentView.layer.zPosition = (positionValue == RedPocketsViewToFront) ? 1 : -1;
    if (positionValue == RedPocketsViewToFront)
    {
        [self bringSubviewToFront:currentView];
    }
}
@end
