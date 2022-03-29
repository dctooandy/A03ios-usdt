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

@interface BYMyBonusTableViewCell()
typedef void (^ServerTimeCompleteBlock)(NSString * timeStr);
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
//@property (weak, nonatomic) IBOutlet UIView *btmBgView;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownTimerLabel;
@property (nonatomic, strong) dispatch_source_t fetchBonusTimer;      //领红包倒数计时器
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
        
//        UIBezierPath *btmPath = [UIBezierPath bezierPathWithRoundedRect:self.btmBgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *btmMask = [CAShapeLayer layer];
//        btmMask.path = btmPath.CGPath;
//        self.btmBgView.layer.mask = btmMask;
    });
}
- (void)setModel:(BYMyBounsModel *)model {
    _model = model;
    
    [self.topImgView sd_setImageWithURL:[NSURL getUrlWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"banner--sport-2"]];
    self.lblEndDate.text = [NSString stringWithFormat:@"有效期:%@至%@",model.shortCreatedDate,model.shortMaturityDate];
    
    self.currencyLabel.text = model.currency;
    self.amountLabel.text = model.amount;
    NSString *betAmountString = model.betAmount;
    if ([model.promotionName containsString:@"存送"])
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内充值满%@%@再领取红包,%@倍流水取款,逾期作废",betAmountString,model.currency,betAmountString];
    }else
    {
        self.messageLabel.text = [NSString stringWithFormat:@"请在有效期内领取红包,%@倍流水取款,逾期作废",betAmountString];
    }
    //测试用
//    model.status = @"4";
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
    [self setDateString];
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
- (void)setDateString
{
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
    
    [self loadServerTime:^(NSString * _Nonnull timeStr) {
        // The time interval
        NSTimeInterval theTimeInterval = [timeStr intValue];

        // Create the NSDates
        NSDate *date1 = [[NSDate alloc] init];
        NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];

//        NSDate *setverDate = [NSDate jk_dateWithString:timeStr format:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval newDiff = [maturityDate timeIntervalSinceDate:date2];
        
    }];
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
                weakSelf.countDownTimerLabel.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_fetchBonusTimer);
}

@end
