//
//  BYNewbieTwoButtonVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieTwoButtonAlertVC.h"
#import "BYGradientButton.h"
#import "NNPageRouter.h"
#import "HYInGameHelper.h"

@interface BYNewbieTwoButtonAlertVC ()

@property (weak, nonatomic) IBOutlet BYGradientButton *leftButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *rightButton;

@end

@implementation BYNewbieTwoButtonAlertVC
@synthesize type;
@synthesize leftButton;
@synthesize rightButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (type == BYNewbieAlertTypeDespositAndBet) {
        [leftButton setTitle:@"去存款" forState:UIControlStateNormal];
        [rightButton setTitle:@"去投注" forState:UIControlStateNormal];
    }
    else {
        [leftButton setTitle:@"去洗码" forState:UIControlStateNormal];
        [rightButton setTitle:@"去提现" forState:UIControlStateNormal];
    }
    
    self.view.backgroundColor = kHexColorAlpha(0x10101C, 0.5);
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
- (IBAction)leftButtonClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        if (self.type == BYNewbieAlertTypeDespositAndBet) {
            [NNPageRouter jump2Deposit];
        }
        else {
            [NNPageRouter jump2Xima];
        }
    }];

}

- (IBAction)rightButtonClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        if (self.type == BYNewbieAlertTypeDespositAndBet) {
            //去投注
            //百家樂旗艦廳-USDT線
            [[HYInGameHelper sharedInstance] inGame:InGameTypeAGIN];
        }
        else {
            [NNPageRouter jump2Withdraw];
        }
    }];

}

- (IBAction)dimiss:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
