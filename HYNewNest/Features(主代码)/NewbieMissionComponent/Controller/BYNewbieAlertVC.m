//
//  BYNewbieTwoButtonVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieAlertVC.h"
#import "BYGradientButton.h"
#import "NNPageRouter.h"
#import "HYInGameHelper.h"

@interface BYNewbieAlertVC ()

@property (weak, nonatomic) IBOutlet BYGradientButton *depositButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *betingsButton;
@property (weak, nonatomic) IBOutlet BYGradientButton *ximaButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BYNewbieAlertVC
@synthesize type;


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
            [self.contentLabel setText:@"由于我们检测到您还未满足领取条件\n请选择存款或者投注"];
            [self.ximaButton setHidden:true];
            [self.depositButton setHidden:false];
            [self.betingsButton setHidden:false];
        }
        else {
            [self.contentLabel setText:@"由于我们检测到您还未满足领取条件\n请选择洗码"];
            [self.ximaButton setHidden:false];
            [self.depositButton setHidden:true];
            [self.betingsButton setHidden:true];
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
- (IBAction)betingsClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        //去投注
        //百家樂旗艦廳-USDT線
        [[HYInGameHelper sharedInstance] inGame:InGameTypeAGIN];
        
    }];
}
- (IBAction)depositClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        [NNPageRouter jump2Deposit];
    }];
}

- (IBAction)ximaClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        [NNPageRouter jump2Xima];
    }];
}

- (IBAction)dimiss:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
