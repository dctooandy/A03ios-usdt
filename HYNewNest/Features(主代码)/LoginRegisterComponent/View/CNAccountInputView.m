//
//  CNAccountInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNAccountInputView.h"


@interface CNAccountInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;

/// 记录对错，用于UI改变风格
@property (assign, nonatomic) BOOL wrongAccout;
@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *normalColor;
@end

@implementation CNAccountInputView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongAccout = YES;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}

- (void)setPlaceholder:(NSString *)text {
    self.inputTF.placeholder = text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLb.hidden = NO;
    self.lineView.backgroundColor = _wrongAccout ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tipLb.hidden = YES;
    self.lineView.backgroundColor = self.normalColor;
}

- (void)textFieldChange:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    // 注册不需要改变
    if (!self.isRegister) {
        if (text.length == 0) {
            self.wrongAccout = NO;
            self.tipLb.text = @"";
            return;
        }
        
        if (![text hasPrefix:@"1"] && !([text hasPrefix:@"f"] || [text hasPrefix:@"F"])) {
            // 客服回拨可以输入其他符合，所以提示语修改下
            if (self.fromServer) {
                [self showWrongMsg:@"您输入的手机不符合规则*"];
            } else {
                [self showWrongMsg:@"您输入的账号不符合规则*"];
            }
            return;
        }
        
        self.lineView.backgroundColor = self.hilghtColor;
        self.tipLb.textColor = self.hilghtColor;
    }
    
    if (!self.isRegister && [text hasPrefix:@"1"]) {
        self.tipLb.text = @"手机号码*";
        self.phoneLogin = YES;
        if (text.length >= 11) {
            textField.text = [text substringToIndex:11];
        }
    } else {
        self.tipLb.text = @"用户名*";
        self.phoneLogin = NO;
        if (text.length > 12) {
            textField.text = [text substringToIndex:12];
        }
    }
    
    if (self.phoneLogin) {
        self.correct = (textField.text.length >= 11);
    } else {
        self.correct = (textField.text.length >= 5);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(accountInputViewTextChange:)]) {
        [_delegate accountInputViewTextChange:self];
    }
}

- (NSString *)account {
    return [self.inputTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString;
}

- (void)setAccount:(NSString * _Nonnull)account {
    self.inputTF.text = [account stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)setIsRegister:(BOOL)isRegister {
    _isRegister = isRegister;
    if (isRegister) {
        self.tipLb.text = @"用户名*";
    }
}

- (void)setFromServer:(BOOL)fromServer {
    _fromServer = fromServer;
    self.inputTF.keyboardType = UIKeyboardTypePhonePad;
}
@end
