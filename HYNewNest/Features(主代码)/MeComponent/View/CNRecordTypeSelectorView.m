//
//  CNRecordTypeSelectorView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNRecordTypeSelectorView.h"
#import "CNTwoStatusBtn.h"
#import "HYRechProcButton.h"

@interface CNRecordTypeSelectorView ()
@property (strong, nonatomic) IBOutletCollection(HYRechProcButton) NSArray *typeBtnArray;
@property (strong, nonatomic) IBOutletCollection(HYRechProcButton) NSArray *dayBtnArray;

@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@property (nonatomic, copy) NSString *selectType;
@property (nonatomic, copy) NSString *selectDay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (nonatomic, weak) id delegate;

@property (nonatomic, copy) void(^callBack)(NSString *type, NSString *day);
@end

@implementation CNRecordTypeSelectorView

+ (void)showSelectorWithSelcType:(TransactionRecordType)type dayParm:(NSInteger)day callBack:(void (^)(NSString * _Nonnull, NSString * _Nonnull))callBack {
    
    CNRecordTypeSelectorView *alert = [[CNRecordTypeSelectorView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    [alert.depostiBtn setTitle:[CNUserManager shareManager].isUsdtMode?@"充币":@"充值" forState:UIControlStateNormal];
    [alert.withdrawBtn setTitle:[CNUserManager shareManager].isUsdtMode?@"提币":@"提现" forState:UIControlStateNormal];
    
    // 设置默认选择
    NSInteger typeIndex = 0;
    NSInteger dayIndex = 0;
    switch (type) {
        case transactionRecord_rechargeType:
            typeIndex = 0;
            break;
        case transactionRecord_withdrawType:
            typeIndex = 1;
            break;
        case transactionRecord_XMType:
            typeIndex = 2;
            break;
        case transactionRecord_yuEBaoDeposit:
            typeIndex = 3;
            break;
        case TransactionRecord_yuEBaoWithdraw:
            typeIndex = 4;
            break;
        case transactionRecord_activityType:
            typeIndex = 5;
            break;
        case transactionRecord_betRecordType:
            typeIndex = 6;
            break;
        default:
            break;
    }
    switch (day) {
        case 3:
            dayIndex = 0;
            break;
        case 7:
            dayIndex = 1;
            break;
        case 30:
            dayIndex = 2;
            break;
        default:
            break;
    }
    UIButton *typeBtn = alert.typeBtnArray[typeIndex];
    alert.selectType = typeBtn.currentTitle;
    UIButton *dayBtn = alert.dayBtnArray[dayIndex];
    alert.selectDay = dayBtn.currentTitle;
    
    alert.submitBtn.enabled = YES;
    alert.callBack = callBack;
    alert.bottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [alert layoutIfNeeded]; //动画刷新约束
        typeBtn.selected = YES;
        dayBtn.selected = YES;
    }];
}

#pragma mark - button Action

- (IBAction)typeAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.typeBtnArray) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.selectType = sender.currentTitle;
    
//    self.submitBtn.enabled = (self.selectType != nil) && (self.selectDay != nil);
}


- (IBAction)dayAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.dayBtnArray) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.selectDay = sender.currentTitle;
    
//    self.submitBtn.enabled = (self.selectType != nil) && (self.selectDay != nil);
}


// 提交
- (IBAction)submitAction:(UIButton *)sender {
    !_callBack ?: _callBack(self.selectType, self.selectDay);
    [self removeFromSuperview];
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
