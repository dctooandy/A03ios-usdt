//
//  CNUserInfoLoginView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNUserInfoLoginView.h"
#import "CNVIPLabel.h"
#import "BalanceManager.h"
#import "CNUserModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+Badge.h"
#import "SDWebImageGIFCoder.h"
#import "BYMyBonusRequest.h"
#import "CNMineVC.h"
@interface CNUserInfoLoginView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgv;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchModeSegc;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLb;

@property (weak, nonatomic) IBOutlet UIButton *withdrawCNYBtn;
@property (weak, nonatomic) IBOutlet UIImageView *usdtADImgv;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

#pragma - mark 未登录属性
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *shapeView;
@property (weak, nonatomic) IBOutlet UIImageView *regisBackImageView;
@property (weak, nonatomic) IBOutlet UIView *promoView;
@property (weak, nonatomic) IBOutlet UIImageView *shakeImgView;
@property (nonatomic, strong) dispatch_source_t shakeTimer;
@end

@implementation CNUserInfoLoginView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    [self editSegmentControlUIStatus];
    [self refreshBottomBtnsStatus];
    // 提现右上角NEW
//    [self.withdrawCNYBtn showRightTopImageName:@"new_txgb" size:CGSizeMake(30, 14) offsetX:-30 offsetYMultiple:0];
    WEAKSELF_DEFINE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalance) name:BYRefreshBalanceNotification object:nil];
    [self serverTime:^(NSString * _Nonnull timeStr) {
        if (timeStr.length > 0) {
            NSString * pathStr = @"";
            //手動輸入要更換的日期
            if ([self checksStartDate:@"2022-01-25" EndDate:@"2022-02-15" serverTime:timeStr])
            {
                pathStr = @"newYear";////双但
            }
            if (pathStr.length > 0) {
                NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"gif"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                UIImageView * img = [[UIImageView alloc] init];
                img.image = [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:data];
                weakSelf.regisBackImageView.image = [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:data];
                [weakSelf.loginView addSubview:img];
                [weakSelf.loginView sendSubviewToBack:img];
                [weakSelf.loginView sendSubviewToBack:weakSelf.shapeView];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.right.left.equalTo(weakSelf.loginView);
                }];
            }
        }
    }];
}
-(BOOL)checksStartDate:(NSString *)startTime EndDate:(NSString *)endTime serverTime:(NSString *)serverTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *serverDate = [dateFormatter dateFromString:serverTime];
    // 判断是否大于server时间
    if (([startDate earlierDate:serverDate] == startDate) &&
        ([serverDate earlierDate:endDate] == serverDate)) {
        return true;
    } else {
        return false;
    }
}
-(void)serverTime:(ServerTimeCompleteBlock)completeBlock {
    
    NSString *time = [self getUTCTimeWithTimeInterval:[NSDate date].timeIntervalSince1970];
    completeBlock(time);
}
//UTC时间
- (NSString *)getUTCTimeWithTimeInterval:(NSTimeInterval)interval {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (void)editSegmentControlUIStatus {
    UIColor *gdColor = [UIColor gradientColorImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeUprightToLowleft imgSize:CGSizeMake(50, 24)];
    if (@available(iOS 13.0, *)) {
        [_switchModeSegc setSelectedSegmentTintColor:gdColor];
    } else {
        [_switchModeSegc setTintColor:kHexColor(0x19CECE)];
    }
    [_switchModeSegc setBackgroundColor:kHexColor(0x3c3d62)];
    [_switchModeSegc setTitleTextAttributes:@{NSForegroundColorAttributeName:gdColor} forState:UIControlStateNormal];
    [_switchModeSegc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
}

- (void)refreshBalance {
    [self updateLoginStatusUIIsRefreshing:true];
}

- (void)updateLoginStatusUIIsRefreshing:(BOOL)isRefreshing {
    
    if ([CNUserManager shareManager].isLogin) {
        [self configLogInUI];
        if (isRefreshing) {
            [self reloadBalance];
        } else {
            [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
                
                float amount = model.yebAmount.floatValue + model.yebInterest.floatValue + model.balance.floatValue;
                [self.moneyLb hideIndicatorWithText:[@(amount) jk_toDisplayNumberWithDigit:2]];
            }];
        }
    } else {
        [self configLogoutUI];
    }
}

- (void)configLogoutUI {
    self.loginView.hidden = NO;
    self.usdtADImgv.hidden = YES;
}

- (void)configLogInUI {
    self.loginView.hidden = YES;
    [self refreshBottomBtnsStatus];

    NSInteger level = [CNUserManager shareManager].userDetail.starLevel;
    if (level <= 7) {
        self.vipImgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_vip%li", level]];
    }
    
    //Set To Default
    self.vipImageConstraint.constant = 24;
    [self.clubImageView setHidden:false];
    
    NSInteger clubLV = [[CNUserManager shareManager].userDetail.clubLevel intValue];
    
    switch (clubLV) {
        case 2:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level1"]];
            break;
        case 3:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level2"]];
            break;
        case 4:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level3"]];
            break;
        case 5:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level4"]];
            break;
        case 6:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level5"]];
            break;
        case 7:
            [self.clubImageView setImage:[UIImage imageNamed:@"icon_vvip-level6"]];
            break;
        default:
            self.vipImageConstraint.constant = 5;
            [self.clubImageView setHidden:true];
            break;
    }
     
    self.usrNameLb.text = [CNUserManager shareManager].printedloginName;
    self.currencyLb.text = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";
    
}

- (void)reloadBalance{
    if ([CNUserManager shareManager].isLogin) {
        [self.moneyLb showIndicatorIsBig:NO];
        WEAKSELF_DEFINE
        //金额
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            [weakSelf.moneyLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.switchModeSegc setEnabled:YES];
            });
        }];
        
        [BYMyBonusRequest getMyBonusListHandler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
                NSArray *dicArr = responseObj;
                NSArray *allPro = [BYMyBounsModel cn_parse:dicArr];
                NSMutableArray *goFetch = @[].mutableCopy;
                NSMutableArray *alreadyFetch = @[].mutableCopy;
                NSMutableArray *overDate = @[].mutableCopy;
                for (BYMyBounsModel *item in allPro) {
                    if ([item.status isEqualToString:@"1"] || [item.status isEqualToString:@"4"]) {
                        [goFetch addObject:item];
                    } else if ([item.status isEqualToString:@"2"]) {
                        [alreadyFetch addObject:item];
                    } else {
                        [overDate addObject:item];
                    }
                }
                if (goFetch.count > 0)
                {
                    // 招牌左右晃
                    [strongSelf.promoView setHidden:NO];
                    [strongSelf shakeAnimation];
                }else
                {
                    [strongSelf.promoView setHidden:YES];
                }
            }
        }];
    }
}
- (void)shakeTimerAction
{
    WEAKSELF_DEFINE
    __block int timeout = 3.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _shakeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(weakSelf.shakeTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(weakSelf.shakeTimer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(weakSelf.shakeTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf shakeAnimation]; 
            });
        }
        else
        {
            timeout--;
        }
    });
    dispatch_resume(_shakeTimer);
}
- (void)shakeAnimation
{
    WEAKSELF_DEFINE
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.shakeImgView.layer removeAllAnimations];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.shakeImgView.transform =  CGAffineTransformMakeTranslation(4,0);
            //            self.bagImageView.transform = self.bagImageView.transform = CGAffineTransformScale(self.bagImageView.transform, 1.1f, 1.1f);
        } completion:^(BOOL finished) {
            weakSelf.shakeImgView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.shakeImgView.transform =  CGAffineTransformMakeTranslation(4,0);
            }completion:^(BOOL finished) {
                weakSelf.shakeImgView.transform = CGAffineTransformIdentity;
                [weakSelf shakeTimerAction];
            }];
        }];
    });
}
// 切换币种 修改买充提买按钮 必须重新加载数据
- (void)switchAccountUIChange {
    [self refreshBottomBtnsStatus];
    [self reloadBalance];
}

- (void)refreshBottomBtnsStatus {
    if ([CNUserManager shareManager].isUsdtMode) {
        _switchModeSegc.selectedSegmentIndex = 1;
        self.currencyLb.text = @"USDT";
        if ([CNUserManager shareManager].userDetail.starLevel == 0) {
            self.usdtADImgv.hidden = NO;
        }

    } else {
        _switchModeSegc.selectedSegmentIndex = 0;
        self.currencyLb.text = @"CNY";
        self.usdtADImgv.hidden = YES;
    }
}

// 切换账户货币
- (IBAction)switchAccountWhileClik:(UISegmentedControl *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchAccountAction)]) {
        [_delegate switchAccountAction];
    }
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonArrayAction:)]) {
        [_delegate buttonArrayAction:(CNActionType)(sender.tag)];
    }
}

- (IBAction)login:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginAction)]) {
        [_delegate loginAction];
    }
}

- (IBAction)regist:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(registerAction)]) {
        [_delegate registerAction];
    }
}

- (IBAction)didTapQuestion:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(questionAction)]) {
        [_delegate questionAction];
    }
}
- (IBAction)didTapToMyPromos:(id)sender {
    [NNControllerHelper currentTabBarController].selectedIndex = 4;
    if ([NNControllerHelper pop2ViewControllerClassString:@"CNMineVC"]) { // 如果无法pop回homepage 则直接pop回上一级
        if ([[NNControllerHelper currentRootVcOfNavController] isKindOfClass:NSClassFromString(@"CNMineVC")])
        {
            [(CNMineVC *)[NNControllerHelper currentRootVcOfNavController] jumpToMyPromos];
        }
    } else {
        [[NNControllerHelper currentTabBarController].navigationController popViewControllerAnimated:YES];
    }
}

@end
