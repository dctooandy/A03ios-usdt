//
//  BYRegisterSuccessVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/11.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRegisterSuccessVC.h"
#import "UILabel+Gradient.h"

@interface BYRegisterSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end

@implementation BYRegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNavgation = YES;
    [self.successLabel setupGradientColorFrom:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
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
- (IBAction)newbieMissionClicked:(id)sender {
    [NNPageRouter jump2NewbieMission];
}

- (IBAction)didTapGoAround:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:false];
}

@end
