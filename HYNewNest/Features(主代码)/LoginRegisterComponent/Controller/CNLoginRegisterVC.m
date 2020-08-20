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

#import "CNLoginRequest.h"
#import "SmsCodeModel.h"


/// 最大允许登录错误次数
NSInteger AllowTotalWrongCount = 3;

@interface CNLoginRegisterVC () <CNAccountInputViewDelegate, CNCodeInputViewDelegate>

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

@property (nonatomic, assign) NSInteger wrongCount;
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
    self.wrongCount = 0;
    self.topMarginConst0.constant = self.topMarginConst.constant = kNavPlusStaBarHeight + 52;
    
    
    self.navBarTransparent = YES;
    self.makeTranslucent = YES;
    
    [self configUI];
    [self setDelegate];
    self.needImageCode = NO;
    
}

- (void)configUI {
    [self.view addSubview:self.switchSV];
    self.view.backgroundColor = kHexColor(0x212137);
    self.registerAccountView.isRegister = YES;
    [self.registerAccountView setPlaceholder:@"用户名"];
    self.registerCodeView.codeType = CNCodeTypeAccountRegister;
    [self.registerCodeView setPlaceholder:@"输入密码"];
    self.reRegisterCodeView.codeType = CNCodeTypeAccountRegister;
    [self.reRegisterCodeView setPlaceholder:@"再次输入密码"];
    self.switchSV.frame = UIScreen.mainScreen.bounds;
    self.contentWidth.constant = kScreenWidth * 2;
    if (_isRegister) {
        [self gotoRegister:nil];
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
    [self.switchSV setContentOffset:CGPointMake(0, 0)];
}

/// 去注册页面
- (IBAction)gotoRegister:(UIButton *)sender {
    [self.switchSV setContentOffset:CGPointMake(kScreenWidth, 0)];
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
    WEAKSELF_DEFINE
    [CNLoginRequest accountLogin:self.loginAccountView.account
                        password:self.loginCodeView.code
                       messageId:self.smsModel.messageId
                       imageCode:self.loginImageCodeView.imageCode.length>0?self.loginImageCodeView.imageCode:@""
                     imageCodeId:self.loginImageCodeView.imageCodeId.length>0?self.loginImageCodeView.imageCodeId:@""
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
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        } else {
            if ([responseObj isEqualToString:LoginPassExpired_ErrorCode]) {
                [HYTextAlertView showWithTitle:@"账号激活" content:@"由于我们检测到您的该账号长时间没有登录，请您修改密码。" comfirmText:@"修改密码" cancelText:nil comfirmHandler:^(BOOL isComfirm) {
                    CNForgotCodeVC *vc = [CNForgotCodeVC new];
                    vc.bindType = CNSMSCodeTypeForgotPassword;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            } else if ([responseObj isEqualToString:ImageCodeNULL_ErrorCode]) {
                strongSelf.wrongCount = 3;
            } else {
                strongSelf.wrongCount += 1;
            }
        }
    }];
}



#pragma mark - Register Action

- (IBAction)registerAction:(UIButton *)sender {
    [CNLoginRequest accountRegisterUserName:self.registerAccountView.account password:self.registerCodeView.code completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNHUB showSuccess:@"注册成功"];
            CNBindPhoneVC *vc = [CNBindPhoneVC new];
            vc.bindType = CNSMSCodeTypeRegister;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
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

- (void)setWrongCount:(NSInteger)wrongCount {
    _wrongCount = wrongCount;
    self.needImageCode = (wrongCount >= AllowTotalWrongCount);
}

@end
