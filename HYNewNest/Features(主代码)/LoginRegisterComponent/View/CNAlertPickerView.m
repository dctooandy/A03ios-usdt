//
//  CNAlertPickerView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAlertPickerView.h"

@interface CNAlertPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (nonatomic, copy) void(^finish)(NSString *selectText);
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *selectAccount;
@end

@implementation CNAlertPickerView

+ (void)showList:(NSArray<NSString *> *)list title:(NSString *)title finish:(void (^)(NSString * _Nonnull))finish {
    
    CNAlertPickerView *alert = [[CNAlertPickerView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.titleLb.text = title;
    alert.list = list;
    alert.finish = finish;
    [alert configUI];
}

- (void)configUI {
    self.bottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.selectAccount = self.list.firstObject;
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
    !_finish ?: _finish(self.selectAccount);
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.list.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.list[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectAccount = self.list[row];
}
@end
