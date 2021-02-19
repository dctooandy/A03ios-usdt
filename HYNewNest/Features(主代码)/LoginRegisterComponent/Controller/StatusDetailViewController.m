//
//  StatusDetailViewController.m
//  IVCheckNetworkLibrary
//
//  Created by Key on 26/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "IVCDetailViewController.h"

@interface StatusDetailViewController ()

@end

@implementation StatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IVCDetailViewController *vc = [[IVCDetailViewController alloc] initWithThemeColor:[UIColor blackColor]];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    self.title = vc.title;
    [vc start];
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
