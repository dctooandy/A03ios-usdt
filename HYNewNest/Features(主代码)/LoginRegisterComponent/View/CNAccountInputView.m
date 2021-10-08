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
    
    self.correct = NO; //初始化不能正确
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongAccout = YES;
    self.tipLb.hidden = NO;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}


#pragma mark - delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLb.hidden = NO;
    self.tipLb.textColor = _wrongAccout ? self.wrongColor: self.hilghtColor;
    self.lineView.backgroundColor = _wrongAccout ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.phoneLogin || self.fromServer) {
        self.correct = [textField.text validationType:ValidationTypePhone];
        if (!self.correct) {
            [self showWrongMsg:@"您输入的手机不符合规则"];
        }
    } else { //结束编辑时校验不根据长度
        if (self.isRegister) {
            self.correct = [textField.text validationType:ValidationTypeUserName];
            if (self.correct == false) {
                [self showWrongMsg:@"f开头的5-11位数字+字母组合"];
            }
        }
        else {
            self.correct = [textField.text validationType:ValidationTypeLoginName];
            if (self.correct == false) {
                [self showWrongMsg:@"f开头的5-13位数字+字母组合 或 11位手机号码"];
            }
        }
    }

    if (self.correct) {
        self.tipLb.hidden = YES;
        self.lineView.backgroundColor = self.normalColor;
        self.wrongAccout = NO;
    }

}

- (void)textFieldChange:(UITextField *)textField {
    
    // 长度优先
    if (textField.text.length > 13 && self.isRegister == false && [textField.text hasPrefix:@"f"]) {
        textField.text = [textField.text substringToIndex:13];
    }
    else if (textField.text.length > 11 && (self.isRegister == true || (self.isRegister == false && [textField.text hasPrefix:@"1"]))) {
        textField.text = [textField.text substringToIndex:11];
    }
    
    
    
    
    NSString *text = textField.text;
        
    self.lineView.backgroundColor = self.hilghtColor;
    self.tipLb.textColor = self.hilghtColor;
    
    // 这里校验是判断手机号 还是 账号
    if ((!self.isRegister && [text hasPrefix:@"1"]) || self.fromServer) {
        self.tipLb.text = @"手机号码*";
        self.phoneLogin = YES;
    } else {
        self.tipLb.text = @"用户名*";
        self.phoneLogin = NO;
    }

    // 校验
    // 手机号
    if ((self.fromServer || self.phoneLogin) && text.length >= 11) {
        self.correct = [textField.text validationType:ValidationTypePhone];
        if (!self.correct) {
            [self showWrongMsg:@"您输入的手机不符合规则"];
        }
    // 用户名
    } else if (text.length >= 5 && !self.fromServer){
        if (self.isRegister) {
            self.correct = [textField.text validationType:ValidationTypeUserName];
            if (self.correct == false) {
                [self showWrongMsg:@"f开头的5-11位数字+字母组合"];
            }
        }
        else {
            self.correct = [textField.text validationType:ValidationTypeLoginName];
            if (self.correct == false) {
                [self showWrongMsg:@"f开头的5-13位数字+字母组合 或 11位手机号码"];
            }
        }
    } else {
        self.correct = NO;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(accountInputViewTextChange:)]) {
        [_delegate accountInputViewTextChange:self];
    }
}


#pragma mark - SET & GET

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

- (void)setPlaceholder:(NSString *)text {
    self.inputTF.placeholder = text;
}



@end
