//
//  CNRecordTypeSelectorView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "VIPRecordSelectorView.h"
#import "CNTwoStatusBtn.h"

@interface VIPRecordSelectorView ()
@property (strong, nonatomic) IBOutletCollection(CNSelectBtn) NSArray *typeBtnArray;
@property (strong, nonatomic) IBOutletCollection(CNSelectBtn) NSArray *dayBtnArray;

@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@property (nonatomic, assign) VIPReceiveRecordType selectType;
@property (nonatomic, assign) NSInteger selectDay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (nonatomic, weak) id delegate;

@property (nonatomic, copy) void(^callBack)(VIPReceiveRecordType type, NSInteger day);
@end

@implementation VIPRecordSelectorView

+ (void)showSelectorWithSelcType:(VIPReceiveRecordType)type
                         dayParm:(NSInteger)day
                        callBack:(void (^)(VIPReceiveRecordType type, NSInteger day))callBack{
    
    VIPRecordSelectorView *alert = [[VIPRecordSelectorView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    // 设置默认选择
    NSInteger typeIndex = 1;
    NSInteger dayIndex = 0;
    switch (type) {
        case VIPReceiveRecordTypeZZZP:
            typeIndex = 0;
            break;
        case VIPReceiveRecordTypeLJSF:
            typeIndex = 1;
            break;
        default:
            break;
    }
    switch (day) {
        case 1: dayIndex = 0; break;
        case 3: dayIndex = 1; break;
        case 7: dayIndex = 2; break;
        case 30: dayIndex = 3; break;
        case 90: dayIndex = 4; break;
        case 180: dayIndex = 5; break;
        case 365: dayIndex = 6; break;
        default:
            break;
    }
    UIButton *typeBtn = alert.typeBtnArray[typeIndex];
    typeBtn.selected = YES;
    UIButton *dayBtn = alert.dayBtnArray[dayIndex];
    dayBtn.selected = YES;
    
    alert.selectType = type;
    alert.selectDay = day;
    alert.submitBtn.enabled = YES;
    alert.callBack = callBack;
    alert.bottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [alert layoutIfNeeded];
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
    self.selectType = sender.tag;
    
}


- (IBAction)dayAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.dayBtnArray) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.selectDay = sender.tag;
    

}


// 提交
- (IBAction)submitAction:(UIButton *)sender {
    !_callBack ?: _callBack(self.selectType, self.selectDay);
    [self close:nil];
}

// 关闭页面
- (IBAction)close:(id)sender {
    self.bottom.constant = -490;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
