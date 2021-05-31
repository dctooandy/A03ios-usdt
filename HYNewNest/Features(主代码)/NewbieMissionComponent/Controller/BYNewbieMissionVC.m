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

@interface BYNewbieMissionVC ()
@property (weak, nonatomic) IBOutlet UILabel *maxiumCashGiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *signinLabel;

@property (weak, nonatomic) IBOutlet BYGradientButton *completeButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *signinButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *cashGiftButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *gameExperienceButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *firstXimaButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *vipshareButton;

@end

@implementation BYNewbieMissionVC

#define SIGNIN(...) [NSString stringWithFormat:@"签到第%i天", __VA_ARGS__]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.maxiumCashGiftLabel setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight
                                                     From:kHexColor(0xFF7777)
                                                  toColor:kHexColor(0xBD005A)];
    [self lightupRecharge];
    [self lightupCompleteGift];
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
#pragma mark Custom Method
- (void)lightupCompleteGift {
    for (int tag = 100; tag < 102; tag++) {
        UIImageView *iv = [self.view viewWithTag:tag];
        [iv setHidden:false];
    };
}

- (void)lightupRecharge {
    for (int tag = 200; tag < 203; tag++) {
        UIImageView *iv = [self.view viewWithTag:tag];
        [iv setHidden:false];
    };
}

- (BOOL)checkUserLogin {
    BOOL loginStatus = [[CNUserManager shareManager] isLogin];
    if (loginStatus == false) {
        [NNPageRouter jump2Login];
    }
    
    return loginStatus;
}

#pragma mark -
#pragma mark IBAction
- (IBAction)bindingPhoneClicked:(id)sender {
    if ([self checkUserLogin] == true && [CNUserManager shareManager].userDetail.mobileNoBind) {
        CNBindPhoneVC *bindPhoneVC = [[CNBindPhoneVC alloc] init];
        bindPhoneVC.bindType = CNSMSCodeTypeBindPhone;
        [self.navigationController pushViewController:bindPhoneVC animated:true];
    }
    
}

- (IBAction)ruleButtonClicked:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"新手大礼包规则" content:@"1.此活动与其他活动可以共享；\n2.完善有礼、复活礼金任务：新用户在活动期注册后，自注册日起7日内可完成，超出完成时限，则无法完成任务，奖励领取时间为自注册日起30内有效，逾期未领取视为自动放弃；\n3.其他任务完成及奖励领取时限，均为自注册日起30日内有效，逾期未完成/未领取视为自动放弃；\n4.所有奖励需3倍流水方可提现；\n5.此优惠只用于币游真钱账号玩家，如发现个人或团体套利行为，币游国际有权扣除套利所得；\n6.为避免文字差异造成的理解偏差，本活动解释权归币游所有。" comfirmText:@"" comfirmHandler:nil];
}

- (IBAction)completeButtonClicked:(id)sender {
    if ([self checkUserLogin] == false) return;
    
    [NNPageRouter jump2DepositWithSuggestAmount:15];
}

- (IBAction)signinButtonClicked:(id)sender {
    if ([self checkUserLogin]) return;
    
    //        if (){
    [NNPageRouter jump2DepositWithSuggestAmount:15];
    //        }
    //        else {
    //領取
    //        }
    
}

- (IBAction)cashgiftButtonClicked:(id)sender {
    // 條件達到方可領取
    if ([self checkUserLogin] == false) return;

    BYNewbieCashGiftAlertVC *alertView = [[BYNewbieCashGiftAlertVC alloc] init];
    [self presentViewController:alertView animated:false completion:nil];
}

- (IBAction)gemeExperienceClicked:(id)sender {
    if ([self checkUserLogin] == false) return;

    BYNewbieAlertVC *alertView = [[BYNewbieAlertVC alloc] init];
    alertView.type = BYNewbieAlertTypeDespositAndBet;
    [self presentViewController:alertView animated:false completion:nil];
    
}

- (IBAction)firstXimaClicked:(id)sender {
    if ([self checkUserLogin] == false) return;

    BYNewbieAlertVC *alertView = [[BYNewbieAlertVC alloc] init];
    alertView.type = BYNewbieAlertTypeXima;
    [self presentViewController:alertView animated:false completion:nil];
    
}
- (IBAction)vipShareClicked:(id)sender {
    //jusmp to vip
    if ([self checkUserLogin] == false) return;

    
    [NNPageRouter jump2VIP];
    
}

@end
