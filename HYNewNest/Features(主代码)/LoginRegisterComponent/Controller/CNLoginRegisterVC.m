//
//  CNLoginRegisterVC.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//  

#import "CNLoginRegisterVC.h"
#import "CNTwoStatusBtn.h"
#import "CNImageCodeInputView.h"
#import "CNAccountInputView.h"
#import "CNCodeInputView.h"
#import "CNStatementView.h"
#import "CNBindPhoneVC.h"
#import "CNForgotCodeVC.h"
#import "CNLoginSuccChooseAccountVC.h"
#import "UILabel+Gradient.h"
#import "ApiErrorCodeConst.h"
#import "HYTapHanImageCodeView.h"

#import "CNLoginRequest.h"
#import "SmsCodeModel.h"


@interface CNLoginRegisterVC () <CNAccountInputViewDelegate, CNCodeInputViewDelegate, HYTapHanImgCodeViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isLeftRightScroll;
@property (nonatomic, assign) CGPoint oldContentOffset;
@property (strong, nonatomic) IBOutlet UIScrollView *switchSV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

#pragma mark - Login Property
/// 登录账户视图
@property (weak, nonatomic) IBOutlet CNAccountInputView *loginAccountView;
/// 登录密码和验证码视图
@property (weak, nonatomic) IBOutlet CNCodeInputView *loginCodeView;
/// 登录按钮
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *loginBtn;

/// 登录图形验证码视图
@property (weak, nonatomic) IBOutlet CNImageCodeInputView *loginImageCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginImageCodeViewH;
/// 登录是否需要图形验证码
@property (assign, nonatomic) BOOL needImageCode;

/// 登录文字验证码
@property (weak, nonatomic) IBOutlet HYTapHanImageCodeView *hanImgCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hanImgCodeViewH;
/// 登录是否需要汉字图形验证码
@property (assign, nonatomic) BOOL needHanImageCode;

/// 注册文字验证码
@property (weak, nonatomic) IBOutlet HYTapHanImageCodeView *regHanImgCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regHanImgCodeViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConst0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConst;

#pragma mark - Register Property
/// 注册账户视图
@property (weak, nonatomic) IBOutlet CNAccountInputView *registerAccountView;
/// 注册密码视图
@property (weak, nonatomic) IBOutlet CNCodeInputView *registerCodeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *reRegisterCodeView;
/// 注册按钮
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *registerBtn;
/// 当前呈现是注册或登录
@property (assign, nonatomic) BOOL isRegister;

@property (nonatomic, strong) SmsCodeModel *smsModel;

@end

@implementation CNLoginRegisterVC

+ (instancetype)loginVC {
    return [[CNLoginRegisterVC alloc] init];
}

+ (instancetype)registerVC {
    CNLoginRegisterVC *vc = [[CNLoginRegisterVC alloc] init];
    vc.isRegister = YES;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.makeTranslucent = YES;
    self.navBarTransparent = YES;
    
    self.topMarginConst0.constant = self.topMarginConst.constant = kNavPlusStaBarHeight + 35;
        
    [self configUI];
    [self setDelegate];
    self.needImageCode = NO;
    self.needHanImageCode = NO;
    self.hanImgCodeView.delegate = self;
    self.regHanImgCodeView.delegate = self;
    [self preLoginAction];
}

- (void)configUI {
    [self.view addSubview:self.switchSV];
    self.view.backgroundColor = kHexColor(0x212137);
    self.registerAccountView.isRegister = YES;
    [self.registerAccountView setPlaceholder:@"请输入用户名"];
    self.registerCodeView.codeType = CNCodeTypeAccountRegister;
    [self.registerCodeView setPlaceholder:@"请输入密码"];
    self.reRegisterCodeView.codeType = CNCodeTypeAccountRegister;
    [self.reRegisterCodeView setPlaceholder:@"再次输入密码"];
    self.switchSV.frame = UIScreen.mainScreen.bounds;
    // 限制单次滚动只能在一个方向
    self.switchSV.directionalLockEnabled = YES;
    self.switchSV.delegate = self;
    self.contentWidth.constant = kScreenWidth * 2;
    if (_isRegister) {
        [self gotoRegister:nil];
        [self.regHanImgCodeView getImageCode];//direct push into register page need this
    }
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.loginAccountView.delegate = self;
    self.loginCodeView.delegate = self;
    self.registerAccountView.delegate = self;
    self.registerCodeView.delegate = self;
    self.reRegisterCodeView.delegate = self;
}

- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    if ([view isEqual:self.loginAccountView]) {
        self.loginBtn.enabled = view.correct && self.loginCodeView.correct;
        self.loginCodeView.account = view.account;
    } else {
        self.registerBtn.enabled = self.registerAccountView.correct && self.registerCodeView.correct && self.reRegisterCodeView.correct;
    }
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    if ([view isEqual:self.loginCodeView]) {
        self.loginBtn.enabled = view.correct && self.loginAccountView.correct;
    } else {
        self.registerBtn.enabled = self.registerAccountView.correct && self.registerCodeView.correct && self.reRegisterCodeView.correct;
    }
}

- (void)didReceiveSmsCodeModel:(SmsCodeModel *)model {
    self.smsModel = model;
}

#pragma mark - ButtonAction

/// DEBUG 环境 点击三次切换Domain
- (IBAction)switchEnvironmentTap:(UITapGestureRecognizer *)sender {
    [[HYNetworkConfigManager shareManager] switchEnvirnment];
}

/// 去登录页面
- (IBAction)goToLogin:(UIButton *)sender {
    [self.switchSV setContentOffset:CGPointMake(0, 0) animated:YES];
}

/// 去注册页面
- (IBAction)gotoRegister:(UIButton *)sender {
    [self.switchSV setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}


/// 忘记密码
- (IBAction)forgotPassword:(id)sender {
    CNForgotCodeVC *vc = [CNForgotCodeVC new];
    vc.bindType = CNSMSCodeTypeForgotPassword;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 声明规则
- (IBAction)statementRule:(id)sender {
    [CNStatementView show];
}

#pragma mark - Login Action

- (void)preLoginAction {
    [CNLoginRequest accountPreLoginCompletionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            PreLoginModel *model = [PreLoginModel cn_parse:responseObj];
            if (model.needCaptcha) { //需要验证码
                if (model.captchaType == 1) {
                    self.needImageCode = YES;
                    self.needHanImageCode = NO;
                } else {
                    self.needHanImageCode = YES;
                    self.needImageCode = NO;
                }
            }
        } else {
            self.needImageCode = NO;
            self.needHanImageCode = NO;
        }
    }];
}

- (IBAction)loginAction:(UIButton *)sender {
 
    NSLog(@"account=%@,code=%@,imgCode=%@", self.loginAccountView.account, self.loginCodeView.code, self.loginImageCodeView.imageCode);

    // 账号登录
    if (self.needImageCode) {
        if (self.loginImageCodeView.imageCode.length == 0) {
            [CNHUB showError:@"请输入图形验证码"];
            return;
        }
    }
    
    [self Login];
}

/// 登录
- (void)Login {
    /* 为防止漏掉情况走到这里，需要再次检验格式 */
    // 账号
    NSString *account = self.loginAccountView.account;
    if (self.loginAccountView.phoneLogin) {
        if (![account validationType:ValidationTypePhone]) {
            [self.loginAccountView showWrongMsg:@"您输入的手机不符合规则"];
            return;
        }
    } else {
        if (![account validationType:ValidationTypeUserName]) {
            [self.loginAccountView showWrongMsg:@"f开头的5-11位数字+字母组合"];
            return;
        }
    }
    
    // 密码
    NSString *code = self.loginCodeView.code;
    if (self.loginAccountView.phoneLogin) {
        if (code.length < 6) {
            [self.loginCodeView showWrongMsg:@"请输入6位验证码"];
            return;
        }
    } else {
        if (![code validationType:ValidationTypePassword]) {
            [self.loginCodeView showWrongMsg:@"请输入8-16位数字及字母的组合"];
            return;
        }
    }
    
    // 校验码
    NSString *captcha = @""; //or ticket
    NSString *captchaId = @"";
    if (self.needImageCode) {
        if (!self.loginImageCodeView.correct) {
            [CNHUB showError:@"请输入图片中的数字验证码"];
            return;
        }
        captcha = self.loginImageCodeView.imageCode;
        captchaId = self.loginImageCodeView.imageCodeId;
    } else if (self.needHanImageCode) {
        if (!self.hanImgCodeView.correct) {
            [CNHUB showError:@"请按正确顺序点击图片中的文字"];
            return;
        }
        captcha = self.hanImgCodeView.ticket;
        captchaId = self.hanImgCodeView.imageCodeId;
    }
    
    WEAKSELF_DEFINE
    [CNLoginRequest accountLogin:account
                        password:code
                       messageId:self.smsModel.messageId
                       imageCode:captcha
                     imageCodeId:captchaId
               completionHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg) {
            // 判断多账号调用多账号登录
            if ([responseObj objectForKey:@"samePhoneLoginNames"]) {
                CNLoginSuccChooseAccountVC *vc = [CNLoginSuccChooseAccountVC new];
                vc.samePhoneLogNameModel = [SamePhoneLoginNameModel cn_parse:responseObj];
                [strongSelf.navigationController pushViewController:vc animated:YES];
                
            } else {
                [CNHUB showSuccess:@"登录成功"];
                if (![NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        } else {
            if ([responseObj isEqualToString:LoginPassExpired_ErrorCode]) {
                [HYTextAlertView showWithTitle:@"账号激活" content:@"由于我们检测到您的该账号长时间没有登录，请您修改密码。" comfirmText:@"修改密码" cancelText:nil comfirmHandler:^(BOOL isComfirm) {
                    CNForgotCodeVC *vc = [CNForgotCodeVC new];
                    vc.bindType = CNSMSCodeTypeForgotPassword;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            } else {
                [self preLoginAction];
            }
        }
    }];
}

/// 汉字验证码成功
- (void)validationDidSuccess {
    if (self.switchSV.contentOffset.x > 0) {
        self.regHanImgCodeViewH.constant = 47;
        [self.regHanImgCodeView showSuccess];
    } else {
        self.hanImgCodeViewH.constant = 47;
        [self.hanImgCodeView showSuccess];
    }

}


#pragma mark - Register Action

- (IBAction)registerAction:(UIButton *)sender {
    if (![self.registerCodeView.code isEqualToString:self.reRegisterCodeView.code]) {
        [self.reRegisterCodeView showWrongMsg:@"两次输入密码不一致 请重新输入"];
        return;
    }
    
    if (!self.regHanImgCodeView.correct) {
        [CNHUB showError:@"请按正确顺序点击图片中的文字"];
        return;
    }
    NSString * captcha = self.regHanImgCodeView.ticket;
    NSString * captchaId = self.regHanImgCodeView.imageCodeId;
    
    [CNLoginRequest accountRegisterUserName:self.registerAccountView.account
                                   password:self.registerCodeView.code
                                    captcha:captcha
                                  captchaId:captchaId
                          completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNHUB showSuccess:@"注册成功"];
            CNBindPhoneVC *vc = [CNBindPhoneVC new];
            vc.bindType = CNSMSCodeTypeRegister;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.regHanImgCodeView getImageCode];
            self.regHanImgCodeViewH.constant = 95;
        }
    }];
}

/// 限制只能垂直滚动不能左右滚动
#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
    self.oldContentOffset = scrollView.contentOffset;
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
    // 此时是左右滑动
    if (scrollView.contentOffset.x != self.oldContentOffset.x) {
        self.isLeftRightScroll = YES; // 标记是左右滑动 -》刷新对应验证码
        scrollView.pagingEnabled = YES;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,
        0);
    }
    // 此时是上下滑动
    else {
        scrollView.pagingEnabled = NO;
    }
}

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
    self.oldContentOffset = scrollView.contentOffset;
    
    if (self.isLeftRightScroll) {
        [self updateHanCodesStatus];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.oldContentOffset = scrollView.contentOffset;
    
    if (self.isLeftRightScroll) {
         [self updateHanCodesStatus];
    }
}

- (void)updateHanCodesStatus {
    self.isLeftRightScroll = NO;
    if (self.switchSV.contentOffset.x > 200) { // zhuceye
        self.regHanImgCodeViewH.constant = 95;
        [self.regHanImgCodeView getImageCode];
    } else {
        if (self.needHanImageCode) {
            self.hanImgCodeViewH.constant = 95;
            [self.hanImgCodeView getImageCode];
        } else if (self.needImageCode) {
            self.loginImageCodeView.hidden = NO;
            self.loginImageCodeViewH.constant = 75;
            [self.loginImageCodeView getImageCode];
        }
    }
    
}


#pragma mark - Setter & Getter

- (void)setNeedImageCode:(BOOL)needImageCode {
    _needImageCode = needImageCode;
    if (needImageCode) {
        self.loginImageCodeView.hidden = NO;
        self.loginImageCodeViewH.constant = 75;
        [self.loginImageCodeView getImageCode];
    }
}

- (void)setNeedHanImageCode:(BOOL)needHanImageCode {
    _needHanImageCode = needHanImageCode;
    if (needHanImageCode) {
        self.hanImgCodeView.hidden = NO;
        self.hanImgCodeViewH.constant = 95;
        [self.hanImgCodeView getImageCode];
    }
}


@end
