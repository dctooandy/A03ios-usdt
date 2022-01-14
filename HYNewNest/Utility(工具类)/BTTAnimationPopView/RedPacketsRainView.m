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

#import "UIImage+GIF.h"
@interface RedPacketsRainView()<SDCycleScrollViewDelegate , QBulletScreenViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *centerGiftBagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mammonImageView;

@property (weak, nonatomic) IBOutlet UILabel *countdownLab;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *rainBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *rainBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *redPocketsRainView;
@property (weak, nonatomic) IBOutlet UIView *cardsBonusView;
@property (weak, nonatomic) IBOutlet UIImageView *showCardsImageView;
@property (weak, nonatomic) IBOutlet UIButton *showCardsButton;
@property (weak, nonatomic) IBOutlet UIView *activityRuleView;
@property (weak, nonatomic) IBOutlet UIButton *backToRedPacketsViewBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownLabelCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mammonTop;
@property (weak, nonatomic) IBOutlet UIView *labelMaskView;
@property (weak, nonatomic) IBOutlet UILabel *countDownTitleLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *autoOpenBagTimer;
@property (nonatomic, strong) CALayer *moveLayer;
@property (nonatomic, strong) CALayer *bagMoveLayer;
@property (nonatomic, assign) NSInteger redPacketsResultCount;
@property (nonatomic, assign) NSInteger selectedRedPacketNum;
@property (nonatomic, assign) RedPocketsViewStyle viewStyle;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) SDCycleScrollView *giftBannerView;
@property (nonatomic, strong) NSMutableArray *bulletViewsArr;
@property (weak, nonatomic) IBOutlet UIView *bagView;
@property (weak, nonatomic) IBOutlet UIView *bagResultView;
@property (weak, nonatomic) IBOutlet UIImageView *bagImageView;

@property (weak, nonatomic) IBOutlet UIButton *openGiftBagButton;
@property (weak, nonatomic) IBOutlet UIButton *closeGiftBagButton;

@end

@implementation RedPacketsRainView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.bulletViewsArr = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRed:)];
    _tapGesture = tap;
    [self.tapGesture setEnabled:NO];
    self.openGiftBagButton.layer.borderColor = COLOR_RGBA(219, 168, 143, 1).CGColor;
    self.openGiftBagButton.layer.borderWidth = 1;
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
            [self setupShowGiftBagButtonAnimation];
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
    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"popup1",@"popup2", nil];
    
    self.bannerView.imageURLStringsGroup = h5Images;
}
- (void)setupGiftBannerGroup
{
    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"FiveStarCopy",@"FourStarCopy", nil];
    
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

- (void)showRain
{
    int hasRedPacket = (arc4random() % 3);
    UIImageView * imageV = [UIImageView new];
    switch (hasRedPacket) {
        case 0:
            imageV.image = [UIImage imageNamed:@"img_coin"];
            imageV.frame = CGRectMake(0, 0, 34 , 26 );
            break;
        case 1:
            imageV.image = [UIImage imageNamed:@"img_goldingots"];
            imageV.frame = CGRectMake(0, 0, 46 , 29 );
            break;
        case 2:
            imageV.image = [UIImage imageNamed:@"img_redenvelope_default"];
            imageV.frame = CGRectMake(0, 0, 44 , 62.5 );
            break;
        default:
            break;
    }
    self.moveLayer = [CALayer new];
    self.moveLayer.bounds = imageV.frame;
    self.moveLayer.anchorPoint = CGPointMake(0, 0);
    self.moveLayer.position = CGPointMake(0, -75 );
    self.moveLayer.contents = (id)imageV.image.CGImage;
    [self.redPocketsRainView.layer addSublayer:self.moveLayer];
    [self addRainAnimation];
}
- (void)setupGiftBag
{
//    UIImageView * imageV = [UIImageView new];
//    imageV.image = [UIImage imageNamed:@"img_redbag"];
//    imageV.frame = CGRectMake(0, 0, 200 , 200 );
//    self.bagMoveLayer = [CALayer new];
//    self.bagMoveLayer.bounds = self.bagImageView.frame;
//    self.bagMoveLayer.anchorPoint = CGPointMake(0, 1);
//    self.bagMoveLayer.position = CGPointMake(-50, SCREEN_HEIGHT );
//    self.bagMoveLayer.contents = (id)self.bagImageView.image.CGImage;
//    [self.rainBackgroundView.layer addSublayer:self.bagMoveLayer];
    [self addGiftBagAnimation];
}
- (void)setupShowGiftBagButtonAnimation
{
    CGRect originButton = self.showCardsImageView.frame;
    originButton.origin.y = originButton.origin.y + 5;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        [self.showCardsImageView setFrame:originButton];
    } completion:nil];
}
- (void)addGiftBagAnimation
{
//    CAKeyframeAnimation * bagTranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    CATransform3D br0 = CATransform3DMakeRotation((-14) / 180.0 * M_PI, 0, 0, -1);
//    CATransform3D br1 = CATransform3DMakeRotation((0) / 180.0 * M_PI , 0, 0, -1);
//    bagTranAnimation.values = @[[NSValue valueWithCATransform3D:br0],[NSValue valueWithCATransform3D:br1]];
//    bagTranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    bagTranAnimation.duration = 1;
//    bagTranAnimation.repeatCount = NSIntegerMax;
//    bagTranAnimation.autoreverses = true;
//    //为了避免旋转动画完成后再次回到初始状态。
//    [bagTranAnimation setFillMode:kCAFillModeForwards];
//    [bagTranAnimation setRemovedOnCompletion:NO];
//    [self.bagMoveLayer addAnimation:bagTranAnimation forKey:@"bag"];
    [self.bagImageView setHidden:NO];
    CGRect originButton = self.bagImageView.frame;
    originButton.size.width = originButton.size.width + 10;
    originButton.size.height = originButton.size.height + 10;
    originButton.origin.x = originButton.origin.x + 5;
    originButton.origin.y = originButton.origin.y - 5;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        [self.bagImageView setFrame:originButton];
    } completion:nil];
}
- (void)addRainAnimation
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
    [self.bagImageView setHidden:YES];
    for (NSInteger i = 0; i < self.redPocketsRainView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        
        [layer removeAllAnimations];
    }
//    for (NSInteger i = 0; i < self.rainBackgroundView.layer.sublayers.count ; i ++)
//    {
//        CALayer * layer = self.rainBackgroundView.layer.sublayers[i];
//        if ([layer animationForKey:@"bag"])
//        {
            CGFloat scaleValue = 1.4;
//            [layer removeAnimationForKey:@"bag"];//红包福袋消失
//            [layer removeFromSuperlayer];
            CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * A = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT-SCREEN_WIDTH * (200.0/414.0))];
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2 - (SCREEN_WIDTH * (200.0/414.0) * scaleValue)/2 , SCREEN_HEIGHT * 0.65)];
            UIImageView * newPacketIV = [UIImageView new];
            newPacketIV.image = [UIImage imageNamed:@"img_yellowbag_game_popup"];
            newPacketIV.frame = CGRectMake(0, 0, SCREEN_WIDTH * (200.0/414.0) * scaleValue , SCREEN_WIDTH * (200.0/414.0) * scaleValue);
            moveAnimation.values = @[A,B];
            moveAnimation.duration = 0.3;
            moveAnimation.repeatCount = 0;
            moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [moveAnimation setFillMode:kCAFillModeForwards];
            [moveAnimation setRemovedOnCompletion:NO];
//            layer.contents = (id)newPacketIV.image.CGImage;
//            [layer addAnimation:moveAnimation forKey:@"bagFly"];// 红包福袋移动到中间上面
//            layer.transform = CATransform3DMakeScale(scaleValue, scaleValue, 1);// 红包福袋放大
            self.bagMoveLayer = [CALayer new];
            UIImageView * imageV = [UIImageView new];
            imageV.image = [UIImage imageNamed:@"img_redbag"];
            
            imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH * (200.0/414.0) , SCREEN_WIDTH * (200.0/414.0));
            self.bagMoveLayer.bounds = imageV.frame;
            self.bagMoveLayer.anchorPoint = CGPointMake(0, 1);
            self.bagMoveLayer.position = CGPointMake(-50, SCREEN_HEIGHT );
            self.bagMoveLayer.contents = (id)newPacketIV.image.CGImage;
            [self.bagMoveLayer addAnimation:moveAnimation forKey:@"bagFly"];// 红包福袋移动到中间上面
            self.bagMoveLayer.transform = CATransform3DMakeScale(scaleValue, scaleValue, 1);// 红包福袋放大
            [self.bagView.layer addSublayer:self.bagMoveLayer];
//        }
//    }
    [self showResult];
}

-(void)showResult
{
    [self.closeButton setHidden:NO];
    self.countdownLab.text = [NSString stringWithFormat:@"+%ld金币",(long)self.redPacketsResultCount];
    [self.showCardsButton setHidden:NO];
    [self.showCardsImageView setHidden:NO];
    [self setupShowGiftBagButtonAnimation];// 集幅卡按钮动画启动
    [self showOpenGiftBagButton];// 显示集幅卡按钮
    [self autoOpenGiftBagAction];// 自动打开红包袋
    // 背景图置换
    [UIView animateWithDuration:0.2 animations:^{
        [self.rainBackgroundImageView setImage:ImageNamed((@"bg_img1"))];
    }];
}
- (void)clickRed:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.redPocketsRainView];
    
    for (int i = 0 ; i < self.redPocketsRainView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        
        if ([[layer presentationLayer] hitTest:point] != nil &&
            self.selectedRedPacketNum != i &&
            ![layer isKindOfClass:[UILabel layerClass]] &&
            (layer.bounds.size.width == 44))
        {
            NSLog(@"%d",i);
            self.selectedRedPacketNum = i;
//            BOOL hasRedPacketd = !(i % 3) ;
            BOOL hasRedPacketd = YES ;
            UIImageView * newPacketIV = [UIImageView new];
//            if (hasRedPacketd)
//            {
                newPacketIV.image = [UIImage imageNamed:@"img_redenvelope_click"];
                newPacketIV.frame = CGRectMake(0, 0, 44 , 62.5);
//            }
//            else
//            {
//                newPacketIV.image = [UIImage imageNamed:@"dsb_rb_close"];
//                newPacketIV.frame = CGRectMake(0, 0, 45.5, 76.5);
//            }
            layer.contents = (id)newPacketIV.image.CGImage;
            [layer removeAnimationForKey:@"p"];
            CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue * A = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(self.width/5, self.height)];
            moveAnimation.values = @[A,B];
            moveAnimation.duration = 1.0;
            moveAnimation.repeatCount = 1;
            moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [moveAnimation setFillMode:kCAFillModeForwards];
            [moveAnimation setRemovedOnCompletion:NO];
            [layer addAnimation:moveAnimation forKey:@"p"];
//            UIView * alertView = [UIView new];
//            alertView.layer.cornerRadius = 5;
//            alertView.frame = CGRectMake(point.x - 50, point.y, 100, 30);
//            [self.redPocketsRainView addSubview:alertView];
//            UILabel * label = [UILabel new];
//            label.font = [UIFont systemFontOfSize:17];
            if (!hasRedPacketd)
            {
//                label.text = @"旺旺年！人旺旺";
//                label.textColor = [UIColor whiteColor];
            }
            else
            {
                self.redPacketsResultCount += 1;
//                NSString * string = [NSString stringWithFormat:@"+%d金币",1];
//                NSString * iString = [NSString stringWithFormat:@"%d",1];
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

- (void)setupDataForSortArray
{
    NSArray * tempArray = [[NSArray alloc] initWithObjects:@"恭喜111111会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜222222会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜3333333会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜44444444会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜55555555会员齐集福卡获得: 索尼PS5游戏机 国行光驱版", nil];
    [self sortArray:tempArray];
}
- (void)sortArray:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    NSInteger rowCount = 2.0;
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
            [self setBulletScreen:strArray positionY: (KIsiPhoneX ? 34 + 180 : 180) + i * 32.0];
        });
    }
}
- (void)setBulletScreen:(NSArray *)array positionY:(CGFloat)positionY {
    // 创建弹幕视图控件
    // 设置动画时间 animationDuration
    // 设置动画方向 animationDirection ex: QBulletScreenViewDirectionLeft
    UIImage * img = [PublicMethod createImageWithColor:COLOR_RGBA(0, 0, 0, 0.3)];
//    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    QBulletScreenView *bulletScreenView = [QBulletScreenView q_bulletScreenWithFrame:CGRectMake(0, positionY, 0, 23) texts:array color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:10] icon:nil direction:QBulletScreenViewDirectionLeft duration:5.0 target:self backgroundImg:img];
    [self.rainBackgroundView addSubview:bulletScreenView];
    [self.bulletViewsArr addObject:bulletScreenView];
    // 开始滚动
    [bulletScreenView q_startAnimation];
}
- (void)didClickContentAtIndex:(NSInteger)index
{
    
}


#pragma mark Timer
- (void)startTimeWithDuration:(int)timeValue
{
    weakSelf(weakSelf)
    __block int timeout = timeValue;
    NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
//    BOOL isBeforeDuration = [duractionArray[0] boolValue];
    BOOL isActivityDuration = [duractionArray[1] boolValue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf moveLabelToTop]; // 移动倒数LAbel到上面
//                [weakSelf.labelBackgroundView setAlpha:0.0];
                [weakSelf startRedPackerts]; // 开始下红包雨
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
- (void)moveLabelToTop
{
    // 移动
    self.countDownTitleLabel.text = @"倒计时";
    self.countDownTitleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mammonTop.constant += 50;
        self.countDownLabelTop.constant = 0.0;
        self.countDownLabelCenter.constant += 100;
        self.labelBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(CGRectGetMinY(self.labelBackgroundView.frame) - 50 + CGRectGetHeight(self.labelBackgroundView.frame)/4));
        self.labelBackgroundView.transform = self.labelBackgroundView.transform = CGAffineTransformScale(self.labelBackgroundView.transform, 0.50f, 0.50f);
        self.labelMaskView.transform =  CGAffineTransformMakeTranslation(0,  -CGRectGetHeight(self.labelMaskView.frame)/4);
        self.labelMaskView.transform = self.labelMaskView.transform = CGAffineTransformScale(self.labelMaskView.transform, 1.0f, 0.30f);
        [self.centerGiftBagImageView setAlpha:0.0];
        [self.centerGiftBagImageView setHidden:YES];
        // 加入Gif
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mammon2" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.mammonImageView.image = [UIImage sd_animatedGIFWithData:data];
    }];
}
- (void)moveLabelToCenter
{
    [self.centerGiftBagImageView setHidden:NO];
    self.countDownTitleLabel.text = @"红包雨倒计时:";
    self.countDownTitleLabel.font = [UIFont systemFontOfSize:17.0];
    [UIView animateWithDuration:0.3 animations:^{
        self.mammonTop.constant -= 50;
        self.countDownLabelTop.constant = 30.0;
        self.countDownLabelCenter.constant -= 100;
        self.labelBackgroundView.transform = CGAffineTransformIdentity;
        self.labelMaskView.transform = CGAffineTransformIdentity;
        [self.centerGiftBagImageView setAlpha:1.0];
        //财神图换回不会动的
        self.mammonImageView.image = ImageNamed(@"mammon1");
    }];
}
- (void)startRedPackerts
{
    // 集福卡隐藏
    [self.showCardsButton setHidden:YES];
    [self.showCardsImageView setHidden:YES];
    // 跑马灯关掉
    for (UIView * view in self.rainBackgroundView.subviews) {
        if ([view isKindOfClass:[QBulletScreenView class]])
        {
            [view removeFromSuperview];
        }
    }
    // 左下幅袋出现
    [self setupGiftBag];
    // 背景图置换
    [UIView animateWithDuration:0.2 animations:^{
        [self.rainBackgroundImageView setImage:ImageNamed((@"bg_img2"))];
    }];
    [self.redPocketsRainView addGestureRecognizer:self.tapGesture];
    float t = (arc4random() % 7) + 6;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/t) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    [self.timer fire];
    
    __block bool changeRedBagToGold = NO;
    //红包下落秒倒数
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
                [weakSelf endAnimation]; // 红包雨动画结束
            });
        }
        else
        {
            if (timeout > 0 && timeout <= (RedPacketCountDown/2))
            {
                if (changeRedBagToGold == NO)
                {
                    changeRedBagToGold = YES;
                    [weakSelf changeBagColor];
                }
            }
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countdownLab.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)changeBagColor
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bagImageView.layer removeAllAnimations];
        CGRect originFrame = self.bagImageView.frame;
        originFrame.size.width = SCREEN_WIDTH * (247.0/414.0);
        originFrame.size.height = SCREEN_WIDTH * (289.0/414.0);
        [self.bagImageView setFrame:originFrame];
//        [self.bagImageView setFrame:];
        CGRect newFrame = CGRectMake(self.bagImageView.origin.x, self.bagImageView.origin.y, SCREEN_WIDTH * (247.0/414.0) , SCREEN_WIDTH * (289.0/414.0) );
        newFrame.size.width += 20;
        newFrame.size.height += 20;
//        newFrame.origin.x += 30;
        newFrame.origin.y -= 10;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
            self.bagImageView.image = [UIImage imageNamed:@"img_yellowbag_game"];
            [self.bagImageView setFrame:newFrame];
//            UIImageView * imageV = [UIImageView new];
//            imageV.image = [UIImage imageNamed:@"img_yellowbag_game_popup"];
//            imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH * (247.0/414.0) , SCREEN_WIDTH * (289.0/414.0) );
////            imageV.frame = CGRectMake(0, 0, 247 , 289 );
//            self.bagMoveLayer.bounds = imageV.frame;
//            self.bagMoveLayer.contents = (id)imageV.image.CGImage;
        } completion:nil];
    });
}
- (void)showOpenGiftBagButton
{
    [self.bagView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bagView setAlpha:1.0];
        [self.labelBackgroundView setAlpha:0.0];
    }];
}
- (void)autoOpenGiftBagAction
{
    //红包袋开启倒数60秒
    self.autoOpenBagTimer = [NSTimer scheduledTimerWithTimeInterval:RedPacketCountDown target:self selector:@selector(showGiftBag) userInfo:nil repeats:NO];
}
- (void)showGiftBag
{
    [self openGiftBagAction];
}
#pragma mark IBAction
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
- (IBAction)openGiftBagAction{
    [self.autoOpenBagTimer invalidate];
    [self.closeGiftBagButton setHidden:NO];
    [self.openGiftBagButton setHidden:YES];
    [self.bagResultView setHidden:NO];
    [self.bagMoveLayer removeFromSuperlayer];
}
- (IBAction)closeGiftBagAction:(id)sender {
    [self.bagView setHidden:YES];
    [self.bagView setAlpha:0.0];
    [self.bagResultView setHidden:YES];
    [self.closeGiftBagButton setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.labelBackgroundView setAlpha:1.0];
    }];
    __block int timeout = [PublicMethod countDownIntervalWithDurationTag:YES];
//    [self configForRedPocketsView:RedPocketsViewBegin withDuration:timeout];
    [self startTimeWithDuration:timeout];
    [self setupDataForSortArray];
    [self moveLabelToCenter];
//    [self setupGiftBag];
//    [self.bagMoveLayer removeFromSuperlayer];
}

#pragma mark Lazy Load
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        [self.activityRuleView addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.activityRuleView.mas_centerX);
            make.centerY.mas_equalTo(self.activityRuleView.mas_centerY);
            make.height.equalTo(self.activityRuleView).multipliedBy((595.0/813.0));
            make.width.equalTo(self.activityRuleView).multipliedBy((340.0/414.0));
        }];
        bannerView.backgroundColor = [UIColor clearColor];
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
            make.top.mas_equalTo(self.backToRedPacketsViewBtn.mas_bottom).offset(10);
            make.height.equalTo(self.cardsBonusView).multipliedBy(0.28);
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
@end
