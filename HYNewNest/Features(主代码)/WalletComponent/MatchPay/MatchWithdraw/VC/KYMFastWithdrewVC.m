//
//  KYMFastWithdrewVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMFastWithdrewVC.h"
#import "KYMWithdrewStatusView.h"
#import "KYMWithdrewAmountView.h"
#import "KYMWithdrewSubmitView.h"
#import "KYMWithdrewBankView.h"
#import "KYMWithdrewCusmoterView.h"
#import "KYMWithdrewNoticeView.h"
#import "KYMWithdrewNoticeView1.h"
#import "KYMWithdrewNoticeView2.h"
#import "KYMWithdrewRequest.h"
#import "CNMAlertView.h"
#import "Masonry.h"
#import "MBProgressHUD+Add.h"
#import "SDWebImage.h"
#import "LoadingView.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
@interface KYMFastWithdrewVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) KYMWithdrewStep step;
@property (strong, nonatomic) KYMWithdrewStatusView *statusView;
@property (weak, nonatomic) NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) NSLayoutConstraint *amountViewHeight;
@property (strong, nonatomic) KYMWithdrewAmountView *amountView;
@property (strong, nonatomic) KYMWithdrewBankView *bankView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) KYMWithdrewSubmitView *submitView;
@property (strong, nonatomic) KYMWithdrewCusmoterView *cusmoterView;
@property (strong, nonatomic) KYMWithdrewNoticeView *noticeView;
@property (strong, nonatomic) KYMWithdrewNoticeView1 *noticeView1;
@property (strong, nonatomic) KYMWithdrewNoticeView2 *noticeView2;
@property (weak, nonatomic) NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) NSTimer *statusTimer;
@property (strong, nonatomic) NSTimer *timeoutTimer;
@property (assign, nonatomic) NSUInteger timeout;
@property (assign, nonatomic) BOOL isStartedTimeout;
@property (assign, nonatomic) BOOL isLoadedView;

@end

@implementation KYMFastWithdrewVC

- (void)dealloc
{
    [self stopTimeoutTimer];
    [self stopGetWithdrawDetail];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}
- (void)didEnterBackgroundNotification
{
    [self stopGetWithdrawDetail];
    [self stopTimeoutTimer];
}
- (void)willEnterForegroundNotification
{
    self.isStartedTimeout = NO;
    [self getWithdrawDetail];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"极速取款";
    [self setupSubViews];
    self.step = KYMWithdrewStepOne;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem.action = @selector(goToBack);
    self.navigationItem.leftBarButtonItem.target = self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isLoadedView) {
        [self getWithdrawDetail];
    }
    self.isLoadedView = YES;
}
- (NSTimer *)statusTimer
{
    if (!_statusTimer) {
        _statusTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(getWithdrawDetail) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_statusTimer forMode:NSRunLoopCommonModes];
    }
    return _statusTimer;
}
- (NSTimer *)timeoutTimer
{
    if (!_timeoutTimer) {
        _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeoutCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timeoutTimer forMode:NSRunLoopCommonModes];
    }
    return _timeoutTimer;
}
- (void)setupSubViews
{
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.offset(CGRectGetWidth([UIScreen mainScreen].bounds));
        make.height.offset(CGRectGetHeight([UIScreen mainScreen].bounds));
    }];
    self.statusView = [[KYMWithdrewStatusView alloc] init];
    self.amountView = [[KYMWithdrewAmountView alloc] init];
    self.bankView = [[KYMWithdrewBankView alloc] init];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:0x6D / 255.0 green:0x77 / 255.0 blue:0x8B / 255.0 alpha:0.3];
    self.submitView = [[KYMWithdrewSubmitView alloc] init];
    self.cusmoterView = [[KYMWithdrewCusmoterView alloc] init];
    self.noticeView = [[KYMWithdrewNoticeView alloc] init];
    self.noticeView1 = [[KYMWithdrewNoticeView1 alloc] init];
    self.noticeView2 = [[KYMWithdrewNoticeView2 alloc] init];
    __weak typeof(self)weakSelf = self;
    self.submitView.submitBtnHandle = ^{
        [weakSelf submitBtnClicked];
    };
    self.submitView.notReceivedBtnHandle = ^{
        [weakSelf notRecivedBtnClicked];
    };
    self.cusmoterView.customerBtnHandle = ^{
        [weakSelf customerBtnClicked];
    };
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.amountView];
    [self.contentView addSubview:self.bankView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.submitView];
    [self.contentView addSubview:self.cusmoterView];
    [self.contentView addSubview:self.noticeView];
    [self.contentView addSubview:self.noticeView1];
    [self.contentView addSubview:self.noticeView2];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.offset(160);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.statusView.mas_bottom).offset(19);
        make.height.offset(61);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.amountView.mas_bottom).offset(21);
        make.height.offset(230);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(24);
        make.height.offset(1);
    }];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(51);
        make.height.offset(110);
    }];
    [self.noticeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(53);
        make.height.offset(217);
    }];
    [self.noticeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(39);
        make.height.offset(141);
    }];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.bankView.mas_bottom).offset(35);
        make.height.offset(48);
    }];
    [self.cusmoterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bankView.mas_bottom).offset(107);
        make.width.offset(205);
        make.height.offset(30);
    }];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setStep:(KYMWithdrewStep)step
{
    if (_step == step && self.isLoadedView) {
        return;
    }
    _step = step;
    self.statusView.step = step;
    self.amountView.step = step;
    self.submitView.step = step;
    self.bankView.step = step;
    CGFloat statusViewHeight = 0;
    CGFloat amountViewHeight = 0;
    CGFloat bankViewHeight = 0;
    CGFloat submitHeight = 0;
    CGFloat submitTop = 0;
    CGFloat customerTop = 0;
    switch (step) {
        case KYMWithdrewStepOne:
            statusViewHeight = 160;
            amountViewHeight = 61;
            bankViewHeight = 230;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = YES;
            self.lineView.hidden = YES;
            self.title = @"极速取款";
            break;
        case KYMWithdrewStepTwo:
            statusViewHeight = 160;
            amountViewHeight = 61;
            bankViewHeight = 230;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 221;
            self.submitView.hidden = YES;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = NO;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            self.title = @"等待付款";
            break;
        case KYMWithdrewStepThree:
            statusViewHeight = 160;
            amountViewHeight = 90;
            bankViewHeight = 230;
            submitHeight = 125;
            submitTop = 187;
            customerTop = 337;
            self.submitView.hidden = NO;
            self.noticeView.hidden = NO;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            self.title = @"待确认到账";
            break;
        case KYMWithdrewStepFour:
            statusViewHeight = 160;
            amountViewHeight = 61;
            bankViewHeight = 230;
            submitHeight = 125;
            submitTop = 167;
            customerTop = 304;
            self.submitView.hidden = YES;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = NO;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            self.title = @"待确认到账";
            break;
        case KYMWithdrewStepFive:
            statusViewHeight = 138;
            amountViewHeight = 123;
            bankViewHeight = 263;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = YES;
            self.title = @"取款完成";
            break;
        case KYMWithdrewStepSix:
            statusViewHeight = 138;
            amountViewHeight = 102;
            bankViewHeight = 263;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = YES;
            self.title = @"取款完成";
            break;
            
        default:
            break;
    }
    
    [self.statusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(statusViewHeight);
    }];
    [self.amountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(amountViewHeight);
    }];
    [self.bankView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(bankViewHeight);
    }];
    [self.submitView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankView.mas_bottom).offset(submitTop);
        make.height.offset(submitHeight);
    }];
    [self.cusmoterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankView.mas_bottom).offset(customerTop);
    }];
    [self.view layoutIfNeeded];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CGRectGetMaxY(self.cusmoterView.frame) + 30);
    }];
    [self.contentView bringSubviewToFront:self.submitView];
}
- (void)setDetailModel:(KYMGetWithdrewDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.bankView.iconImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.data.bankIcon] placeholderImage:[UIImage imageNamed:@"mwd_default"]];
    self.bankView.bankName.text = detailModel.data.bankName;
    self.bankView.accoutName.text = detailModel.data.bankAccountName;
    self.bankView.account.text = detailModel.data.bankAccountNo;
    self.bankView.withdrawType.text = @"极速取款";
    self.bankView.amount.text = [[KYMWidthdrewUtility getMoneyString:[detailModel.data.amount doubleValue]] stringByAppendingString:@"元"];
    self.bankView.submitTime.text = detailModel.data.createdDate;
    self.bankView.confirmTime.text = detailModel.data.confirmTime;
    self.amountView.amount = detailModel.data.amount;
    
    if (detailModel.matchStatus == KYMWithdrewDetailStatusFaild  ||  detailModel.data.status == KYMWithdrewStatusNotMatch) {
        //撮合失败,取款失败，取款未匹配，走常规取款
        [self stopTimeoutTimer];
        [self stopGetWithdrawDetail];
        KYMWithdrewFaildVC *vc = [[KYMWithdrewFaildVC alloc] init];
        vc.userName = self.detailModel.data.loginName;
        vc.amountStr = self.detailModel.data.amount;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (detailModel.matchStatus == KYMWithdrewDetailStatusSubmit && detailModel.data.status == KYMWithdrewStatusSubmit1 ) { // 第一步
        self.step = KYMWithdrewStepOne;
    } else if ((detailModel.data.status == KYMWithdrewStatusSubmit && detailModel.matchStatus == KYMWithdrewDetailStatusSubmit)  || (detailModel.data.status == KYMWithdrewStatusWaiting && detailModel.data.depositStatus == KYMWithdrewStatusWaiting) ) { // 第二步，等待付款
        self.step = KYMWithdrewStepTwo;
    } else if (detailModel.data.status == KYMWithdrewStatusWaiting && detailModel.data.depositStatus == KYMWithdrewStatusConfirm ) { // 第三步，待确认到账
        self.step = KYMWithdrewStepThree;
    } else if (detailModel.data.status == KYMWithdrewStatusSuccessed && detailModel.matchStatus == KYMWithdrewDetailStatusSuccess ) { // 第四步，超时
        self.step = KYMWithdrewStepFive;
    } else if (detailModel.data.status == KYMWithdrewStatusSuccessed && detailModel.matchStatus == KYMWithdrewDetailStatusDoing ) { // 第四步，点击取款确认
        self.step = KYMWithdrewStepSix;
    } else if (detailModel.data.status == KYMWithdrewStatusFaild ) { // 第三步，点击取款未到账
        self.step = KYMWithdrewStepFour;
    }
}

- (void)getWithdrawDetail
{
    [self stopGetWithdrawDetail];
    
    NSMutableDictionary *mParams = @{}.mutableCopy;
    //            mparams[@"loginName"] = @""; //用户名，底层已拼接
    //            mparams[@"productId"] = @""; //脱敏产品编号，底层已拼接
    mParams[@"merchant"] = @"A01";
    mParams[@"transactionId"] = self.mmProcessingOrderTransactionId;
    if (!self.isLoadedView) {
        [self showLoading];
    }
    [KYMWithdrewRequest getWithdrawDetailWithParams:mParams callback:^(BOOL status, NSString * _Nonnull msg, KYMGetWithdrewDetailModel *  _Nonnull model) {
        [self hideLoading];
        if (!status) {
            [self statusTimer];
            return;
        }
        
        self.detailModel = model;
    
        if (!self.isStartedTimeout && model.data.confirmTimeFmt && model.data.confirmTimeFmt.length > 0) {
            NSUInteger m = 0;
            NSUInteger s = 0;
            NSArray *arry = [model.data.confirmTimeFmt componentsSeparatedByString:@":"];
            if (arry.count > 1) {
                m = [arry[0] integerValue];
                s = [arry[1] integerValue];
            } else if (arry.count == 1) {
                s = [arry[0] integerValue];
            }
            self.timeout = m * 60 + s;
            self.isStartedTimeout = YES;
            [self timeoutTimer];
        }
        if (model.matchStatus != KYMWithdrewDetailStatusFaild) {
            [self statusTimer];
        }
    }];
}
- (void)timeoutCountDown
{
    self.timeout--;
    NSUInteger m = self.timeout / 60;
    NSUInteger s = self.timeout - m * 60;
    self.statusView.statusLB3.text = [NSString stringWithFormat:@"%02ld分%02ld秒",m,s];
    if (self.timeout <= 0 ) {
        [self stopTimeoutTimer];
        return;
    }
    
}
- (void)stopTimer
{
    [self stopGetWithdrawDetail];
    [self stopTimeoutTimer];
}
- (void)stopGetWithdrawDetail
{
    [_statusTimer invalidate];
    _statusTimer = nil;
}
- (void)stopTimeoutTimer
{
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
}
- (void)submitBtnClicked {
    
    if (self.step == KYMWithdrewStepOne) {
        NSMutableDictionary *mParam = @{}.mutableCopy;
        mParam[@"referenceId"] = self.mmProcessingOrderTransactionId;
        [self showLoading];
        [KYMWithdrewRequest cancelWithdrawWithParams:mParam.copy callback:^(BOOL status, NSString * _Nonnull msg, id  _Nonnull body) {
            [self hideLoading];
            if (status) {
                [MBProgressHUD showMessagNoActivity:@"取消取款成功" toView:nil];
                [self goToBack];
            } else {
                [MBProgressHUD showError:msg toView:nil];
            }
        }];
    } else if (self.step == KYMWithdrewStepThree) {
        [CNMAlertView showAlertTitle:@"再次确认" content:@"老板！请您再次确认是否到账" desc:nil needRigthTopClose:YES commitTitle:@"没有到账" commitAction:^{
            [self checkReceiveStats:YES];
        } cancelTitle:@"确认到账" cancelAction:^{
            [self checkReceiveStats:NO];
        }];
        
    } else if (self.step == KYMWithdrewStepFive || self.step == KYMWithdrewStepSix) {
        [self stopGetWithdrawDetail];
        [self stopTimeoutTimer];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)notRecivedBtnClicked {
    [CNMAlertView showAlertTitle:@"再次确认" content:@"老板！请您再次确认是否到账" desc:nil needRigthTopClose:YES commitTitle:@"没有到账" commitAction:^{
        [self checkReceiveStats:YES];
    } cancelTitle:@"确认到账" cancelAction:^{
        [self checkReceiveStats:NO];
    }];
}
- (void)checkReceiveStats:(BOOL)isNotRceived
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"merchant"] = @"A01";
    //            mparams[@"loginName"] = @""; //用户名，底层已拼接
    //            mparams[@"productId"] = @""; //脱敏产品编号，底层已拼接
    params[@"opType"] = isNotRceived ? @"2" : @"1"; //是否为未到账
    params[@"transactionId"] = self.detailModel.data.transactionId;
    
    [self stopGetWithdrawDetail];
    
    [self showLoading];
    [KYMWithdrewRequest checkReceiveStatus:params callback:^(BOOL status, NSString * _Nonnull msg, id  _Nonnull body) {
        [self hideLoading];
        if (!status) {
            [MBProgressHUD showError:msg toView:nil];
            return;
        }
        self.step =  isNotRceived ? KYMWithdrewStepFour : KYMWithdrewStepSix;
    }];
}
- (void)customerBtnClicked {
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil];
        }
    }];
}
- (void)goToBack {
    
    [self stopGetWithdrawDetail];
    [self stopTimeoutTimer];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showLoading
{
    [LoadingView show];
}
- (void)hideLoading
{
    [LoadingView hide];
}
@end
