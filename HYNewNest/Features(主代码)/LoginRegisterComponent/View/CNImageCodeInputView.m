//
//  CNImageCodeInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNImageCodeInputView.h"
#import "CNImageCodeModel.h"
#import "CNLoginRequest.h"

@interface CNImageCodeInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) CNImageCodeModel *codeModel;

@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *normalColor;
@end

@implementation CNImageCodeInputView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lineView.backgroundColor = self.hilghtColor;
    self.tipLb.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.lineView.backgroundColor = self.normalColor;
    self.tipLb.hidden = YES;
}

- (void)textFieldChange:(UITextField *)textField {
    NSString *text = textField.text;
    _correct = (text.length > 3);
    if (_delegate && [_delegate respondsToSelector:@selector(imageCodeViewTextChange:)]) {
        [_delegate imageCodeViewTextChange:self];
    }
}

- (NSString *)imageCode {
    return [self.inputTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)imageCodeId {
    return self.codeModel.captchaId;
}

- (IBAction)sendCode:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    sender.enabled = NO;
    [CNLoginRequest getImageCodeWithType:CNImageCodeTypeLogin completionHandler:^(id responseObj, NSString *errorMsg) {
        sender.enabled = YES;
        if (!errorMsg) {
            weakSelf.codeModel = [CNImageCodeModel cn_parse:responseObj];
            [sender setImage:weakSelf.codeModel.decodeImage forState:UIControlStateNormal];
            [weakSelf setHidden:NO];
        }
    }];
}


- (void)getImageCode {
    [self sendCode:self.codeBtn];
}
@end
