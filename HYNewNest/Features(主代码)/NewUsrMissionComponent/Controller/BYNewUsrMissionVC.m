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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
