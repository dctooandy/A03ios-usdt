//
//  CNAmountInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNAmountInputView.h"


@interface CNAmountInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;

/// 记录对错，用于UI改变风格
@property (assign, nonatomic) BOOL wrongCode;
@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *normalColor;


@end

@implementation CNAmountInputView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongCode = YES;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}

- (void)setPlaceholder:(NSString *)text {
    self.inputTF.placeholder = text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLb.hidden = NO;
    self.lineView.backgroundColor = _wrongCode ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tipLb.hidden = YES;
    self.lineView.backgroundColor = self.normalColor;
}

- (void)textFieldChange:(UITextField *)textField {
    
    NSString *text = textField.text;
    switch (_codeType) {
        case CNAmountTypeWithdraw:{
            BOOL iscorrect = YES;
            CGFloat amount = [text floatValue];
            if (amount < [self.model.minWithdrawAmount floatValue]) {
                if ([CNUserManager shareManager].isUsdtMode) {
                    [self showWrongMsg:[NSString stringWithFormat:@"最小提币数额不小于%@USDT", self.model.minWithdrawAmount]];
                } else {
                    [self showWrongMsg:[NSString stringWithFormat:@"最小提现金额不小于%@CNY", self.model.minWithdrawAmount]];
                }
                iscorrect = NO;
            } else if (amount > [self.model.withdrawBal floatValue]) {
                [self showWrongMsg:@"可提现余额不足"];
                iscorrect = NO;
            } else {
                self.tipLb.text = @"请输入提款金额";
                self.tipLb.textColor = self.hilghtColor;
                self.lineView.backgroundColor = self.hilghtColor;
                iscorrect = YES;
            }
            self.wrongCode = !iscorrect;
            self.correct = iscorrect;
            break;
        }
        default:
            break;
    }
    if (text.length >= 16) {
        textField.text = [text substringToIndex:16];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(amountInputViewTextChange:)]) {
        [_delegate amountInputViewTextChange:self];
    }
}

- (NSString *)money {
    return [self.inputTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (void)setCodeType:(CNAmountType)codeType {
    _codeType = codeType;
    switch (codeType) {
        case CNAmountTypeWithdraw:{
            self.tipLb.text = @"请输入提款金额";
            self.tipLb.hidden = YES;
            self.inputTF.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        }
        default:
            break;
    }
}
@end
