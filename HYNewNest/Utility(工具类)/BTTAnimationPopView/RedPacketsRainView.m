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
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "A03ActivityManager.h"
#import "RedPacketsRequest.h"
#import "RedPacketsIdentifyModel.h"
//#import "GradientImage.h"
#import "LuckyBagModel.h"
#import "GiftCardModel.h"
#import "PrizeRecordModel.h"
#import "PrizeNamesModel.h"
#import "FusingBlessingCardModel.h"
#import "NSString+Font.h"

@interface RedPacketsRainView()<SDCycleScrollViewDelegate , QBulletScreenViewDelegate>
// 按照页面顺序
@property (weak, nonatomic) IBOutlet UIView *cardsBonusView;
@property (weak, nonatomic) IBOutlet UIImageView *cardBonusImageView;
@property (weak, nonatomic) IBOutlet UIButton *backToRedPacketsViewBtn;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *activityRuleView;

@property (weak, nonatomic) IBOutlet UIView *rainBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *rainBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *labelMaskView;
@property (weak, nonatomic) IBOutlet UILabel *countDownTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownLabelCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mammonTop;
@property (weak, nonatomic) IBOutlet UIImageView *centerGiftBagImageView;
@property (weak, nonatomic) IBOutlet UIView *redPocketsRainView;
@property (weak, nonatomic) IBOutlet UIImageView *showCardsImageView;
@property (weak, nonatomic) IBOutlet UIButton *showCardsButton;
@property (weak, nonatomic) IBOutlet UIImageView *mammonImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yellowBagImageView;

@property (weak, nonatomic) IBOutlet UIView *bagView;
@property (weak, nonatomic) IBOutlet UIView *bagResultView;
@property (weak, nonatomic) IBOutlet UIButton *closeGiftBagButton;
@property (weak, nonatomic) IBOutlet UIButton *openGiftBagButton;

// 页面collectionArray
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *flyingRedPacketsArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tigerImageViewArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *cardsAmountLabelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *luckyBagResultArray;

// 普通参数
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *autoOpenBagTimer;
@property (nonatomic, strong) dispatch_source_t rainTimer;
@property (nonatomic, strong) CALayer *moveLayer;
@property (nonatomic, strong) CALayer *bagMoveLayer;
@property (nonatomic, assign) NSInteger selectedRedPacketNum;
@property (nonatomic, assign) RedPocketsViewStyle viewStyle;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) SDCycleScrollView *giftBannerView;
@property (nonatomic, strong) NSMutableArray *bulletViewsArr;
@property (nonatomic, assign) NSInteger fetchRedPacketsNum;
@property (nonatomic, strong) LuckyBagModel * luckyBagModel;
@property (nonatomic, strong) NSArray<GiftCardModel *>* giftCardArray;
@property (nonatomic, strong) NSArray<PrizeRecordModel *>* prizeRecordArray;
@property (nonatomic, strong) NSArray<PrizeNamesModel *>* prizeNamesArray;
@property (nonatomic, strong) FusingBlessingCardModel * fusingBlessingCardModel;
@property(nonatomic,strong)RedPacketsIdentifyModel * redPacketIdentifyModel;
//点了第一个红包
@property (nonatomic, assign) BOOL isSelectFirstRedPacket;

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
    self.giftCardArray = @[];
    self.prizeRecordArray = @[];
    self.prizeNamesArray = @[];
    self.countDownLabelTop.constant = SCREEN_HEIGHT * 0.05;
    self.isSelectFirstRedPacket = NO;
}

- (void)configForRedPocketsViewWithStyle:(RedPocketsViewStyle)style
{
    _viewStyle = style;
    weakSelf(weakSelf)
    [self goToCheckIdentifyWithCompletionBlock:^{
        [weakSelf setuprRuleImageBannerGroup];// 游戏规则资料
        [weakSelf setupCardsImageView];//设定集福卡页面背景渐层
        switch (weakSelf.viewStyle) {
            case RedPocketsViewBegin:// 活动开始
                weakSelf.selectedRedPacketNum = 0;
                //开始红包雨倒数
                if ([[[A03ActivityManager sharedInstance] redPacketInfoModel] isRainningTime])
                {
                    [weakSelf startTimeWithDuration:1];
                }else
                {
                    [weakSelf startTimeWithDuration:[PublicMethod countDownIntervalWithDurationTag:YES]];
                }
                // 活动开始中奖名单跑马灯
                [weakSelf fetchPrizeRecords];
                //            [self setupDataForSortArray];
                // 集福卡开启
                [weakSelf showCardsButtonSetHidden:NO];
                // 背景图置换
                [weakSelf changeBGImageViewWithStyle:RedPocketsViewBegin];
                // 中间福袋展现
                [weakSelf centerGiftBagAndFlyBagSetHidden:NO];
                break;
            case RedPocketsViewRainning:// 活动中
                weakSelf.selectedRedPacketNum = 0;
                //开始红包雨倒数
                [weakSelf startTimeWithDuration:1];
                // 活动开始中奖名单跑马灯
                [weakSelf fetchPrizeRecords];
                //            [self setupDataForSortArray];
                // 集福卡开启
                [weakSelf showCardsButtonSetHidden:NO];
                // 背景图置换
                [weakSelf changeBGImageViewWithStyle:RedPocketsViewBegin];
                // 中间福袋展现
                [weakSelf centerGiftBagAndFlyBagSetHidden:NO];
                break;
            case RedPocketsViewResult:// 活动结果
                break;
            case RedPocketsViewPrefix:// 活动预热
                [weakSelf.tapGesture setEnabled:NO];
                //开始红包雨倒数
                [weakSelf startTimeWithDuration:[PublicMethod countDownIntervalWithDurationTag:NO]];
                // 集福卡隐藏
                [weakSelf showCardsButtonSetHidden:YES];
                // 左下幅袋出现
                [weakSelf setupGiftBag];
                // 背景图置换
                [weakSelf changeBGImageViewWithStyle:RedPocketsViewPrefix];
                // 中间福袋隐藏
                [weakSelf centerGiftBagAndFlyBagSetHidden:YES];
                break;
            case RedPocketsViewDev:// 活动测试
                weakSelf.selectedRedPacketNum = 0;
                //开始红包雨倒数
                [weakSelf startTimeWithDuration:10];
                // 活动开始中奖名单跑马灯
                [weakSelf fetchPrizeRecords];
                //            [self setupDataForSortArray];
                // 集福卡开启
                [weakSelf showCardsButtonSetHidden:NO];
                // 背景图置换
                [weakSelf changeBGImageViewWithStyle:RedPocketsViewBegin];
                // 中间福袋展现
                [weakSelf centerGiftBagAndFlyBagSetHidden:NO];
                break;
            default:
                break;
        }
    }];
}
#pragma mark 初始化方法
- (void)setuprRuleImageBannerGroup
{
    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"popup1",@"popup2", nil];
    self.bannerView.imageURLStringsGroup = h5Images;
}
- (void)setupCardsImageView
{
    UIImage *myGradient = [UIColor gradientImageFromColors:@[kHexColor(0xFF724E), kHexColor(0xFFCC78)]
                                              gradientType:GradientTypeTopToBottom
                                                   imgSize:self.cardBonusImageView.frame.size];

    self.cardBonusImageView.image = myGradient;
//    [self.backToRedPacketsViewBtn setImage:[[UIImage imageNamed:@"navi_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [self.backToRedPacketsViewBtn setImage:[[UIImage imageNamed:@"navi_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
//    [self.backToRedPacketsViewBtn.imageView setTintColor:[UIColor whiteColor]];
}

- (void)rainningAction
{
    self.viewStyle = RedPocketsViewRainning;
    [self moveLabelToTop]; // 移动倒数LAbel到上面
    [self startRedPackerts]; // 开始下红包雨
    [self.tapGesture setEnabled:YES];
}

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
//                [weakSelf gotoGetIdentify];
                [weakSelf rainningAction];
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
//            NSString * dayString = (dInt == 0 ? @"" : [NSString stringWithFormat:@"%d天",dInt]);
//            NSString * hourString = ((hInt == 0 && dInt == 0) ? @"" : [NSString stringWithFormat:@"%d小时",hInt]);
//            NSString * minString = ((mInt == 0 && hInt == 0 && dInt == 0) ? @"" : [NSString stringWithFormat:@"%d分",mInt]);
            NSString * dayString = [NSString stringWithFormat:@"%d天",dInt];
            NSString * hourString = [NSString stringWithFormat:@"%d小时",hInt];
            NSString * minString = [NSString stringWithFormat:@"%d分",mInt];

            if (isActivityDuration)
            {
                titleStr = [NSString stringWithFormat:@"%@%@%d秒",
                            hourString
                            ,minString
                            ,sInt];
            }else
            {
                titleStr = [NSString stringWithFormat:@"%@%@%@%d秒",
                            dayString
                            ,hourString
                            ,minString
                            ,sInt];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countdownLab.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setupDataForSortArray
{
    if (self.viewStyle != RedPocketsViewRainning)
    {
        NSMutableArray * totalArray = [[NSMutableArray alloc] init];
        for (PrizeRecordModel * subModel in self.prizeRecordArray) {
            [totalArray addObject:[NSString stringWithFormat:@"恭喜%@会员齐集福卡获得: %@",subModel.loginName,subModel.prizeName]];
        }
        //    NSArray * tempArray = [[NSArray alloc] initWithObjects:@"恭喜111111会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜222222会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜3333333会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜44444444会员齐集福卡获得: 索尼PS5游戏机 国行光驱版",@"恭喜55555555会员齐集福卡获得: 索尼PS5游戏机 国行光驱版", nil];
        [self sortArray:totalArray];
    }
}
- (void)setupGiftBannerGroup
{
//    NSMutableArray *h5Images = [[NSMutableArray alloc] initWithObjects:@"img_401as",
//                                @"img_dysonV10",
//                                @"img_GalaxyZFold3",
//                                @"img_HZC302W",
//                                @"img_MacBook13",
//                                @"img_PS5",
//                                @"img_SKG",
//                                @"img_sonya7m4", nil];
//    NSArray * nameArray = @[@[@"g****18",@"g****9",@"g****86",@"g****81",@"g****88",@"g****81"],@[@"g****28",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****38",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****48",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****58",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****68",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****78",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"],@[@"g****88",@"g****88",@"g****86",@"g****87",@"g****81",@"g****81"]];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *userNamesArray = [[NSMutableArray alloc] init];
    for (PrizeNamesModel * subModel in self.prizeNamesArray) {
        if ([subModel.prizeName containsString:@"海尔除螨仪"])
        {
            [imageArray addObject:@"img_HZC302W"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"SKG颈部"])
        {
            [imageArray addObject:@"img_SKG"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"奥玛仕"])
        {
            [imageArray addObject:@"img_401as"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"戴森吸"])
        {
            [imageArray addObject:@"img_dysonV10"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"PS5"])
        {
            [imageArray addObject:@"img_PS5"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"苹果"])
        {
            [imageArray addObject:@"img_MacBook13"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"三星"])
        {
            [imageArray addObject:@"img_GalaxyZFold3"];
            [userNamesArray addObject:subModel.users];
        }
        if ([subModel.prizeName containsString:@"a7m4"])
        {
            [imageArray addObject:@"img_sonya7m4"];
            [userNamesArray addObject:subModel.users];
        }
    }

    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    for (NSArray * subNameArray in userNamesArray) {
        NSString *totalString = @"";
        for (int i = 0 ; i < subNameArray.count ; i++) {
            totalString = [totalString stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",(i == 0 ? @"恭喜\n":@""),subNameArray[i],(i == (subNameArray.count - 1) ? @"\n会员获得该奖品" : @"、")]];
        }
        [descriptionArray addObject:totalString];
    }
//    h5Images = @[].mutableCopy;
//    descriptionArray = @[].mutableCopy;
    self.giftBannerView.localizationImageNamesGroup = imageArray.mutableCopy;
    self.giftBannerView.descriptionGroup = descriptionArray;
}
- (void)showCardsButtonSetHidden:(BOOL)sender
{
    [self.showCardsButton setHidden:sender];
    [self.showCardsImageView setHidden:sender];
    if (sender == NO)
    {
        [self setupShowCardsButtonAnimation];// 集幅卡按钮动画启动
    }
}
- (void)changeBGImageViewWithStyle:(RedPocketsViewStyle)currentStyle
{
        for (UIImageView * imageView in self.tigerImageViewArray) {
            switch (currentStyle) {
                case RedPocketsViewRainning:
                case RedPocketsViewPrefix:
                {
                    if (imageView.tag == 1)
                    {
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [imageView setAlpha:0.0];
                        } completion:^(BOOL finished) {
                            [imageView setHidden:YES];
                        }];
                    }else
                    {
                        [imageView setHidden:NO];
                        [UIView animateWithDuration:0.2 animations:^{
                            [imageView setAlpha:1.0];
                        }];
                    }
                }
                    break;
                    
                default:
                {
                    if (imageView.tag == 1)
                    {
                        [imageView setHidden:NO];
                        [UIView animateWithDuration:0.2 animations:^{
                            [imageView setAlpha:1.0];
                        }];
                    }else
                    {
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [imageView setAlpha:0.0];
                        } completion:^(BOOL finished) {
                            [imageView setHidden:YES];
                        }];
                    }
                }
                    break;
            }
    
        }
}
-(void)centerGiftBagAndFlyBagSetHidden:(BOOL)sender
{
    [self.centerGiftBagImageView setHidden:sender];
    for (UIImageView * imageView in self.flyingRedPacketsArray) {
        [imageView setHidden:!sender];
    }
}
- (void)setupCardsAmounts
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray * resultArray = [[NSMutableArray alloc] initWithObjects:@"0张",@"0张",@"0张",@"0张",@"0张",@"0张", nil];
        for (int i = 0; i < self.giftCardArray.count; i ++) {
            GiftCardModel *subModel = self.giftCardArray[i];
            if ([subModel.cardName isEqualToString:@"龙腾虎跃"])
            {
                [resultArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.cardName isEqualToString:@"藏龙卧虎"])
            {
                [resultArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.cardName isEqualToString:@"人中龙虎"])
            {
                [resultArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.cardName isEqualToString:@"如虎生翼"])
            {
                [resultArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.cardName isEqualToString:@"生龙活虎"])
            {
                [resultArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.cardName isEqualToString:@"虎虎生威"])
            {
                [resultArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
        }
        for (int i = 0; i < self.cardsAmountLabelArray.count; i++) {
            UILabel * cardAmountLabel = self.cardsAmountLabelArray[i];
            cardAmountLabel.text = resultArray[i];
        }
    });
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
    [self.bagImageView setHidden:NO];
    [self.yellowBagImageView setHidden:YES];
}
- (void)setupShowCardsButtonAnimation
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

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bagImageView.layer removeAllAnimations];
        [self.yellowBagImageView.layer removeAllAnimations];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.bagImageView setAlpha:1.0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                self.bagImageView.transform =  CGAffineTransformMakeTranslation(5,  -5);
                self.bagImageView.transform = self.bagImageView.transform = CGAffineTransformScale(self.bagImageView.transform, 1.1f, 1.1f);
            } completion:nil];
        }];
    });
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
    self.viewStyle = RedPocketsViewBegin;
    [self.timer invalidate];
    [self.tapGesture setEnabled:NO];
    [self.bagImageView setHidden:YES];
    [self.yellowBagImageView setHidden:YES];
    [self.bagImageView setAlpha:0.0];
    [self.yellowBagImageView setAlpha:0.0];
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
            
            imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH * (200.0/414.0) , SCREEN_WIDTH * (234.0/414.0));
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
    NSString *identifyString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketIdentify];
    NSString *numString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketNum];
    if (KIsEmptyString(identifyString) || KIsEmptyString(numString))
    {
        [MBProgressHUD showSuccess:@"谢谢参与" toView:self];
        [self.autoOpenBagTimer invalidate];
        [self closeGiftBagAction:nil];
    }else
    {
        [self showOpenGiftBagButton];// 显示集幅卡按钮
        [self autoOpenGiftBagAction];// 自动打开红包袋
    }
    // 集福卡开启
    [self showCardsButtonSetHidden:NO];
    // 背景图置换
    [self changeBGImageViewWithStyle:RedPocketsViewResult];
}
- (void)clickRed:(UITapGestureRecognizer *)sender
{
    if (self.isSelectFirstRedPacket == NO)
    {
        self.isSelectFirstRedPacket = YES;
        NSString *identifyString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketIdentify];
        if (KIsEmptyString(identifyString))
        {
            [self gotoGetIdentify];
        }
    }
    CGPoint point = [sender locationInView:self.redPocketsRainView];
    
    for (int i = 0 ; i < self.redPocketsRainView.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.redPocketsRainView.layer.sublayers[i];
        
        if ([[layer presentationLayer] hitTest:point] != nil &&
            self.selectedRedPacketNum != i &&
            ![layer isKindOfClass:[UILabel layerClass]] &&
            (layer.bounds.size.width == 44))
        {
            self.fetchRedPacketsNum += 1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",self.fetchRedPacketsNum] forKey:RedPacketNum];
            [[NSUserDefaults standardUserDefaults] synchronize];
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
            NSValue * B = [NSValue valueWithCGPoint:CGPointMake(self.width*0.1, self.height*0.9)];
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

- (void)sortArray:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    NSInteger rowCount = 2.0;
    if (array.count < 2)
    {
        rowCount = array.count;
    }
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
        self.countDownLabelTop.constant = SCREEN_HEIGHT * 0.05;
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
    // 红包重置
    self.fetchRedPacketsNum = 0;
    // 跑马灯关掉
    for (UIView * view in self.rainBackgroundView.subviews) {
        if ([view isKindOfClass:[QBulletScreenView class]])
        {
            [view removeFromSuperview];
        }
    }
    // 左下福袋出现
    [self setupGiftBag];
    // 左下福袋动画启动
    [self addGiftBagAnimation];
    // 背景图置换
    [self changeBGImageViewWithStyle:RedPocketsViewRainning];
    // 集福卡隐藏
    [self showCardsButtonSetHidden:YES];
    [self.redPocketsRainView addGestureRecognizer:self.tapGesture];
//    float t = (arc4random() % 7) + 6;
    float t = 13;
    if ([CNUserManager shareManager].userDetail.starLevel <= 2)
    {
        t = 13;// 1-2星级
    }else if(([CNUserManager shareManager].userDetail.starLevel == 3) ||
           ([CNUserManager shareManager].userDetail.starLevel == 4) ||
           ([CNUserManager shareManager].userDetail.starLevel == 7))
    {
        t = 15;// 347星级
    }else
    {
        t = 16;// 5-6星级
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/t) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    [self.timer fire];
    
    __block bool changeRedBagToGold = NO;
    //红包下落秒倒数
    weakSelf(weakSelf)
    __block int timeout = RedPacketCountDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _rainTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.rainTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.rainTimer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(weakSelf.rainTimer);
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
    dispatch_resume(_rainTimer);
}
- (void)changeBagColor
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.yellowBagImageView.layer removeAllAnimations];
        [self.yellowBagImageView setHidden:NO];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.bagImageView setAlpha:0.0];
            [self.yellowBagImageView setAlpha:1.0];
        } completion:^(BOOL finished) {
            [self.bagImageView.layer removeAllAnimations];
            [self.bagImageView setHidden:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                    self.yellowBagImageView.transform =  CGAffineTransformMakeTranslation(5,  5);
                    self.yellowBagImageView.transform = self.yellowBagImageView.transform = CGAffineTransformScale(self.yellowBagImageView.transform, 1.2f, 1.2f);
                } completion:nil];
            });
        }];

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
    self.autoOpenBagTimer = [NSTimer scheduledTimerWithTimeInterval:RedPacketCountDown target:self selector:@selector(fetchOpenLuckyBagData) userInfo:nil repeats:NO];

}
- (void)goToCheckIdentifyWithCompletionBlock:(void(^)(void))completionBlock
{
    WEAKSELF_DEFINE
    if ([[[[A03ActivityManager sharedInstance] redPacketInfoModel] firstRainStatus] isEqualToString:@"1"] ||
        [[[[A03ActivityManager sharedInstance] redPacketInfoModel] secondRainStatus] isEqualToString:@"1"])
    {
        completionBlock();
    }else
    {
        // 如果有存在cache
        [self goToOpenBagWithCompletionBlock:^(id responseObj, NSString *errorMsg) {
            [weakSelf setDataNil];
            [MBProgressHUD hideHUDForView:self animated:YES];
            completionBlock();
        }];
    }
}
- (void)fetchOpenLuckyBagData
{
    WEAKSELF_DEFINE
    [self goToOpenBagWithCompletionBlock:^(id responseObj, NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (RedPacketIsDev == YES)
        {
            weakSelf.luckyBagModel = [LuckyBagModel new];
            weakSelf.luckyBagModel.data = @[[LuckyBagDetailModel new]];
            [weakSelf setDataNil];
            [weakSelf.autoOpenBagTimer invalidate];
            [weakSelf showBagWithData];
        }else
        {
            if (!errorMsg) {
                weakSelf.luckyBagModel = [LuckyBagModel cn_parse:responseObj];
                weakSelf.luckyBagModel.data = [LuckyBagDetailModel cn_parse:responseObj[@"data"]];
                NSString *codeString = weakSelf.luckyBagModel.code;
                NSString *messageString = weakSelf.luckyBagModel.message;
                if ([codeString isEqual:@"200"])
                {
                    [weakSelf setDataNil];
                    [weakSelf.autoOpenBagTimer invalidate];
                    [weakSelf showBagWithData];
                }else
                {
                    [MBProgressHUD showError:messageString toView:self];
                    [weakSelf setDataNil];
                    [weakSelf.autoOpenBagTimer invalidate];
                    [weakSelf closeGiftBagAction:nil];
                }
            }
        }
    }];
}
- (void)goToOpenBagWithCompletionBlock:(HandlerBlock)completionBlock
{
    NSString *identifyString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketIdentify];
    NSString *numString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketNum];
    if (KIsEmptyString(identifyString) || KIsEmptyString(numString))
    {
        // 可能是第一次参与活动
        completionBlock(nil,nil);
    }else
    {
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"identify"] = identifyString;
        params[@"times"] = numString;
        [self fetchOpenBagDataWithParameters:params WithBlock:^(id responseObj, NSString *errorMsg) {
            completionBlock(responseObj,errorMsg);
        }];
    }
}

- (void)showBagWithData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.luckyBagResultArray.count; i++) {
            UILabel *subLabel = self.luckyBagResultArray[i];
            subLabel.text = self.luckyBagModel.amountData[i];
        }
    });
    [self.autoOpenBagTimer invalidate];
    [self.closeGiftBagButton setHidden:NO];
    [self.openGiftBagButton setHidden:YES];
    [self.bagResultView setHidden:NO];
    [self.bagMoveLayer removeFromSuperlayer];
}
- (BOOL)checkCardsCombineAvailable
{
    return YES;
}
- (void)showGiftViewWithData:(NSString*)imageData
{
    NSString *imageString = @"";
    if ([imageData containsString:@"海尔除螨仪"])
    {
        imageString = @"popup_price6";
    }
    if ([imageData containsString:@"SKG颈部"])
    {
        imageString = @"popup_price2";
    }
    if ([imageData containsString:@"奥玛仕"])
    {
        imageString = @"popup_price4";
    }
    if ([imageData containsString:@"戴森吸"])
    {
        imageString = @"popup_price3";
    }
    if ([imageData containsString:@"PS5"])
    {
        imageString = @"popup_price5";
    }
    if ([imageData containsString:@"苹果"])
    {
        imageString = @"popup_price1";
    }
    if ([imageData containsString:@"三星"])
    {
        imageString = @"popup_price7";
    }
    if ([imageData containsString:@"a7m4"])
    {
        imageString = @"popup_price8";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.giftImageView.image = ImageNamed(imageString);
        [self.cardsBonusView bringSubviewToFront:self.giftView];
        [self.giftView setHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.giftView setAlpha:1.0];
        }];
        self.giftTitleLabel.text = [NSString stringWithFormat:@"抽中 %@",imageData];
    });

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
    [MBProgressHUD showLoadingSingleInView:self animated:YES];
    WEAKSELF_DEFINE
    [self fetchCombineDatasForFusingWithComplete:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.cardsBonusView setAlpha:(sender.tag == 1) ? 1.0 : 0.0];
                [weakSelf.rainBackgroundView setAlpha:(sender.tag == 1) ? 0.0 : 1.0];
                [weakSelf.labelBackgroundView setAlpha:(sender.tag == 1) ? 0.0 : 1.0];
                [weakSelf dismissRulesView];
            }];
        });
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
- (void)fetchCombineDatasForFusingWithComplete:(nullable void(^)(void))complete
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("fetchDatas", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    [self fetchBlessingCardData:group];
    dispatch_group_enter(group);
    [self fetchGroupPrizeNameData:group];
    dispatch_group_notify(group,queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete)
            {
                complete();
            }
        });
    });
}
- (IBAction)openGiftBagAction{
    [self fetchOpenLuckyBagData];
}
- (IBAction)closeGiftBagAction:(nullable id)sender {
    [self.bagView setHidden:YES];
    [self.bagView setAlpha:0.0];
    [self.bagResultView setHidden:YES];
    [self.closeGiftBagButton setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.labelBackgroundView setAlpha:1.0];
    }];
    weakSelf(weakSelf)
    [[A03ActivityManager sharedInstance] checkTimeRedPacketRainWithCompletion:^(NSString * _Nullable response, NSString * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int timeout = [PublicMethod countDownIntervalWithDurationTag:YES];
            [weakSelf startTimeWithDuration:timeout];
        });
    } WithDefaultCompletion:nil];
    [self fetchPrizeRecords];
    [self moveLabelToCenter];
}
- (IBAction)combineCardsAction:(id)sender {
    [self fetchFusingData];
}
- (IBAction)dismissGiftView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.giftView setAlpha:0.0];
    }completion:^(BOOL finished) {
        [self.giftView setHidden:YES];
    }];
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
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        bannerView.pageControlDotSize = CGSizeMake(6, 6);
//        bannerView.autoScrollTimeInterval = 0;
        bannerView.autoScroll = false;
        _bannerView = bannerView;
    }
    return _bannerView;
}
- (SDCycleScrollView *)giftBannerView {
    if (!_giftBannerView) {
        SDCycleScrollView *giftBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"bgimg_noprice_withtext"]];
        [self.cardsBonusView addSubview:giftBannerView];
        [giftBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.cardsBonusView);
            make.top.mas_equalTo(self.backToRedPacketsViewBtn.mas_bottom).offset(10);
            make.height.equalTo(self.cardsBonusView).multipliedBy(220.0/813.0);
        }];
        giftBannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        giftBannerView.layer.cornerRadius = 10;
        giftBannerView.layer.masksToBounds = true;
        giftBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        giftBannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        giftBannerView.pageControlDotSize = CGSizeMake(6, 6);
//        bannerView.autoScrollTimeInterval = 0;
        giftBannerView.autoScroll = false;
        _giftBannerView = giftBannerView;
    }
    return _giftBannerView;
}
- (void)setDataNil
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RedPacketIdentify];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:RedPacketNum];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark Fetch Data
- (void)fetchPrizeRecords
{
    WEAKSELF_DEFINE
    [RedPacketsRequest getRainInKindPrizeTask:^(id responseObj, NSString *errorMsg) {
        weakSelf.prizeRecordArray = [PrizeRecordModel cn_parse:responseObj];
        [weakSelf setupDataForSortArray];
    }];
}
- (void)gotoGetIdentify
{
    WEAKSELF_DEFINE
    [RedPacketsRequest getRainIdentifyTask:^(id responseObj, NSString *errorMsg) {
        weakSelf.redPacketIdentifyModel = [RedPacketsIdentifyModel cn_parse:responseObj];
        NSString *codeString = weakSelf.redPacketIdentifyModel.code;
        if ([codeString isEqual:@"200"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.redPacketIdentifyModel.identify forKey:RedPacketIdentify];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else
        {
            if (RedPacketIsDev == YES)
            {
                //测试用
                [[NSUserDefaults standardUserDefaults] setObject:@"asdnsmcls" forKey:RedPacketIdentify];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [MBProgressHUD showError:@"您暂有抽红包机会" toView:self];
            }else
            {
                // 不成功
                [MBProgressHUD showError:@"您暂无抽红包机会" toView:self];
            }
        }
    }];
}
- (void)fetchOpenBagDataWithParameters:(NSMutableDictionary *)params WithBlock:(HandlerBlock)completionBlock
{
    [MBProgressHUD showLoadingSingleInView:self animated:YES];
    [RedPacketsRequest getRainOpenTask:^(id responseObj, NSString *errorMsg) {
        completionBlock(responseObj,errorMsg);
    }];
}
- (void)fetchGroupPrizeNameData:(dispatch_group_t)group
{
    WEAKSELF_DEFINE
    [RedPacketsRequest getRainGroupTask:^(id responseObj, NSString *errorMsg) {
        weakSelf.prizeNamesArray = [PrizeNamesModel cn_parse:responseObj];
        [weakSelf setupGiftBannerGroup];
    }];
    dispatch_group_leave(group);
}
- (void)fetchBlessingCardData:(dispatch_group_t)group
{
    WEAKSELF_DEFINE
    [RedPacketsRequest getRainQueryTask:^(id responseObj, NSString *errorMsg) {
        weakSelf.giftCardArray = [GiftCardModel cn_parse:responseObj];
        [weakSelf setupCardsAmounts];
    }];
    dispatch_group_leave(group);
}
- (void)fetchFusingData
{
    if (RedPacketIsDev == YES)
    {
        [self fetchCombineDatasForFusingWithComplete:nil];
        [self showGiftViewWithData:@"苹果MacBook13英寸M1芯片256G"];
    }else
    {
        [MBProgressHUD showLoadingSingleInView:self animated:YES];
        WEAKSELF_DEFINE
        [RedPacketsRequest getRainFusingTask:^(id responseObj, NSString *errorMsg) {
            [MBProgressHUD hideHUDForView:self animated:NO];
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]])
            {
                NSString *codeString = responseObj[@"code"];
                NSString *messageString = responseObj[@"message"];
                if ([codeString isEqual:@"200"])
                {
                    weakSelf.fusingBlessingCardModel = [FusingBlessingCardModel cn_parse:responseObj[@"data"]];
                    [weakSelf fetchCombineDatasForFusingWithComplete:nil];
                    [weakSelf showGiftViewWithData:weakSelf.fusingBlessingCardModel.prizeName];
                }else
                {
                    [MBProgressHUD showError:messageString toView:self];
                }
            }
        }];
    }
}
- (void)didMoveToWindow
{
    if (self.autoOpenBagTimer)
    {
        [self.autoOpenBagTimer invalidate];
    }
    if (self.rainTimer)
    {
        dispatch_source_cancel(self.rainTimer);
    }
}
@end
