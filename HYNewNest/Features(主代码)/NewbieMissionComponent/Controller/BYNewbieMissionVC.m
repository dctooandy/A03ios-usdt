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
#import "BYNewbieTwoButtonAlertVC.h"
#import "BYNewbieCashGiftAlertVC.h"

@interface BYNewbieMissionVC ()
@property (weak, nonatomic) IBOutlet UILabel *maxiumCashGiftLabel;

@end

@implementation BYNewbieMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.maxiumCashGiftLabel setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight
                                                     From:kHexColor(0xFF7777)
                                                  toColor:kHexColor(0xBD005A)];
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
#pragma mark IBAction
- (IBAction)ruleButtonClicked:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"新手大礼包规则" content:@"1.此活动与其他活动可以共享；\n2.完善有礼、复活礼金任务：新用户在活动期注册后，自注册日起7日内可完成，超出完成时限，则无法完成任务，奖励领取时间为自注册日起30内有效，逾期未领取视为自动放弃；\n3.其他任务完成及奖励领取时限，均为自注册日起30日内有效，逾期未完成/未领取视为自动放弃；\n4.所有奖励需3倍流水方可提现；\n5.此优惠只用于币游真钱账号玩家，如发现个人或团体套利行为，币游国际有权扣除套利所得；\n6.为避免文字差异造成的理解偏差，本活动解释权归币游所有。" comfirmText:@"" comfirmHandler:nil];
}

- (IBAction)testClicked:(id)sender {
//    BYNewbieTwoButtonAlertVC *alertView = [[BYNewbieTwoButtonAlertVC alloc] init];
//    alertView.type = BYNewbieAlertTypeWithdrawal;
//    [self presentViewController:alertView animated:false completion:nil];
    BYNewbieCashGiftAlertVC *alertView = [[BYNewbieCashGiftAlertVC alloc] init];
    [self presentViewController:alertView animated:false completion:nil];
}

@end
