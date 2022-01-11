//
//  RedPacketsRainView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/3.
//  Copyright © 2022 BTT. All rights reserved.
//
#import "PublicMethod.h"
#import "RedPacketsRainView.h"
#import "SDCycleScrollView.h"
#import <Masonry/Masonry.h>
#import "QBulletScreenView.h"
@interface RedPacketsRainView()<SDCycleScrollViewDelegate , QBulletScreenViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLab;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *rainBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *redPocketsRainView;
@property (weak, nonatomic) IBOutlet UIView *cardsBonusView;
@property (weak, nonatomic) IBOutlet UIButton *showCardsButton;
@property (weak, nonatomic) IBOutlet UIView *activityRuleView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CALayer *moveLayer;
@property (nonatomic, strong) CALayer *bagMoveLayer;
@property (nonatomic, assign) NSInteger redPacketsResultCount;
@property (nonatomic, assign) NSInteger selectedRedPacketNum;
@property (nonatomic, assign) RedPocketsViewStyle viewStyle;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) SDCycleScrollView *giftBannerView;
@property (nonatomic, strong) NSMutableArray *bulletViewsArr;
@end

@implementation RedPacketsRainView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.bulletViewsArr = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRed:)];
    
    _tapGesture = tap;
    [self.tapGesture setEnabled:NO];
}
- (void)configForRedPocketsView:(RedPocketsViewStyle)style withDuration:(int)duration
{
    _viewStyle = style;
    switch (self.viewStyle) {
        case RedPocketsViewBegin:
            self.selectedRedPacketNum = 0;
            [self startTimeWithDuration:duration];
            [self setupImageGroup];
            [self setupDataForSortArray];
            [self startGiftBag];
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
-(void)setupImageGroup
{
//    FiveStarCopy
//    FourStarCopy
    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"赌侠",@"赌神", nil];
    
    self.bannerView.imageURLStringsGroup = h5Images;
}
- (void)setupGiftBannerGroup
{
    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"赌侠",@"赌神", nil];
    
    self.giftBannerView.localizationImageNamesGroup = h5Images;
    NSArray * nameArray = @[@[@"g****8",@"g****9",@"g****86",@"g****81",@"g****88",@"g****81"],@[@"g****8",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"]];
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    for (NSArray * subNameArray in nameArray) {
        NSString *totalString = @"";
        for (int i = 0 ; i < subNameArray.count ; i++) {
            totalString = [totalString stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",(i == 0 ? @"恭喜":@""),subNameArray[i],(i == (subNameArray.count - 1) ? @"会员获得该奖品" : @"、")]];
        }
        [descriptionArray addObject:totalString];
    }
    self.giftBannerView.descriptionGroup = descriptionArray;
}

// 开启规则画面
- (IBAction)showRulesAction:(id)sender {
    if (self.activityRuleView.alpha == 0)
    {
        [self bringSubviewToFront:self.activityRuleView];
        [UIView animateWithDuration:0.3 animations:^{
            self.activityRuleView.alpha = 1;
        }];
    }
}
// 关闭规则画面
- (IBAction)dismissRulesView {
    if (self.activityRuleView.alpha == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.activityRuleView.alpha = 0;
        } completion:^(BOOL finished) {
            [self sendSubviewToBack:self.activityRuleView];
        }];
    }
}
// 关闭活动画面
- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
// 开启集福卡画面
- (IBAction)showCardsBonus:(UIButton*)sender {
    [self setupGiftBannerGroup];
    [UIView animateWithDuration:0.3 animations:^{
        [self.cardsBonusView setAlpha:(sender.tag == 1) ? 1.0 : 0.0];
        [self.rainBackgroundView setAlpha:(sender.tag == 1) ? 0.0 : 1.0];
        [self.labelBackgroundView setAlpha:(sender.tag == 1) ? 0.0 : 1.0];
        [self dismissRulesView];
    }];
//    if (sender.tag == 1)
//    {
//    [self switchWithView:self.labelBackgroundView withPosition:RedPocketsViewToBack];
//    [self switchWithView:self.rainBackgroundView withPosition:RedPocketsViewToBack];
//    [self switchWithView:self.cardsBonusView withPosition:RedPocketsViewToFront];
//    }else
//    {
//    [self switchWithView:self.labelBackgroundView withPosition:RedPocketsViewToFront];
//    [self switchWithView:self.labelBackgroundView withPosition:RedPocketsViewToFront];
//    [self switchWithView:self.cardsBonusView withPosition:RedPocketsViewToBack];
//    }
}

- (void)startTimeWithDuration:(int)timeValue
{
    weakSelf(weakSelf)

    __block int timeout = timeValue;
    NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
    BOOL isBeforeDuration = [duractionArray[0] boolValue];
    BOOL isActivityDuration = [duractionArray[1] boolValue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.labelBackgroundView setAlpha:0.0];
                [weakSelf startRedPackerts];
                [weakSelf.tapGesture setEnabled:YES];
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
}
- (void)startRedPackerts
{
    [self.redPocketsRainView addGestureRecognizer:self.tapGesture];
    float t = (arc4random() % 10) + 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/t) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    [self.timer fire];
    
    //红包下落10秒倒数
    weakSelf(weakSelf)
    __block int timeout = RedPacketCountDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endAnimation];
                [weakSelf.labelBackgroundView setAlpha:1.0];
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
- (void)setBag
{
    [self startGiftBag];
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
- (void)startGiftBag
{
    UIImageView * imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"dsb_rb_bg"];
    imageV.frame = CGRectMake(0, 0, 100 , 100 );
    self.bagMoveLayer = [CALayer new];
    self.bagMoveLayer.bounds = imageV.frame;
    self.bagMoveLayer.anchorPoint = CGPointMake(0, 1);
    self.bagMoveLayer.position = CGPointMake(0, SCREEN_HEIGHT );
    self.bagMoveLayer.contents = (id)imageV.image.CGImage;
    [self.rainBackgroundView.layer addSublayer:self.bagMoveLayer];
    
    CAKeyframeAnimation * bagTranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D br0 = CATransform3DMakeRotation((-14) / 180.0 * M_PI, 0, 0, -1);
    CATransform3D br1 = CATransform3DMakeRotation((0) / 180.0 * M_PI , 0, 0, -1);
    bagTranAnimation.values = @[[NSValue valueWithCATransform3D:br0],[NSValue valueWithCATransform3D:br1]];
    bagTranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bagTranAnimation.duration = 1;
    bagTranAnimation.repeatCount = NSIntegerMax;
    bagTranAnimation.autoreverses = true;
    //为了避免旋转动画完成后再次回到初始状态。
    [bagTranAnimation setFillMode:kCAFillModeForwards];
    [bagTranAnimation setRemovedOnCompletion:NO];
    [self.bagMoveLayer addAnimation:bagTranAnimation forKey:@"bag"];
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
    for (NSInteger i = 0; i < self.redPocketsRainView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        [layer setHidden:YES];
        [layer removeAllAnimations];
    }
    for (NSInteger i = 0; i < self.rainBackgroundView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.rainBackgroundView.layer.sublayers[i];
        if ([layer animationForKey:@"bag"])
        {
//            [layer setHidden:YES];
            NSInteger scaleValue = 3;
            [layer removeAnimationForKey:@"bag"];
            CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * A = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT-100)];
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2 - (100 / 2 * scaleValue), SCREEN_HEIGHT/2)];
            moveAnimation.values = @[A,B];
            moveAnimation.duration = 0.3;
            moveAnimation.repeatCount = 0;
            moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [moveAnimation setFillMode:kCAFillModeForwards];
            [moveAnimation setRemovedOnCompletion:NO];
            [layer addAnimation:moveAnimation forKey:@"bagFly"];
            layer.transform = CATransform3DMakeScale(scaleValue, scaleValue, 1);
        }
    }
    [self showResult];
}
-(void)showResult
{
    [self.closeButton setHidden:NO];
    self.countdownLab.text = [NSString stringWithFormat:@"+%ld金币",(long)self.redPacketsResultCount];
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
//            UIImageView * newPacketIV = [UIImageView new];
//            if (hasRedPacketd)
//            {
//                newPacketIV.image = [UIImage imageNamed:@"dsb_content_108"];
//                newPacketIV.frame = CGRectMake(0, 0, 44 , 62.5);
//            }
//            else
//            {
//                newPacketIV.image = [UIImage imageNamed:@"dsb_rb_close"];
//                newPacketIV.frame = CGRectMake(0, 0, 45.5, 76.5);
//            }
//            layer.contents = (id)newPacketIV.image.CGImage;
            [layer removeAnimationForKey:@"p"];
            CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * A = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(self.width/5, self.height)];
            moveAnimation.values = @[A,B];
            moveAnimation.duration = 0.5;
            moveAnimation.repeatCount = 1;
            moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [layer addAnimation:moveAnimation forKey:@"p"];
            
//            UIView * alertView = [UIView new];
//            alertView.layer.cornerRadius = 5;
//            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
//            [self.redPocketsRainView addSubview:alertView];
//
//            UILabel * label = [UILabel new];
//            label.font = [UIFont systemFontOfSize:17];
            
            if (!hasRedPacketd)
            {
//                label.text = @"旺旺年！人旺旺";
//                label.textColor = [UIColor whiteColor];
            }
            else
            {
                self.redPacketsResultCount += i;
//                NSString * string = [NSString stringWithFormat:@"+%d金币",i];
//                NSString * iString = [NSString stringWithFormat:@"%d",i];
//                NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
//
//                [attributedStr addAttribute:NSFontAttributeName
//                                      value:[UIFont systemFontOfSize:27]
//                                      range:NSMakeRange(0, 1)];
//                [attributedStr addAttribute:NSFontAttributeName
//                                      value:[UIFont fontWithName:@"PingFangTC-Semibold" size:32]
//                                      range:NSMakeRange(1, iString.length)];
//                [attributedStr addAttribute:NSFontAttributeName
//                                      value:[UIFont systemFontOfSize:17]
//                                      range:NSMakeRange(1 + iString.length, 2)];
//                label.attributedText = attributedStr;
//                label.textColor = COLOR_RGBA(255,223,14, 1);
            }
            
//            [alertView addSubview:label];
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(alertView.mas_centerX);
//                make.centerY.equalTo(alertView.mas_centerY);
//            }];
//
//            [UIView animateWithDuration:1 animations:^{
//                alertView.alpha = 0;
//                alertView.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
////                layer.opacity = 0;
//            } completion:^(BOOL finished) {
//                [alertView removeFromSuperview];
//            }];
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

#pragma mark Lazy Load
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        [self.activityRuleView addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.activityRuleView);
            make.height.equalTo(self.activityRuleView).multipliedBy(0.85);
        }];
        bannerView.layer.cornerRadius = 10;
        bannerView.layer.masksToBounds = true;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleDefault;
        bannerView.pageControlDotSize = CGSizeMake(6, 6);
//        bannerView.autoScrollTimeInterval = 0;
        bannerView.autoScroll = false;
        _bannerView = bannerView;
    }
    return _bannerView;
}
- (SDCycleScrollView *)giftBannerView {
    if (!_giftBannerView) {
        SDCycleScrollView *giftBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        [self.cardsBonusView addSubview:giftBannerView];
        [giftBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.cardsBonusView);
            make.top.equalTo(@50);
            make.height.equalTo(self.cardsBonusView).multipliedBy(0.20);
        }];
        giftBannerView.layer.cornerRadius = 10;
        giftBannerView.layer.masksToBounds = true;
        giftBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        giftBannerView.pageControlStyle = SDCycleScrollViewPageContolStyleDefault;
        giftBannerView.pageControlDotSize = CGSizeMake(6, 6);
//        bannerView.autoScrollTimeInterval = 0;
        giftBannerView.autoScroll = false;
        _giftBannerView = giftBannerView;
    }
    return _giftBannerView;
}
- (void)setupDataForSortArray
{
    NSArray * tempArray = [[NSArray alloc] initWithObjects:@"111111",@"222222",@"33333", nil];
    [self sortArray:tempArray];
}
- (void)sortArray:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    NSInteger rowCount = 3.0;
    NSInteger count = ceil(array.count/floor(rowCount));
    for (int i = 0; i < rowCount; i++) {
        NSMutableArray * strArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < count; j++) {
            NSInteger a = (i * count) + j;
            if (a <= array.count-1) {
                [strArray addObject:array[a]];
            } else {
                break;
            }
        }
        NSInteger randomNum = random() % 5;
        dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, ((randomNum == 0 ? 1:randomNum) * NSEC_PER_SEC));
        dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
            [self setBulletScreen:strArray positionY: (KIsiPhoneX ? 34 + 50 : 50) + i * 32.0];
        });
    }
}
- (void)setBulletScreen:(NSArray *)array positionY:(CGFloat)positionY {
    // 创建弹幕视图控件
    // 设置动画时间 animationDuration
    // 设置动画方向 animationDirection ex: QBulletScreenViewDirectionLeft
    UIImage * img = [UIImage imageNamed:@"ic_new_year_pop_btn"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 15, 120, 40)];
    QBulletScreenView *bulletScreenView = [QBulletScreenView q_bulletScreenWithFrame:CGRectMake(0, positionY, 0, 25) texts:array color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] icon:nil direction:QBulletScreenViewDirectionLeft duration:5.0 target:self backgroundImg:img];
    [self.rainBackgroundView addSubview:bulletScreenView];
    [self.bulletViewsArr addObject:bulletScreenView];
    // 开始滚动
    [bulletScreenView q_startAnimation];
}
- (void)didClickContentAtIndex:(NSInteger)index
{
    
}
@end
