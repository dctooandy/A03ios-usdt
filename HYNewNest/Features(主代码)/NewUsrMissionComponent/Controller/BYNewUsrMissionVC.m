//
//  BYNewUsrMissionVC.m
//  HYNewNest
//
//  Created by zaky on 3/3/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionVC.h"

#import "HYWideOneBtnAlertView.h"
#import "HYNewUsrMissonAlertView.h"
#import "BYNewUsrMissionCell.h"

#import "BYThreeStatusBtn.h"
#import "UIView+DottedLine.h"

#import "CNTaskRequest.h"
#import "CNTaskModel.h"

static NSString * const kMissionCell = @"BYNewUsrMissionCell";

@interface BYNewUsrMissionVC () <UITableViewDelegate, UITableViewDataSource>
{
    //倒计时秒数
    NSInteger _cdSec1;
    NSInteger _cdSec2;
    //累计登录天数
    NSInteger _cumulateLoginCount;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cumulate4dayIconLeadingCons;

@property (weak, nonatomic) IBOutlet UIView *cumulate3daysBg;
@property (weak, nonatomic) IBOutlet UIView *cumulate7daysBg;
@property (weak, nonatomic) IBOutlet UILabel *cumulateAmount3;
@property (weak, nonatomic) IBOutlet UILabel *cumulateAmount7;
// 累计登录3天按钮
@property (weak, nonatomic) IBOutlet BYThreeStatusBtn *cumulate3Btn;
// 累计登录7天按钮
@property (weak, nonatomic) IBOutlet BYThreeStatusBtn *cumulate7Btn;
// 累计登录天进度按钮
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cumulate3daysIcons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cumulate7daysIcons;
// 所有天数Label状态
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *daysLbCollect;

// 倒计时文字
@property (weak, nonatomic) IBOutlet UILabel *limtTimeCuntDwnLb;
@property (weak, nonatomic) IBOutlet UILabel *progressCuntDwnLb;
@property (weak,nonatomic) NSTimer *timer; //!<分钟计时器

// 两个列表
@property (weak, nonatomic) IBOutlet UITableView *limitTimeTableView;
@property (weak, nonatomic) IBOutlet UITableView *upgradeTableView;

// 数据
@property (strong,nonatomic) CNTaskModel *model; 

@end

@implementation BYNewUsrMissionVC

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        _timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新手任务";
    _cumulateLoginCount = 0;
    
    // tableView
    [self.limitTimeTableView registerNib:[UINib nibWithNibName:kMissionCell bundle:nil] forCellReuseIdentifier:kMissionCell];
    [self.upgradeTableView registerNib:[UINib nibWithNibName:kMissionCell bundle:nil] forCellReuseIdentifier:kMissionCell];
    
    // 更新约束
    _oneViewWidth.constant = kScreenWidth;
    _cumulate4dayIconLeadingCons.constant = (kScreenWidth-15*2-50*3-32*4)*0.5;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    // 边框
    _cumulate3daysBg.backgroundColor = _cumulate7daysBg.backgroundColor = self.view.backgroundColor;
    [_cumulate3daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    [_cumulate7daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    
}


#pragma mark - Action

- (IBAction)didTapRuleBanner:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"活动规则" content:@"1.此活动与其他活动共享；\n2.限时任务：新用户在活动期间注册后，有30天可以完成限时任务，超出完成时限，则新手任务无法完成；\n3.其他任务：活动期间内完成即可；\n4.所有奖励需手动领取，过期未领取奖励自动失效；\n5.所有奖励需3倍流水方可提现；\n6.此优惠只用于币游真钱账号玩家，如发现个人或团体套利行为，币游国际有权扣除套利所得；\n7.为避免文字差异造成的理解偏差，本活动解释权归币游所有。" comfirmText:@"" comfirmHandler:nil];
}

- (IBAction)didTapApplyLoginRewardBtn:(BYThreeStatusBtn *)sender {
    if (!self.model) {
        [CNHUB showError:@"出错了 请刷新页面"];
        return;
    }
    
    // 任务结束弹窗
    if (self.model.isBeyondClaimTime) {
        [HYNewUsrMissonAlertView showFirstDepositOrTaskEndIsEnd:YES handler:^(BOOL isComfm) {
            if (isComfm) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [NNControllerHelper currentTabBarController].selectedIndex = 2;
                });
            }
        }];
        return;
    }
    
    // 非可领取状态
    if (sender.status != CNThreeStaBtnStatusGradientBackground) {
        return;
    }
    
    //领取
    NSInteger idx = sender.tag;
    LoginTask *loginTask = self.model.loginTask;
    Result *result = loginTask.result[idx];
    [CNTaskRequest applyTaskRewardIds:result.ID code:result.prizeCode handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            sender.status = CNThreeStaBtnStatusDark;
            [sender setTitle:@"已领取" forState:UIControlStateNormal];
        }
    }];
}


#pragma mark - Custom
- (void)countDown {
    self.limtTimeCuntDwnLb.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分", _cdSec1/86400, (_cdSec1%86400)/3600, (_cdSec1%3600)/60];
    self.progressCuntDwnLb.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分", _cdSec2/86400, (_cdSec2%86400)/3600, (_cdSec2%3600)/60];
    _cdSec1 -= 60;
    _cdSec2 -= 60;
    if (_cdSec1 <= 0) {
        self.limtTimeCuntDwnLb.text = @"已结束";
    }
    if (_cdSec2 <= 0) {
        self.progressCuntDwnLb.text = @"已结束";
    }
    if (_cdSec1 <= 0 && _cdSec2 <= 0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)prepareCountDown {
    LimiteTask *limitT = self.model.limiteTask;
    self->_cdSec1 = limitT.endTime?:0;
    UpgradeTask *upgradeT = self.model.upgradeTask;
    self->_cdSec2 = upgradeT.endTime?:0;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)drawLoginTaskZone {
    LoginTask *loginT = self.model.loginTask;
    if (!loginT) { return; }
    
    _cumulateLoginCount = loginT.count; //累计登录天
    
    // 登录任务 第一个块
    Result *res3 = loginT.result.firstObject;
    _cumulateAmount3.text = res3.amount;
    switch (res3.fetchResultFlag) {
        case -1:
            _cumulate3Btn.status = CNThreeStaBtnStatusDark;
            break;
        case 0:
            _cumulate3Btn.status = CNThreeStaBtnStatusGradientBorder;
            break;
        case 1:
            _cumulate3Btn.status = CNThreeStaBtnStatusDark;
            [_cumulate3Btn setTitle:@"已领取" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    // 画线
    [_cumulate3daysIcons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self->_cumulateLoginCount > idx) { // 点亮
            obj.selected = YES;
            UILabel *lb = self.daysLbCollect[idx];
            lb.textColor = [UIColor whiteColor];
            if (idx != 2) {
                // 亮的按钮右边的那条不需要亮线
                if (self->_cumulateLoginCount > (idx+1)) {
                    [self drawLineOnLayer:self.cumulate3daysBg.layer withObj:obj isLight:YES];
                } else {
                    [self drawLineOnLayer:self.cumulate3daysBg.layer withObj:obj isLight:NO];
                }
            }
        } else {
            if (idx != 2) {
                [self drawLineOnLayer:self.cumulate3daysBg.layer withObj:obj isLight:NO];
            }
        }
    }];
    
    // 登录任务第二个块
    Result *res7 = loginT.result.lastObject;
    _cumulateAmount7.text = res7.amount;
    switch (res7.fetchResultFlag) {
        case -1:
            _cumulate7Btn.status = CNThreeStaBtnStatusDark;
            break;
        case 0:
            _cumulate7Btn.status = CNThreeStaBtnStatusGradientBorder;
            break;
        case 1:
            _cumulate7Btn.status = CNThreeStaBtnStatusDark;
            [_cumulate7Btn setTitle:@"已领取" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    // 画线
    [_cumulate7daysIcons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self->_cumulateLoginCount > (idx+3)) {
            obj.selected = YES;
            UILabel *lb = self.daysLbCollect[idx];
            lb.textColor = [UIColor whiteColor];
            if (idx != 3) {
                if (self->_cumulateLoginCount > (idx+4)) {
                    [self drawLineOnLayer:self.cumulate7daysBg.layer withObj:obj isLight:YES];
                } else {
                    [self drawLineOnLayer:self.cumulate7daysBg.layer withObj:obj isLight:NO];
                }
            }
        } else {
            if (idx != 3) {
                [self drawLineOnLayer:self.cumulate7daysBg.layer withObj:obj isLight:NO];
            }
        }
    }];
}

- (void)drawLineOnLayer:(CALayer *)fLayer withObj:(UIButton *)obj isLight:(BOOL)isLight {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startP = CGPointMake(obj.right, obj.top+obj.height*0.5);
    [path moveToPoint:startP];
    CGPoint endP = CGPointMake(obj.right+50, obj.top+obj.height*0.5);
    [path addLineToPoint:endP];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 1.0;
    layer.strokeColor = isLight ? kHexColor(0x13B7D4).CGColor : kHexColorAlpha(0xFFFFFF, .3).CGColor;
    layer.path = path.CGPath;
    [fLayer addSublayer:layer];

}

#pragma mark - Data
- (void)requestData {
    [CNTaskRequest getNewUsrTask:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            self.model = [CNTaskModel cn_parse:responseObj];
            if (self.model) {
                [self drawLoginTaskZone];
                [self prepareCountDown];
                [self.limitTimeTableView reloadData];
                [self.upgradeTableView reloadData];
            }
        }
    }];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.limitTimeTableView]) {
        LimiteTask *lTask = self.model.limiteTask;
        return lTask.result.count;
    } else {
        UpgradeTask *uTask = self.model.upgradeTask;
        return uTask.result.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYNewUsrMissionCell *cell = (BYNewUsrMissionCell *)[tableView dequeueReusableCellWithIdentifier:kMissionCell];
    Result *res;
    if ([tableView isEqual:self.limitTimeTableView]) {
        cell.isUpgradeTask = NO;
        NSArray *resArr = self.model.limiteTask.result;
        res = resArr[indexPath.row];
        cell.isTimeout = self->_cdSec1 <= 0;
    } else {
        cell.isUpgradeTask = YES;
        NSArray *resArr = self.model.upgradeTask.result;
        res = resArr[indexPath.row];
        cell.isTimeout = self->_cdSec2 <= 0;
    }
    cell.isBeyondClaim = self.model.beginFlag > 1;
    cell.resModel = res;
    return cell;
}


@end
