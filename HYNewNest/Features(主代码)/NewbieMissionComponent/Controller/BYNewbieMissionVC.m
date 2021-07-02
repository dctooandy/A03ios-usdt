//
//  BYNewbieMissionVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/13.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieMissionVC.h"
#import "UILabel+Gradient.h"
#import "HYWideOneBtnAlertView.h"
#import "BYNewbieAlertVC.h"
#import "BYNewbieCashGiftAlertVC.h"
#import "BYMissionCompleteVC.h"
#import "BYGradientButton.h"
#import "CNBindPhoneVC.h"
#import "CNUserManager.h"
#import "CNTaskRequest.h"
#import "CNTaskModel.h"
#import "LoadingView.h"

@interface BYNewbieMissionVC ()

@property (weak, nonatomic) IBOutlet UILabel *maxiumCashGiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashgiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *signinLabel;

@property (strong, nonatomic) IBOutletCollection(BYGradientButton) NSArray *receivedButtons;

@property (strong,nonatomic) CNTaskModel *model;
@property (nonatomic, assign) NSInteger countdownSec;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImage *grayColorImage;
@property (nonatomic, strong) UIImage *normalColorImage;

@end

@implementation BYNewbieMissionVC

#define SIGNIN_CODE @"5CUQqg8Bcx"
#define NUMBER_BIDING_CODE @"fKMACMpx6x"
#define APP_LOGIN_CODE @"v5fVvKsj8R"
#define FIRST_RECHARGE_CODE @"nD5JUu2Gyl"
#define BASIC_RECHARGE_CODE @"SjWGdp2qkM"
#define ADVANCED_RECHARGE_CODE @"6jXlLDbkZM"
#define SHARE_VIP_CODE @"Fm8HJgSuej"
#define FIRST_XIMA_CODE @"EwF8hyh64E"
#define CAHS_GIFT_CODE @"DTz7JkbNbv"

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.maxiumCashGiftLabel setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight
                                                     From:kHexColor(0xFF7777)
                                                  toColor:kHexColor(0xBD005A)];
    
    
    self.normalColorImage = [UIColor gradientImageFromColors:@[kHexColor(0xFF7777), kHexColor(0xBD005A)]
                                                gradientType:GradientTypeLeftToRight
                                                     imgSize:CGSizeMake(215, 48)];
    
    self.grayColorImage = [UIColor gradientImageFromColors:@[kHexColor(0xBDBDBF), kHexColor(0x74759C)]
                                              gradientType:GradientTypeLeftToRight
                                                   imgSize:CGSizeMake(215, 48)];
    
    [self setTitle:@"新手任务"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark Setter/Getter
- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        _timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark -
#pragma mark UI Method
- (void)setupUI {
    
    for (int i = 0; i < self.receivedButtons.count; i++) {
        BYGradientButton *btn = self.receivedButtons[i];
        [btn setBackgroundImage:self.grayColorImage forState:UIControlStateDisabled];
        
        if (i == 1) {
            [btn setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
        }
        else {
            [btn setBackgroundImage:self.grayColorImage forState:UIControlStateNormal];
        }
    }
    
    [self setupSiginUI];
    [self setupLimitTaskUI];
    [self setupUpgradeTaskUI];
    
    if (self.model.beginFlag == 2) {
        for (BYGradientButton *btn in self.receivedButtons) {
            [btn setEnabled:false];
            [btn setTitle:@"已结束" forState:UIControlStateNormal];
        }
    }

    
}

- (void)setupSiginUI {
    NSInteger loginDays = self.model.loginTask.count;
    [self.signinLabel setText:[NSString stringWithFormat:@"签到第%li天", loginDays]];
    BYGradientButton *signinButton = self.receivedButtons[1];
    Result *loginResult = self.model.loginTask.result.firstObject;
    
    if (loginResult == nil
        || (loginResult.prizeLevel == 1 && loginDays > 3 && loginDays < 7)
        || (loginResult.prizeLevel == 2 && loginDays > 7 && loginDays < 15)) {
        
        if (self.model.loginTask.isSignIn == true) {
            [signinButton setTitle:@"已签到" forState:UIControlStateNormal];
            [signinButton setEnabled:false];
        }
        else {
            [signinButton setTitle:@"我要签到" forState:UIControlStateNormal];
            [signinButton setEnabled:true];
        }
        
    }
    else if (loginResult.fetchResultFlag == 0) {
        [signinButton setTitle:[NSString stringWithFormat:@"领%liUSDT", loginResult.prizeAmount] forState:UIControlStateNormal];
        [signinButton setEnabled:true];
    }
    else if (loginResult.fetchResultFlag == 1) {
        [signinButton setTitle:[NSString stringWithFormat:@"已领取"] forState:UIControlStateNormal];
        [signinButton setEnabled:false];
    }
    
    for (int tag = 200; tag < 203; tag++) {
        UIImageView *iv = [self.view viewWithTag:tag];
        if (tag - 200 <= loginResult.prizeLevel - 1 ) {
            [iv setHidden:false];
        }
        else {
            [iv setHidden:true];
        }
    }
}

- (void)setupLimitTaskUI {
    LimiteTask *limitTask = self.model.limiteTask;
    
    if (limitTask.endTime > 0) {
        self.countdownSec = limitTask.endTime;
        [self.timer setFireDate:[NSDate distantPast]];
    }
        
    for (Result *result in limitTask.result) {
        if ([result.prizeCode  containsString:NUMBER_BIDING_CODE]) {
            UIImageView *iv = [self.view viewWithTag:100];
            [iv setHidden:false];
        }
        else if ([result.prizeCode containsString:APP_LOGIN_CODE]) {
            UIImageView *iv = [self.view viewWithTag:101];
            [iv setHidden:false];
        }
        else if ([result.prizeCode containsString:FIRST_RECHARGE_CODE]) {
            UIImageView *iv = [self.view viewWithTag:102];
            [iv setHidden:false];
        }

    }
    
    BYGradientButton *limiteButton = self.receivedButtons[0];
    switch (limitTask.totalFlag) {
        case 0:{
            [limiteButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
            [limiteButton setEnabled:true];
            break;
        }
        case 1:{
            [limiteButton setTitle:[NSString stringWithFormat:@"已领取"] forState:UIControlStateNormal];
            [limiteButton setEnabled:false];
            break;
        }
        default:
            break;
    }
}

- (void)setupUpgradeTaskUI {
    UpgradeTask *upgradeTask = self.model.upgradeTask;
    for (Result *result in upgradeTask.result) {
        if ([result.prizeCode containsString:CAHS_GIFT_CODE]) {
            [self.cashgiftLabel setText:[NSString stringWithFormat:@"%li", result.prizeAmount]];
            BYGradientButton *cashgiftButton = self.receivedButtons[2];
            switch (result.fetchResultFlag) {
                case 0:
                    [cashgiftButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
                    [cashgiftButton setEnabled:true];
                    break;
                case 1:{
                    [cashgiftButton setTitle:@"已领取" forState:UIControlStateNormal];
                    [cashgiftButton setEnabled:false];
                    break;
                }
                default:
                    [cashgiftButton setEnabled:false];
                    break;
            }
        }
        else if ([result.prizeCode containsString:BASIC_RECHARGE_CODE]) {
            BYGradientButton *rechargeButton = self.receivedButtons[3];
            switch (result.fetchResultFlag) {
                case 0:
                    [rechargeButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
                    [rechargeButton setEnabled:true];
                    break;
                case 1:{
                    [rechargeButton setTitle:@"已领取" forState:UIControlStateNormal];
                    [rechargeButton setEnabled:false];
                    break;
                }
                default:
                    break;
            }
        }
        else if ([result.prizeCode containsString:ADVANCED_RECHARGE_CODE]) {
            BYGradientButton *rechargeButton = self.receivedButtons[4];
            switch (result.fetchResultFlag) {
                case 0:
                    [rechargeButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
                    [rechargeButton setEnabled:true];
                    break;
                case 1:{
                    [rechargeButton setTitle:@"已领取" forState:UIControlStateNormal];
                    [rechargeButton setEnabled:false];
                    break;
                }
                default:
                    break;
            }
        }
        else if ([result.prizeCode containsString:FIRST_XIMA_CODE]) {
            BYGradientButton *ximaButton = self.receivedButtons[5];
            switch (result.fetchResultFlag) {
                case 0:
                    [ximaButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
                    [ximaButton setEnabled:true];
                    break;
                case 1:{
                    [ximaButton setTitle:@"已领取" forState:UIControlStateNormal];
                    [ximaButton setEnabled:false];
                    break;
                }
                default:
                    break;
            }
        }
        else if ([result.prizeCode containsString:SHARE_VIP_CODE]) {
            BYGradientButton *vipshareButton = self.receivedButtons[6];
            switch (result.fetchResultFlag) {
                case 0:
                    [vipshareButton setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
                    [vipshareButton setEnabled:true];
                    break;
                case 1:{
                    [vipshareButton setTitle:@"已领取" forState:UIControlStateNormal];
                    [vipshareButton setEnabled:false];
                    
                    break;
                }
                default:
                    break;
            }
            
        }
    }
    
}

#pragma mark -
#pragma mark Custom Method
- (void)countDown {
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld天 %ld:%ld:%ld", self.countdownSec / 86400, (self.countdownSec %  86400) / 3600, (self.countdownSec % 3600) / 60, (self.countdownSec % 60)];
    self.countdownSec--;
    if (self.countdownSec == 0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (BOOL)checkUserLogin {
    BOOL loginStatus = [[CNUserManager shareManager] isLogin];
    if (loginStatus == false) {
        [NNPageRouter jump2Login];
    }
    
    return loginStatus;
}

- (Result *)getUpgradeTaskResultWithCode:(NSString *)code {
    for (Result *result in self.model.upgradeTask.result) {
        if ([result.prizeCode containsString:code]){
            return result;
        }
    }
    
    return nil;
}

- (void)changeButtonReceviedStatus:(NSString *)code {
    UIButton *button;
    if ([code isEqualToString:SIGNIN_CODE]) {
        button = self.receivedButtons[1];
        
        if (self.model.loginTask.isSignIn == true) {
            [button setTitle:@"已领取" forState:UIControlStateNormal];
            [button setEnabled:false];
        }
        else {
            [button setTitle:@"我要签到" forState:UIControlStateNormal];
            [button setBackgroundImage:self.normalColorImage forState:UIControlStateNormal];
            [button setEnabled:true];
        }
    }
    else if ([code isEqualToString:CAHS_GIFT_CODE]) {
        button = self.receivedButtons[2];
    }
    else if ([code isEqualToString:BASIC_RECHARGE_CODE]) {
        button = self.receivedButtons[3];
    }
    else if ([code isEqualToString:ADVANCED_RECHARGE_CODE]) {
        button = self.receivedButtons[4];
    }
    else if ([code isEqualToString:FIRST_XIMA_CODE]) {
        button = self.receivedButtons[5];
    }
    else if ([code isEqualToString:SHARE_VIP_CODE]) {
        button = self.receivedButtons[6];
    }
    [button setEnabled:false];
    [button setTitle:@"已领取" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)bindingPhoneClicked:(id)sender {
    if ([self checkUserLogin] == true) {
        CNBindPhoneVC *bindPhoneVC = [[CNBindPhoneVC alloc] init];
        bindPhoneVC.bindType = CNSMSCodeTypeBindPhone;
        [self.navigationController pushViewController:bindPhoneVC animated:true];
        
    }
    
}

- (IBAction)ruleButtonClicked:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"新手大礼包规则" content:@"1.此活动与其他活动可以共享；\n2.完善有礼、复活礼金任务：新用户在活动期注册后，自注册日起7日内可完成，超出完成时限，则无法完成任务，奖励领取时间为自注册日起30内有效，逾期未领取视为自动放弃；\n3.其他任务完成及奖励领取时限，均为自注册日起30日内有效，逾期未完成/未领取视为自动放弃；\n4.所有奖励需3倍流水方可提现；\n5.此优惠只用于币游真钱账号玩家，如发现个人或团体套利行为，币游国际有权扣除套利所得；\n6.为避免文字差异造成的理解偏差，本活动解释权归币游所有。" comfirmText:@"" comfirmHandler:nil];
}

- (IBAction)completeButtonClicked:(id)sender {
    LimiteTask *limitTask = self.model.limiteTask;
    if ([self checkUserLogin] == false) return;
    
    switch (limitTask.totalFlag) {
        case -1:
            [CNTOPHUB showAlert:@"任務未完成"];
            break;
        case 0: {
            NSMutableString *receivedId = [[NSMutableString alloc] init];
            for (Result *result in limitTask.result) {
                [receivedId appendString:[NSString stringWithFormat:@"%@;", result.ID]];
            }
            if ([receivedId hasSuffix:@";"] && receivedId.length > 1) {
                [receivedId deleteCharactersInRange:NSMakeRange(receivedId.length - 1, 1)];
            }

            
            [self getRewardWithReceivedId:receivedId andCode:limitTask.result.firstObject.prizeCode];
            break;
        }
        default:
            break;
    }
}

- (IBAction)signinButtonClicked:(id)sender {
    if ([self checkUserLogin] == false) return;
    
    NSInteger loginDays = self.model.loginTask.count;
    Result *loginResult = self.model.loginTask.result.firstObject;
    if (loginResult == nil
        || (((loginResult.prizeLevel == 1 && loginDays > 3 && loginDays < 7)
             || (loginResult.prizeLevel == 2 && loginDays > 7 && loginDays < 15)) && loginResult.fetchResultFlag != 0)) {
        [NNPageRouter jump2DepositWithSuggestAmount:15];
    }
    else if (loginResult.fetchResultFlag == 0){
        [self getRewardWithReceivedId:loginResult.ID andCode:loginResult.prizeCode];
    }
    
}

- (IBAction)cashgiftButtonClicked:(id)sender {
    // 條件達到方可領取
    if ([self checkUserLogin] == false) return;
    
    Result *result = [self getUpgradeTaskResultWithCode:CAHS_GIFT_CODE];
    if (result != nil && result.fetchResultFlag == 0) {
        [self getRewardWithReceivedId:result.ID andCode:result.prizeCode];
    }
    
}

- (IBAction)basicRechargeClicked:(id)sender {
    if ([self checkUserLogin] == false) return;
    
    Result *result = [self getUpgradeTaskResultWithCode:BASIC_RECHARGE_CODE];
    
    if (result == nil || result.fetchResultFlag == -1) {
        BYNewbieAlertVC *alertView = [[BYNewbieAlertVC alloc] init];
        alertView.type = BYNewbieAlertTypeDespositAndBet;
        [self presentViewController:alertView animated:false completion:nil];
    }
    else {
        [self getRewardWithReceivedId:result.ID andCode:result.prizeCode];
    }
    
}

- (IBAction)advancedRechargeClicked:(id)sender {
    if ([self checkUserLogin] == false) return;
    Result *result = [self getUpgradeTaskResultWithCode:ADVANCED_RECHARGE_CODE];
    if (result == nil || result.fetchResultFlag == -1) {
        BYNewbieAlertVC *alertView = [[BYNewbieAlertVC alloc] init];
        alertView.type = BYNewbieAlertTypeDespositAndBet;
        [self presentViewController:alertView animated:false completion:nil];
    }
    else {
        [self getRewardWithReceivedId:result.ID andCode:result.prizeCode];
    }
}

- (IBAction)firstXimaClicked:(id)sender {
    if ([self checkUserLogin] == false) return;
    
    Result *result = [self getUpgradeTaskResultWithCode:FIRST_XIMA_CODE];
    
    if (result == nil || result.fetchResultFlag == -1) {
        BYNewbieAlertVC *alertView = [[BYNewbieAlertVC alloc] init];
        alertView.type = BYNewbieAlertTypeXima;
        [self presentViewController:alertView animated:false completion:nil];
    }
    else {
        [self getRewardWithReceivedId:result.ID andCode:result.prizeCode];
    }
}
- (IBAction)vipShareClicked:(id)sender {
    //jusmp to vip
    if ([self checkUserLogin] == false) return;
    Result *result = [self getUpgradeTaskResultWithCode:SHARE_VIP_CODE];
    
    //    if (result == nil || result.fetchResultFlag == -1) {
    //        [NNPageRouter jump2VIP];
    //    }
    //    else {
    if (result.fetchResultFlag == 0) {
        [self getRewardWithReceivedId:result.ID andCode:result.prizeCode];
    }
    //    }
}

- (IBAction)firstRechargeClicked:(id)sender {
    [NNPageRouter jump2DepositWithSuggestAmount:15];
}

#pragma mark -
#pragma mark Fetch Data
- (void)fetchData {    
    [LoadingView show];
    
    __block CNTaskDetail *detail;
    dispatch_group_t group = dispatch_group_create();
    
    WEAKSELF_DEFINE
    dispatch_group_enter(group);
    [CNTaskRequest getNewUsrTask:^(id responseObj, NSString *errorMsg) {
        dispatch_group_leave(group);
        if (!errorMsg) {
            weakSelf.model = [CNTaskModel cn_parse:responseObj];
        }
    }];
    
    dispatch_group_enter(group);
    [CNTaskRequest getNewUsrTaskDetail:^(id responseObj, NSString *errorMsg) {
        dispatch_group_leave(group);
        if (!errorMsg) {
            detail = [CNTaskDetail cn_parse:responseObj];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [weakSelf.totalBettingsLabel setText:[NSString stringWithFormat:@"%li", (long)detail.totalBetAmount]];
        [weakSelf.totalRechargeLabel setText:[NSString stringWithFormat:@"%li", (long)detail.totalRechargeAmount]];
        [weakSelf setupUI];
        [LoadingView hide];
    });
    
}

- (void)getRewardWithReceivedId:(NSString *)receivedID andCode:(NSString *)receivedCode{
    [LoadingView show];
    
    WEAKSELF_DEFINE
    [CNTaskRequest applyTaskRewardIds:receivedID code:receivedCode handler:^(id responseObj, NSString *errorMsg) {
        [LoadingView hide];
        if (!errorMsg) {
            CNTaskReceivedReward *reward = [CNTaskReceivedReward cn_parse:responseObj];
            STRONGSELF_DEFINE
            if ([receivedCode containsString:NUMBER_BIDING_CODE] || [receivedCode containsString:APP_LOGIN_CODE] || [receivedCode containsString:FIRST_RECHARGE_CODE]) {
                BYMissionCompleteVC *vc = [[BYMissionCompleteVC alloc] init];
                vc.reward = reward;
                [strongSelf presentViewController:vc animated:true completion:nil];
            }
            else {
                [CNTOPHUB showSuccess:[NSString stringWithFormat:@"%liUSDT", reward.sucAmount]];
                [strongSelf changeButtonReceviedStatus:receivedCode];
            }
            
        }
    }];
}

@end
