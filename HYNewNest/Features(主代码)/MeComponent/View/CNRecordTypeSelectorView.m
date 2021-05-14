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
@property (weak, nonatomic) IBOutlet UIStackView *thirdStackView;
@property (strong,nonatomic) NSArray *tradeTypeStrings;

@property (nonatomic, copy) void(^callBack)(NSString *type, NSString *day);
@end

@implementation CNRecordTypeSelectorView

- (NSArray *)tradeTypeStrings{
    if (!_tradeTypeStrings) {
        if ([CNUserManager shareManager].isUsdtMode) {
            _tradeTypeStrings = @[@"充币", @"提币", @"洗码", @"余额宝转入", @"余额宝转出", @"优惠领取", @"投注记录"];
        } else {
            _tradeTypeStrings = @[@"充值", @"提现", @"洗码", @"优惠领取", @"投注记录"];
        }
    }
    return _tradeTypeStrings;
}

- (void)setupBtnsWithType:(TransactionRecordType)type day:(NSInteger)day {
    
    if ([CNUserManager shareManager].isUsdtMode) {
        _thirdStackView.hidden = NO;
    } else {
        _thirdStackView.hidden = YES;
    }
    
    [self.typeBtnArray enumerateObjectsUsingBlock:^(HYRechProcButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.tradeTypeStrings.count) {
            [obj setTitle:self.tradeTypeStrings[idx] forState:UIControlStateNormal];
            obj.alpha = 1;
            obj.enabled = YES;
        } else {
            obj.alpha = 0;
            obj.enabled = NO;
        }
    }];
    
    // 设置默认选择
    NSInteger dayIndex = 0;
    NSString *name;
    switch (type) {
        case transactionRecord_rechargeType:
            name = [CNUserManager shareManager].isUsdtMode?@"充币":@"充值";
            break;
        case transactionRecord_withdrawType:
            name = [CNUserManager shareManager].isUsdtMode?@"提币":@"提现";
            break;
        case transactionRecord_XMType:
            name = @"洗码";
            break;
        case transactionRecord_yuEBaoDeposit:
            name = @"余额宝转入";
            break;
        case TransactionRecord_yuEBaoWithdraw:
            name = @"余额宝转出";
            break;
        case transactionRecord_activityType:
            name = @"优惠领取";
            break;
        case transactionRecord_betRecordType:
            name = @"投注记录";
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
    NSInteger idx = [self.tradeTypeStrings indexOfObject:name];
    UIButton *typeBtn = self.typeBtnArray[idx];
    self.selectType = typeBtn.currentTitle;
    UIButton *dayBtn = self.dayBtnArray[dayIndex];
    self.selectDay = dayBtn.currentTitle;
    
    self.submitBtn.enabled = YES;
    self.bottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded]; //动画刷新约束
        typeBtn.selected = YES;
        dayBtn.selected = YES;
    }];
}


#pragma mark - 类方法

+ (void)showSelectorWithSelcType:(TransactionRecordType)type dayParm:(NSInteger)day callBack:(void (^)(NSString * _Nonnull, NSString * _Nonnull))callBack {
    
    CNRecordTypeSelectorView *alert = [[CNRecordTypeSelectorView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];

    alert.callBack = callBack;
    [alert setupBtnsWithType:type day:day];
    
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
