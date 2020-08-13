//
//  CNBankVerifySmsView.m
//  HYNewNest
//
//  Created by Cean on 2020/8/12.
//  Copyright © 2020 emneoma. All rights reserved.
//


#import "CNBankVerifySmsView.h"
#import "CNCodeInputView.h"

@interface CNBankVerifySmsView () <CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
/// 电话号码
@property (nonatomic, copy) NSString *phone;
/// 发送验证码回调
@property (nonatomic, copy) dispatch_block_t sendCodeBlock;
/// 确认回调
@property (nonatomic, copy) void(^finishBlock)(CNBankVerifySmsView *view, SmsCodeModel *smsModel);
@property (nonatomic, strong) SmsCodeModel *smsModel;
@end

@implementation CNBankVerifySmsView

+ (void)showPhone:(NSString *)phone
           finish:(nonnull void (^)(CNBankVerifySmsView * _Nonnull, SmsCodeModel *smsModel))finishBlock {
    
    CNBankVerifySmsView *alert = [[CNBankVerifySmsView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.phone = phone;
    alert.finishBlock = finishBlock;
    [alert configUI];
}

- (void)configUI {
    self.codeInputView.codeType = CNCodeTypeBankCard;
    self.codeInputView.delegate = self;
    self.bottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    [self addKeyboardNotification];
}

#pragma mark - InputViewDelegate

- (void)didReceiveSmsCodeModel:(SmsCodeModel *)model{
    self.smsModel = model;
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = view.correct;
}

#pragma mark - KeyboardNotification

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    NSDictionary *dic = notifi.userInfo;
    NSInteger animationType = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [dic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottom.constant = rect.size.height;
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    NSInteger animationType = [notifi.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottom.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - button Action

// 提交
- (IBAction)submitAction:(UIButton *)sender {
    self.smsModel.smsCode = self.codeInputView.code;
    !_finishBlock ?: _finishBlock(self, self.smsModel);
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    self.phoneLb.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.codeInputView.account = phone;
}

@end
