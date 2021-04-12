//
//  BYNewUsrMissionVC.m
//  HYNewNest
//
//  Created by zaky on 3/3/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionVC.h"

#import "HYWideOneBtnAlertView.h"
#import "HYUpdateAlertView.h"

#import "CNTwoStatusBtn.h"
#import "UIView+DottedLine.h"

@interface BYNewUsrMissionVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cumulate4dayIconLeadingCons;
@property (weak, nonatomic) IBOutlet UIView *cumulate3daysBg;
@property (weak, nonatomic) IBOutlet UIView *cumulate7daysBg;
// 累计登录3天按钮
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *cumulate3Btn;
// 累计登录7天按钮
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *cumulate7Btn;
// 累计登录天进度按钮
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cumulate3daysIcons;
// 所有天数Label状态
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *daysLbCollect;
// 所有待领取按钮状态
@property (strong, nonatomic) IBOutletCollection(CNTwoStatusBtn) NSArray *missionBtns;
// 倒计时文字
@property (weak, nonatomic) IBOutlet UILabel *limtTimeCuntDwnLb;
@property (weak, nonatomic) IBOutlet UILabel *progressCuntDwnLb;

@end

@implementation BYNewUsrMissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        // 首充弹窗
//        [HYUpdateAlertView showFirstDepositHandler:^(BOOL isComfm) {
//            [NNPageRouter jump2Deposit];
//        }];
//    });
    
    self.title = @"新手任务";
    self.cumulate7Btn.enabled = NO; //状态
    
    _oneViewWidth.constant = kScreenWidth;
    _cumulate4dayIconLeadingCons.constant = (kScreenWidth-15*2-50*3-32*4)*0.5;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    // 边框
    _cumulate3daysBg.backgroundColor = _cumulate7daysBg.backgroundColor = self.view.backgroundColor;
    [_cumulate3daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    [_cumulate7daysBg dottedLineBorderColor:kHexColor(0x494960) fillColor:kHexColor(0x181829)];
    
    //TODO: 画线
    [_cumulate3daysIcons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx < 3) { //3天
            obj.selected = YES;
            UILabel *lb = self.daysLbCollect[idx];
            lb.textColor = [UIColor whiteColor];
            
            if (idx != 2) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                CGPoint startP = CGPointMake(obj.right, obj.top+obj.height*0.5);
                [path moveToPoint:startP];
                CGPoint endP = CGPointMake(obj.right+50, obj.top+obj.height*0.5);
                [path addLineToPoint:endP];
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.lineWidth = 1.0;
                layer.strokeColor = kHexColor(0x13B7D4).CGColor;
                layer.path = path.CGPath;
                [self.cumulate3daysBg.layer addSublayer:layer];
            }
            
        } else { // 另外4天
            if (idx != 6) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                CGPoint startP = CGPointMake(obj.right, obj.top+obj.height*0.5);
                [path moveToPoint:startP];
                CGPoint endP = CGPointMake(obj.right+50, obj.top+obj.height*0.5);
                [path addLineToPoint:endP];
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.lineWidth = 1.0;
                layer.strokeColor = kHexColorAlpha(0xFFFFFF, .3).CGColor;
                layer.path = path.CGPath;
                [self.cumulate7daysBg.layer addSublayer:layer];
            }
        }
    }];
    
    //TODO: 修改按钮状态
    for (int i = 0; i < self.missionBtns.count; i++) {
        __block CNTwoStatusBtn *btn = self.missionBtns[i];
        
    }
    
}


#pragma mark - Action

- (IBAction)didTapRuleBanner:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"活动规则" content:@"1.此活动与其他活动共享；\n2.限时任务：新用户在活动期间注册后，有30天可以完成限时任务，超出完成时限，则新手任务无法完成；\n3.其他任务：活动期间内完成即可；\n4.所有奖励需手动领取，过期未领取奖励自动失效；\n5.所有奖励需3倍流水方可提现；\n6.此优惠只用于币游真钱账号玩家，如发现个人或团体套利行为，币游国际有权扣除套利所得；\n7.为避免文字差异造成的理解偏差，本活动解释权归币游所有。" comfirmText:@"" comfirmHandler:nil];
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
