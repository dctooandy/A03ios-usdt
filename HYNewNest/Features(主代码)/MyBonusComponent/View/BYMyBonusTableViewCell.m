//
//  BYMyBonusTableViewCell.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBonusTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"
#import "BYMyBonusRequest.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIColor+Gradient.h"
#import "NSNumber+JKRound.h"
@interface BYMyBonusTableViewCell()
typedef void (^ServerTimeCompleteBlock)(NSString * timeStr);
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
//@property (weak, nonatomic) IBOutlet UIView *btmBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
@property (weak, nonatomic) IBOutlet UILabel *countDownTimerLabel;
@property (nonatomic, strong) dispatch_source_t fetchBonusTimer;      //领红包倒数计时器
@property (weak, nonatomic) IBOutlet UIView *countDownBGImageView;
@property (weak, nonatomic) IBOutlet UILabel *gradientLabel;

@end
@implementation BYMyBonusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = KColorRGB(16, 16, 28);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topImgView.backgroundColor = kHexColor(0x1F1F37);
//    self.btmBgView.backgroundColor = kHexColor(0x1F1F37);

}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *topPath = [UIBezierPath bezierPathWithRoundedRect:self.topImgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *topMask = [CAShapeLayer layer];
        topMask.path = topPath.CGPath;
        self.topImgView.layer.mask = topMask;
        // 现金红包Label
//        CGFloat labelHeight =  CGRectGetHeight(self.gradientLabel.frame);
//        CGFloat labelWidth =  CGRectGetWidth(self.gradientLabel.frame);
//        self.gradientLabel.textColor = [UIColor colorWithPatternImage:[UIColor gradientImageFromColors:@[kHexColor(0x00CFFF), kHexColor(0x2390E9)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(labelWidth,labelHeight )]];
        // 倒数计时背景
//        CGFloat imgHeight =  CGRectGetHeight(self.countDownBGImageView.frame);
//        CGFloat imgWidth =  CGRectGetWidth(self.countDownBGImageView.frame);
//        self.countDownBGImageView.backgroundColor = [UIColor gradientFromColor:kHexColor(0x4052A1) toColor:[UIColor clearColor] withWidth:imgWidth];
//        self.countDownBGImageView.layer.cornerRadius = imgHeight/2.0;
//        self.countDownBGImageView.layer.masksToBounds = YES;
        // 按钮
        CGFloat btnHeight =  CGRectGetHeight(self.actionButton.frame);
        CGFloat btnWidth =  CGRectGetWidth(self.actionButton.frame);
        if (([self.model.status isEqualToString:@"1"] || [self.model.status isEqualToString:@"4"]))
        {
            self.actionButton.backgroundColor = [UIColor gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withWidth:btnWidth];
        }else
        {
            self.actionButton.backgroundColor = kHexColor(0x999999);
        }
        self.actionButton.layer.cornerRadius = btnHeight/2.0;
        self.actionButton.layer.masksToBounds = YES;

//        UIBezierPath *btmPath = [UIBezierPath bezierPathWithRoundedRect:self.btmBgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *btmMask = [CAShapeLayer layer];
//        btmMask.path = btmPath.CGPath;
//        self.btmBgView.layer.mask = btmMask;
    });
}
- (void)setModel:(BYMyBounsModel *)model {
    _model = model;
    
//    [self.topImgView sd_setImageWithURL:[NSURL getUrlWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"banner--sport-2"]];
    self.lblEndDate.text = [NSString stringWithFormat:@"有效期:%@至%@",model.shortCreatedDate,model.shortMaturityDate];
    
//    NSNumber *amountNumber = [NSNumber numberWithInt:[model.amount intValue]];
//    self.amountLabel.text = [amountNumber jk_toDisplayNumberWithDigit:0];
    self.amountLabel.text = model.amount;
    NSString *betAmountString = model.betAmount;
    NSString *refAmountString = model.refAmount;
    NSString *currencyString = ([model.currency isEqualToString:@"CNY"]) ? @"元" : model.currency;
    //    if ([model.promotionName containsString:@"存送"])
        if ([model.promotionType containsString:@"YHQCS"])
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内充值满%@%@再领取红包,%@流水取款,逾期作废",refAmountString,currencyString,betAmountString];
        [self.topImgView setImage:[UIImage imageNamed:@"depositBG"]];
        self.currencyImageView.image = ImageNamed(([model.currency containsString:@"CNY"] ? @"icon_¥-2":@"icon_USDT-2"));
        [self.amountLabel setTextColor:[UIColor jk_colorWithHex:0x10B4DD]];
        [self.gradientLabel setTextColor:[UIColor jk_colorWithHex:0x2390E9]];
    }else
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内领取红包,%@流水取款,逾期作废",betAmountString];
        [self.topImgView setImage:[UIImage imageNamed:@"derictToGiftBG"]];
        self.currencyImageView.image = ImageNamed(([model.currency containsString:@"CNY"] ? @"icon_¥-1":@"icon_USDT-1"));
        [self.amountLabel setTextColor:[UIColor jk_colorWithHex:0xD95274]];
        [self.gradientLabel setTextColor:[UIColor jk_colorWithHex:0xA12830]];
    }
    //测试用
//    model.status = @"3";
    if ([model.status isEqualToString:@"1"])
    {
        [self.actionButton setTitle:@"立即领取" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"2"])
    {
        [self.actionButton setTitle:@"已领取" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"3"])
    {
        [self.actionButton setTitle:@"已过期" forState:UIControlStateNormal];
    }else
    {
        [self.actionButton setTitle:@"前往充值" forState:UIControlStateNormal];
    }
    [self setDateStringWithFlag:([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"4"])];
}
-(void)loadServerTime:(ServerTimeCompleteBlock)completeBlock {
    
    [BYMyBonusRequest fetchServerTimeHandler:^(id responseObj, NSString *errorMsg) {
        
        if (!errorMsg ) {
//            NSNumber *serverTime = [NSNumber numberWithLong:(long)responseObj];
            NSString *timeString = [NSString stringWithFormat:@"%@",responseObj];
            completeBlock(timeString);
        }
    }];
}

- (void)setDateStringWithFlag:(BOOL)isShow
{
    if (isShow == YES)
    {
        [self.countDownBGImageView setHidden:NO];
        NSDate *createDate = [NSDate jk_dateWithString:self.model.createdDate format:@"yyyy-MM-dd HH:mm:ss"];
        //    NSTimeInterval firstSec = [createDate timeIntervalSinceNow];
        NSDate *nowDate = [NSDate now];
        NSDate *maturityDate = [NSDate jk_dateWithString:self.model.maturityDate format:@"yyyy-MM-dd HH:mm:ss"];
        //    NSTimeInterval finalSec = [maturityDate timeIntervalSinceNow];
        NSTimeInterval diff = [maturityDate timeIntervalSinceDate:nowDate];
        // 测试
        //    diff = 5;
        if (_fetchBonusTimer) dispatch_source_cancel(_fetchBonusTimer);
        [self startTimeWithDuration:diff];
        
//        [self loadServerTime:^(NSString * _Nonnull timeStr) {
//            // The time interval
//            NSTimeInterval theTimeInterval = [timeStr intValue];
//            
//            // Create the NSDates
//            NSDate *date1 = [[NSDate alloc] init];
//            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
//            
//            //        NSDate *setverDate = [NSDate jk_dateWithString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
//            NSTimeInterval newDiff = [maturityDate timeIntervalSinceDate:date2];
//            
//        }];
    }else
    {
        [self.countDownBGImageView setHidden:YES];
    }
}
// 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = kHexColor(0x333333);
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = KColorRGB(16, 16, 28);
        } completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapMoreAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"前往充值"])
    {
        if (self.goDepositAction)
        {
            self.goDepositAction();
        }
    }else if ([sender.titleLabel.text isEqualToString:@"立即领取"])
    {
        if (self.goFetchAction)
        {
            self.goFetchAction(_model.requestId);
        }
    }
}
// 制作倒数文字
- (void)startTimeWithDuration:(int)timeValue
{
    WEAKSELF_DEFINE
    __block int timeout = timeValue;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _fetchBonusTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_fetchBonusTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_fetchBonusTimer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(weakSelf.fetchBonusTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.goRefreshBegin)
                {
                    weakSelf.goRefreshBegin();
                }
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
            NSString * dayString = [NSString stringWithFormat:@"%d天",dInt];
            NSString * hourString = [NSString stringWithFormat:@"%d时",hInt];
            NSString * minString = [NSString stringWithFormat:@"%d分",mInt];
            titleStr = [NSString stringWithFormat:@"%@%@%@%d秒",
                        dayString
                        ,hourString
                        ,minString
                        ,sInt];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countDownTimerLabel.text = [NSString stringWithFormat:@"剩馀时间:%@",titleStr];
            });
            timeout--;
        }
    });
    dispatch_resume(_fetchBonusTimer);
}

@end
