//
//  IN3SWebViewController.m
//  IN3SAnalytics
//
//  Created by Key on 01/04/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IN3SWebViewController.h"

@interface IN3SWebViewController ()

@end

@implementation IN3SWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
