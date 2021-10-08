//
//  HYXiMaSuccViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYXiMaSuccViewController.h"
#import "UILabel+Gradient.h"
#import "CNTwoStatusBtn.h"

@interface HYXiMaSuccViewController ()
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *congrsLb;
@property (weak, nonatomic) IBOutlet UILabel *successLb;

@end

@implementation HYXiMaSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"洗码";
    [self addNaviRightItemWithImageName:@"service"];

    self.backBtn.enabled = YES;
    [self.congrsLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    NSNumber *num = [NSNumber jk_numberWithCGFloat:self.totalAmount];
    NSString *numStr = [num jk_toDisplayNumberWithDigit:2];
    
    self.successLb.text = [NSString stringWithFormat:@"成功洗码，到账%@ %@", numStr, [CNUserManager shareManager].isUsdtMode ? @"USDT" : @"CNY"];
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}

#pragma mark - ACTION

- (IBAction)didTapBanner:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NNControllerHelper currentTabBarController].selectedIndex = 1;
}

- (IBAction)didTabBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
