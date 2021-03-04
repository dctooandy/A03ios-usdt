//
//  BYNewUsrMissionVC.m
//  HYNewNest
//
//  Created by zaky on 3/3/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionVC.h"

#import "CNTwoStatusBtn.h"
#import "UIView+DottedLine.h"

@interface BYNewUsrMissionVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewWidth;
@property (weak, nonatomic) IBOutlet UIView *cumulate3daysBg;
@property (weak, nonatomic) IBOutlet UIView *cumulate7daysBg;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *cumulate3Btn;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *cumulate7Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cumulate4dayIconLeadingCons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cumulate3daysIcons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cumulate7daysIcons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *daysLbCollect;

// 所有待领取按钮状态
@property (strong, nonatomic) IBOutletCollection(CNTwoStatusBtn) NSArray *missionBtns;

@end

@implementation BYNewUsrMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新手任务";
    self.cumulate3Btn.enabled = YES; //状态
    
    _oneViewWidth.constant = kScreenWidth;
    _cumulate4dayIconLeadingCons.constant = (kScreenWidth-15*2-50*3-32*4)*0.5;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    // 边框
    _cumulate3daysBg.backgroundColor = _cumulate7daysBg.backgroundColor = self.view.backgroundColor;
    [_cumulate3daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    [_cumulate7daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    
    for (int i = 0; i < self.missionBtns.count; i++) {
        __block CNTwoStatusBtn *btn = self.missionBtns[i];
        if (i == 0) {
            btn.enabled = YES;
        } else if (i == 1) {
            btn.isThirdStatusEnable = YES;
        } else if (i == 2) {
            btn.isThirdStatusEnable = YES;
        } else {
            btn.enabled = YES;
        }
    }
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
