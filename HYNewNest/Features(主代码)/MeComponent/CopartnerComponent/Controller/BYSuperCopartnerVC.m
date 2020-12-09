//
//  BYSuperCopartnerVC.m
//  HYNewNest
//
//  Created by zaky on 12/9/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYSuperCopartnerVC.h"

@interface BYSuperCopartnerVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthCons;

@end

@implementation BYSuperCopartnerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    self.makeTranslucent = YES;
//    self.navBarTransparent = YES;
    
    self.title = @"超级合伙人";
    self.view.backgroundColor = kHexColor(0x190A39);
//    self.scrollViewWidthCons.constant = kScreenWidth;
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
