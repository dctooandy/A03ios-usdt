//
//  CNNormalInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/8/3.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNNormalInputView.h"
#import "BRPickerView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface CNNormalInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) NSArray *pickerTextArr;
@property (nonatomic, copy) NSString *pickerTitleStr;
@property (nonatomic, strong) UITapGestureRecognizer *platformTap;
@end

@implementation CNNormalInputView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLb.hidden = NO;
    self.lineView.backgroundColor = _wrongAccout ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.wrongAccout) {
        self.tipLb.hidden = YES;
        self.lineView.backgroundColor = self.normalColor;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
        [_delegate inputViewDidEndEditing:self];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.inputTF.placeholder containsString:@"请输入您开卡银行"])
    {
        if (![self checkTextFieldString:string] && string.length > 0 )
        {
            [MBProgressHUD showError:@"支行名称格式错误" toView:nil];
            return NO;
        }else
        {
            return true;
        }
    }else
    {
        return true;
    }
}
- (BOOL)checkTextFieldString:(NSString *)realName {
   //中文，英文，·符号，长度2~14位
   NSString *realNameRegex = @"[a-zA-Z·\u4e00-\u9fa5]{1,100}";
   NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNameRegex];
   if (![realNamePredicate evaluateWithObject:realName]) {
       return NO;
   }
   return YES;
}
- (void)textFieldChange:(UITextField *)textField {
    // 只要已修改就去掉错误提示
    //    self.wrongAccout = NO;
    self.lineView.backgroundColor = self.hilghtColor;
    self.tipLb.textColor = self.hilghtColor;
    self.tipLb.text = self.inputTF.placeholder;
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewTextChange:)]) {
        [_delegate inputViewTextChange:self];
    }
}

- (NSString *)text {
    return [self.inputTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongAccout = YES;
    self.tipLb.hidden = NO;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}

- (void)setText:(NSString *)text {
    self.inputTF.text = text;
}

- (void)setPlaceholder:(NSString *)text {
    // 修改默认占位字符颜色
    if ([self.inputTF respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.inputTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    } else {
        self.inputTF.placeholder = text;
    }
    self.tipLb.text = text;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.inputTF.keyboardType = keyboardType;
}

- (void)editAble:(BOOL)editable {
    [self.inputTF setUserInteractionEnabled:false];
}

- (void)setTextColor:(UIColor *)color {
    [self.inputTF setTextColor:color];
}

- (void)setInputBackgoundColor: (UIColor *)color {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, CGRectGetHeight(self.inputTF.frame))];
    [leftView setBackgroundColor:[UIColor clearColor]];
    [self.inputTF setLeftView:leftView];
    [self.inputTF setBackgroundColor:color];
    self.inputTF.layer.cornerRadius = 4;
    [self.inputTF setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)setStatusToNormal {
    self.wrongAccout = false;
    self.lineView.backgroundColor = self.hilghtColor;
    self.tipLb.textColor = self.hilghtColor;
    self.tipLb.text = self.inputTF.placeholder;
}

- (void)setPrefixText: (NSString *)text {
    UILabel *prefixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(self.inputTF.frame))];
    [prefixLabel setTextColor:kHexColorAlpha(0xFFFFFF, 0.5)];
    [prefixLabel setFont:[UIFont fontPFM16]];
    [prefixLabel setText:text];
    [self.inputTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.inputTF setLeftView:prefixLabel];
}

-(void)setPicker:(NSString *)titleStr arr:(NSArray *)arr {
    self.pickerTextArr = arr;
    self.pickerTitleStr = titleStr;
    self.platformTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
    self.platformTap.numberOfTapsRequired = 1;
    [self.inputTF addGestureRecognizer:self.platformTap];
}

-(void)showPicker {
    [BRStringPickerView showStringPickerWithTitle:self.pickerTitleStr dataSource:self.pickerTextArr defaultSelValue:self.inputTF.text resultBlock:^(id selectValue, NSInteger index) {
        self.inputTF.text = selectValue;
        [self.inputTF endEditing:true];
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(pickerViewDidEndEditing:index:)]) {
            [self->_delegate pickerViewDidEndEditing:self index:index];
        }
    }];
}

-(void)removeTap {
    [self.inputTF removeGestureRecognizer:self.platformTap];
}

@end
