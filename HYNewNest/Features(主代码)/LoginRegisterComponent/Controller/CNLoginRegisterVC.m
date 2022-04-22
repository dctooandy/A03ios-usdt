//
//  CNLoginRegisterVC.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//  

#import "CNLoginRegisterVC.h"
#import "CNBindPhoneVC.h"
#import "CNForgotCodeVC.h"
#import "CNLoginSuccChooseAccountVC.h"
#import "StatusDetailViewController.h"

#import "CNTwoStatusBtn.h"
#import "CNImageCodeInputView.h"
#import "CNAccountInputView.h"
#import "CNCodeInputView.h"
#import "CNStatementView.h"
#import "HYTapHanImageCodeView.h"
#import "CNVerifyMsgAlertView.h"
#import "HYTextAlertView.h"

#import "IVCNetworkStatusView.h"
#import "CNLoginRequest.h"
#import "SmsCodeModel.h"

#import "ApiErrorCodeConst.h"
#import "UILabel+Gradient.h"
#import "CNPushRequest.h"
#import "PuzzleVerifyPopoverView.h"

static CGFloat const CNCodeImageHeight = 75.0;
static CGFloat const CNHanCodeImageHeight = 95.0;
static CGFloat const CNPuzzleCodeImageHeight = 131.0;

@interface CNLoginRegisterVC () <CNAccountInputViewDelegate, CNCodeInputViewDelegate, HYTapHanImgCodeViewDelegate, PuzzleVerifyPopoverViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isLeftRightScroll;
@property (nonatomic, assign) CGPoint oldContentOffset;
@property (strong, nonatomic) IBOutlet UIScrollView *switchSV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (strong,nonatomic) UIButton *rightNavBtn;

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

/// 登录文字验证码
@property (weak, nonatomic) IBOutlet HYTapHanImageCodeView *hanImgCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hanImgCodeViewH;

@property (strong, nonatomic) PreLoginModel *loginCaptchaModel;
@property (strong, nonatomic) PreLoginModel *regiCaptchModel;

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
/// 注册按钮
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *registerBtn;
/// 当前呈现是注册或登录
@property (assign, nonatomic) BOOL isRegister;

@property (nonatomic, strong) SmsCodeModel *smsModel;
@property (nonatomic, strong) SmsCodeModel *diffRgonSmsModel;

@property (nonatomic, weak) IBOutlet PuzzleVerifyPopoverView *loginPuzzleView;
@property (nonatomic, weak) IBOutlet PuzzleVerifyPopoverView *regiPuzzleView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginPuzzleViewConstH;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *regiPuzzleViewConstH;

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


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.makeTranslucent = YES;
    self.navBarTransparent = YES;
    
    self.topMarginConst0.constant = self.topMarginConst.constant = kNavPlusStaBarHeight + 35;
        
    [self configUI];
    [self setDelegate];
    self.hanImgCodeView.delegate = self;
    self.regHanImgCodeView.delegate = self;
    [self preLoginRegisterAction];
}

- (void)configUI {
    [self.view addSubview:self.switchSV];
    self.view.backgroundColor = kHexColor(0x212137);
    
    UIButton *rightTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightTopBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [rightTopBtn setTitle:@"去注册" forState:UIControlStateNormal];
    rightTopBtn.titleLabel.font = [UIFont fontPFM16];
    [rightTopBtn setAdjustsImageWhenHighlighted:NO];
    [rightTopBtn setTitleColor:kHexColorAlpha(0xFFFFFF, 0.6) forState:UIControlStateNormal];
    [rightTopBtn jk_setImagePosition:LXMImagePositionRight spacing:5];
    [rightTopBtn addTarget:self action:@selector(goToLogInOrRegister) forControlEvents:UIControlEventTouchUpInside];
    self.rightNavBtn = rightTopBtn;
    [self addNaviRightItemButton:rightTopBtn];
    
    self.registerAccountView.isRegister = YES;
    [self.registerAccountView setPlaceholder:@"请输入用户名"];
    self.registerCodeView.codeType = CNCodeTypeAccountRegister;
    [self.registerCodeView setPlaceholder:@"请输入密码"];
    
    self.switchSV.frame = UIScreen.mainScreen.bounds;
    // 限制单次滚动只能在一个方向
    self.switchSV.directionalLockEnabled = YES;
    self.switchSV.delegate = self;
    self.contentWidth.constant = kScreenWidth * 2;
    
    // 如果是注册进来的去注册页
    if (_isRegister) {
        [self goToLogInOrRegister];
    }
}


#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.loginAccountView.delegate = self;
    self.loginCodeView.delegate = self;
    self.registerAccountView.delegate = self;
    self.registerCodeView.delegate = self;
//    self.reRegisterCodeView.delegate = self;
}

- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    if ([view isEqual:self.loginAccountView]) {
        self.loginBtn.enabled = view.correct && self.loginCodeView.correct;
        self.loginCodeView.account = view.account;
    } else {
        self.registerBtn.enabled = self.registerAccountView.correct && self.registerCodeView.correct;
    }
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    if ([view isEqual:self.loginCodeView]) {
        if (view.code.length > 6) {
            view.codeType = CNCodeTypeAccountLogin;
        }
        self.loginBtn.enabled = view.correct && self.loginAccountView.correct;
    } else {
        self.registerBtn.enabled = self.registerAccountView.correct && self.registerCodeView.correct;
    }
}

- (void)didReceiveSmsCodeModel:(SmsCodeModel *)model {
    self.smsModel = model;
}

#pragma mark - PuzzleVerifyPopoverViewDelegate

- (void)puzzleViewVerifySuccess:(PuzzleVerifyPopoverView *)puzzleView {
    puzzleView.hidden = YES;
    if ([puzzleView isEqual:self.loginPuzzleView]) {
        self.loginPuzzleViewConstH.constant = 0;
        self.hanImgCodeViewH.constant = 0;
    } else if ([puzzleView isEqual:self.regiPuzzleView]) {
        self.regiPuzzleViewConstH.constant = 0;
        self.regHanImgCodeViewH.constant = 0;
    }
}

#pragma mark - ButtonAction

/// DEBUG 环境 点击三次切换Domain
- (IBAction)switchEnvironmentTap:(UITapGestureRecognizer *)sender {
    [[HYNetworkConfigManager shareManager] switchEnvirnment];
}


/// 切换页面
- (void)goToLogInOrRegister {
    // 去注册页面
    if (self.switchSV.contentOffset.x <= 0) {
        [self.switchSV setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        self.isRegister = YES;
    } else {
        [self.switchSV setContentOffset:CGPointMake(0, 0) animated:YES];
        self.isRegister = NO;
    }
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

/// 网络检测
- (IBAction)checkNetworking:(id)sender {
    IVCNetworkStatusView *statusView = [[IVCNetworkStatusView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    statusView.detailBtnClickedBlock = ^{
        StatusDetailViewController *vc = [[StatusDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [kKeywindow addSubview:statusView];
    [statusView startCheck];
}


#pragma mark - Login Action

- (void)preLoginRegisterAction {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self preLogin:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self preCreateAccount:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self updateNeedCaptchUI];
    });
}

- (void)preLogin:(void(^)(void))completion {
    [CNLoginRequest accountPreLoginCompletionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            PreLoginModel *model = [PreLoginModel cn_parse:responseObj];
            self.loginCaptchaModel = model;
        }
        !completion?:completion();
    }];
}

- (void)preCreateAccount:(void(^)(void))completion {
    [CNLoginRequest accountpreCreateAccountCompletionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            PreLoginModel *model = [PreLoginModel cn_parse:responseObj];
            self.regiCaptchModel = model;
        }
        !completion?:completion();
    }];
}

- (void)preLoginAction {
    [self preLogin:nil];
}

- (void)preCreateAccount {
    [self preCreateAccount:nil];
}

#pragma mark - IBAction

- (IBAction)loginAction:(UIButton *)sender {
 
    NSLog(@"account=%@,code=%@,imgCode=%@", self.loginAccountView.account, self.loginCodeView.code, self.loginImageCodeView.imageCode);

    // 账号登录
    if (self.loginCaptchaModel.captchaType == CNCaptchaTypeDigital) {
        if (self.loginImageCodeView.imageCode.length == 0) {
            [CNTOPHUB showError:@"请输入图形验证码"];
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
        if (![account validationType:ValidationTypeLoginName]) {
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
    if (self.loginCaptchaModel.captchaType == CNCaptchaTypeDigital) {
        if (!self.loginImageCodeView.correct) {
            [CNTOPHUB showError:@"请输入图片中的数字验证码"];
            return;
        }
        captcha = self.loginImageCodeView.imageCode;
        captchaId = self.loginImageCodeView.imageCodeId;
    } else if (self.loginCaptchaModel.captchaType == CNCaptchaTypeChinese) {
        if (!self.hanImgCodeView.correct) {
            [CNTOPHUB showError:@"请按正确顺序点击图片中的文字"];
            return;
        }
        captcha = self.hanImgCodeView.ticket;
        captchaId = self.hanImgCodeView.imageCodeId;
    } else if (self.loginCaptchaModel.captchaType == CNCaptchaTypePuzzle) {
        if (!self.loginPuzzleView.correct) {
            [CNTOPHUB showError:@"请拖动滑块完成拼图验证"];
            return;
        }
        captcha = self.loginPuzzleView.ticket;
        captchaId = self.loginPuzzleView.captchaId;
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
            if (responseObj[@"samePhoneLoginNames"] || responseObj[@"loginNames"] ) {
                SamePhoneLoginNameModel *model = [SamePhoneLoginNameModel cn_parse:responseObj];
                NSMutableArray *names = model.samePhoneLoginNames.mutableCopy;
                for (SamePhoneLoginNameItem *item in model.samePhoneLoginNames) {
                    if ([item.loginName hasPrefix:@"g"] || [item.loginName hasPrefix:@"G"]) {
                        [names removeObject:item];
                    }
                }
                model.samePhoneLoginNames = names;
                if (model.samePhoneLoginNames.count == 0){
                    [weakSelf unLoginAction];/// 禁止登入
                }
                else if (model.samePhoneLoginNames.count > 1) {
                    CNLoginSuccChooseAccountVC *vc = [CNLoginSuccChooseAccountVC new];
                    vc.samePhoneLogNameModel = model;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                else {
                    [CNLoginRequest mulLoginSelectedLoginName:model.samePhoneLoginNames.firstObject.loginName
                                                    messageId:model.messageId
                                                   validateId:model.validateId
                                            completionHandler:^(id responseObj, NSString *errorMsg) {
                        if (!errorMsg) {
                            if ([NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) { // 如果无法pop回homepage 则直接pop回上一级
                                [[NNControllerHelper currentTabBarController] performSelector:@selector(showSuspendBall)];
                            } else {
                                [strongSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    }];                }
            } else if (responseObj[@"loginName"]) {
                NSString *loginString = responseObj[@"loginName"];
                if ([loginString hasPrefix:@"g"] || [loginString hasPrefix:@"G"]) {
                    [weakSelf unLoginAction];/// 禁止登入
                }else
                {
                    [weakSelf shouldLoginAction:responseObj];
//                    [CNTOPHUB showSuccess:@"登录成功"];
//                    [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
//                    [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
//                        [CNPushRequest GTInterfaceHandler:nil];
//                    }];
//                    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id response, NSString *error) {
//                        if ([NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) { // 如果无法pop回homepage 则直接pop回上一级
//                            [[NNControllerHelper currentTabBarController] performSelector:@selector(showSuspendBall)];
//                        } else {
//                            [strongSelf.navigationController popViewControllerAnimated:YES];
//                        }
//                    }];
                }
            } else {
                [weakSelf shouldLoginAction:responseObj];
//                [CNTOPHUB showSuccess:@"登录成功"];
//                [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
//                [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
//                    [CNPushRequest GTInterfaceHandler:nil];
//                }];
//                [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id response, NSString *error) {
//                    if ([NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) { // 如果无法pop回homepage 则直接pop回上一级
//                        [[NNControllerHelper currentTabBarController] performSelector:@selector(showSuspendBall)];
//                    } else {
//                        [strongSelf.navigationController popViewControllerAnimated:YES];
//                    }
//                }];
            }
            
        } else {
            if ([errorMsg isEqualToString:LoginRegionRisk_ErroCode]) {
               self.diffRgonSmsModel = [SmsCodeModel cn_parse:responseObj]; //异地登录验证码
                
                CNVerifyMsgAlertView * alertView = [CNVerifyMsgAlertView showRegionPhone:self.diffRgonSmsModel.mobileNo
                                                                              reSendCode:^{
                    [self sendDiffRegionVerifyCode]; // 重新发送
                } finish:^(NSString * _Nonnull smsCode) {
                    self.diffRgonSmsModel.smsCode = smsCode;
                    [self verifyRegionCode]; //校验验证码
                }];
                alertView.onCancelAction = ^{
                    self.hanImgCodeViewH.constant = CNHanCodeImageHeight;
                    [self.hanImgCodeView getImageCodeForceRefresh:YES];
                };
              
               
            } else if ([responseObj isEqualToString:LoginPassExpired_ErrorCode]) {
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
- (void)unLoginAction {
    [CNTOPHUB showError:@"该帐号类型禁止登录"];
    [self preLoginAction];
}

- (void)shouldLoginAction:(NSDictionary *)responseObj {
    WEAKSELF_DEFINE
    [CNTOPHUB showSuccess:@"登录成功"];
    [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
    [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
        [CNPushRequest GTInterfaceHandler:nil];
    }];
    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id response, NSString *error) {
        if ([NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) { // 如果无法pop回homepage 则直接pop回上一级
            [[NNControllerHelper currentTabBarController] performSelector:@selector(showSuspendBall)];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
/// 汉字验证码成功
- (void)validationDidSuccess {
    if (self.isRegister) {
        self.regHanImgCodeViewH.constant = 0;//47
        [self.regHanImgCodeView showSuccess];
    } else {
        self.hanImgCodeViewH.constant = 0;//47
        [self.hanImgCodeView showSuccess];
    }

}

/// 发送异地登陆验证码
- (void)sendDiffRegionVerifyCode {
    [CNLoginRequest getSMSCodeByLoginName:self.diffRgonSmsModel.loginName completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            self.diffRgonSmsModel = [SmsCodeModel cn_parse:responseObj]; //异地登录验证码
        }
    }];
}

- (void)verifyRegionCode {
    [CNLoginRequest verifyLoginWith2FALoginName:self.diffRgonSmsModel.loginName
                                        smsCode:self.diffRgonSmsModel.smsCode
                                      messageId:self.diffRgonSmsModel.messageId
                              completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNVerifyMsgAlertView removeAlertView];
            [CNTOPHUB showSuccess:@"登录成功"];
            if (![NNControllerHelper pop2ViewControllerClassString:@"CNHomeVC"]) { // 如果无法pop回homepage 则直接pop回上一级
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}


#pragma mark - Register Action

- (IBAction)registerAction:(UIButton *)sender {
    
    NSString *captcha;
    NSString *captchaId;
    switch (self.regiCaptchModel.captchaType) {
        case CNCaptchaTypeChinese:
            if (!self.regHanImgCodeView.correct) {
                [CNTOPHUB showError:@"请按正确顺序点击图片中的文字"];
                return;
            }
            captcha = self.regHanImgCodeView.ticket;
            captchaId = self.regHanImgCodeView.imageCodeId;
            break;
        case CNCaptchaTypePuzzle:
            if (!self.regiPuzzleView.correct) {
                [CNTOPHUB showError:@"请拖动滑块完成拼图验证"];
                return;
            }
            captcha = self.regiPuzzleView.ticket;
            captchaId = self.regiPuzzleView.captchaId;
            break;
        default:
            break;
    }
    
    [CNLoginRequest accountRegisterUserName:self.registerAccountView.account
                                   password:self.registerCodeView.code
                                    captcha:captcha
                                  captchaId:captchaId
                          completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNTOPHUB showSuccess:@"注册成功"];
            CNBindPhoneVC *vc = [CNBindPhoneVC new];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            switch (self.regiCaptchModel.captchaType) {
                case CNCaptchaTypeDigital:
                    break;
                case CNCaptchaTypeChinese:
                    self.regHanImgCodeView.hidden = NO;
                    self.regHanImgCodeViewH.constant = CNHanCodeImageHeight;
                    [self.regHanImgCodeView getImageCodeForceRefresh:YES];
                    break;
                case CNCaptchaTypePuzzle:
                    self.regHanImgCodeViewH.constant = CNPuzzleCodeImageHeight;
                    self.regiPuzzleViewConstH.constant = CNPuzzleCodeImageHeight;
                    self.regHanImgCodeView.hidden = YES;
                    self.regiPuzzleView.hidden = NO;
                    [self.regiPuzzleView getPuzzleImageCodeForceRefresh:YES];
                    break;
                default:
                    break;
            }
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
        self.isRegister = scrollView.contentOffset.x >= kScreenWidth;
    }
    // 此时是上下滑动
    else {
        scrollView.pagingEnabled = NO;
    }
}

// 靠手动滑动会进入这里
- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
    self.oldContentOffset = scrollView.contentOffset;
    
    if (self.isLeftRightScroll) {
        [self updateHanCodesStatus];
    }
    
}

// 靠代码移动会进入这里
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.oldContentOffset = scrollView.contentOffset;
    
    if (self.isLeftRightScroll) {
         [self updateHanCodesStatus];
    }
}

- (void)updateHanCodesStatus {
    self.isLeftRightScroll = NO;
    if (self.isRegister) {
        switch (self.regiCaptchModel.captchaType) {
            case CNCaptchaTypeChinese:
                if (!self.regHanImgCodeView.correct) {
                    self.regHanImgCodeView.hidden = NO;
                    self.regHanImgCodeViewH.constant = CNHanCodeImageHeight;
                    [self.regHanImgCodeView getImageCodeForceRefresh:NO];
                }
                break;
            case CNCaptchaTypePuzzle:
                if (!self.regiPuzzleView.correct) {
                    self.regHanImgCodeViewH.constant = CNPuzzleCodeImageHeight;
                    self.regiPuzzleViewConstH.constant = CNPuzzleCodeImageHeight;
                    self.regHanImgCodeView.hidden = YES;
                    self.regiPuzzleView.hidden = NO;
                    [self.regiPuzzleView getPuzzleImageCodeForceRefresh:NO];
                }
                break;
            default:
                break;
        }
        [self.rightNavBtn setTitle:@"去登录" forState:UIControlStateNormal];
    } else {
        switch (self.loginCaptchaModel.captchaType) {
            case CNCaptchaTypeDigital:
                if (!self.loginImageCodeView.correct) {
                    self.loginImageCodeView.hidden = NO;
                    self.loginImageCodeViewH.constant = CNCodeImageHeight;
                    [self.loginImageCodeView getImageCode];
                }
                break;
            case CNCaptchaTypeChinese:
                if (!self.hanImgCodeView.correct) {
                    self.hanImgCodeViewH.constant = CNHanCodeImageHeight;
                    [self.hanImgCodeView getImageCodeForceRefresh:NO];
                }
                break;
            case CNCaptchaTypePuzzle:
                if (!self.loginPuzzleView.correct) {
                    self.hanImgCodeViewH.constant = CNPuzzleCodeImageHeight;
                    self.loginPuzzleViewConstH.constant = CNPuzzleCodeImageHeight;
                    self.hanImgCodeView.hidden = YES;
                    self.loginImageCodeView.hidden = YES;
                    self.loginPuzzleView.hidden = NO;
                    [self.loginPuzzleView getPuzzleImageCodeForceRefresh:NO];
                }
                break;
            default:
                break;
        }
        [self.rightNavBtn setTitle:@"去注册" forState:UIControlStateNormal];
    }
    
}

- (void)updateNeedCaptchUI {
    if (self.loginCaptchaModel == nil) {
        self.loginImageCodeView.hidden = YES;
        self.hanImgCodeView.hidden = YES;
        self.loginPuzzleView.hidden = YES;
        self.loginImageCodeViewH.constant = 0;
        self.hanImgCodeViewH.constant = 0;
        self.loginPuzzleViewConstH.constant = 0;
    } else {
        self.loginPuzzleView.viewModel.codeType = CNImageCodeTypeLogin;
        switch (self.loginCaptchaModel.captchaType) {
            case CNCaptchaTypeDigital:
                self.loginImageCodeView.hidden = NO;
                self.loginImageCodeViewH.constant = CNCodeImageHeight;
                [self.loginImageCodeView getImageCode];
                break;
            case CNCaptchaTypeChinese:
                self.hanImgCodeView.hidden = NO;
                self.hanImgCodeViewH.constant = CNHanCodeImageHeight;
                [self.hanImgCodeView getImageCodeForceRefresh:YES];
                break;
            case CNCaptchaTypePuzzle:
                self.hanImgCodeViewH.constant = CNPuzzleCodeImageHeight;
                self.loginPuzzleViewConstH.constant = CNPuzzleCodeImageHeight;
                self.hanImgCodeView.hidden = YES;
                self.loginPuzzleView.hidden = NO;
                self.loginPuzzleView.delegate = self;
                [self.loginPuzzleView getPuzzleImageCodeForceRefresh:YES];
                break;
                
            default:
                break;
        }
    }
    
    if (self.regiCaptchModel == nil) {
        self.regHanImgCodeView.hidden = YES;
        self.regiPuzzleView.hidden = YES;
        self.regHanImgCodeViewH.constant = 0;
        self.regiPuzzleViewConstH.constant = 0;
    } else {
        self.regiPuzzleView.viewModel.codeType = CNImageCodeTypeRegister;
        switch (self.regiCaptchModel.captchaType) {
            case CNCaptchaTypeDigital:
                break;
            case CNCaptchaTypeChinese:
                self.regHanImgCodeView.hidden = NO;
                self.regHanImgCodeViewH.constant = CNHanCodeImageHeight;
                [self.hanImgCodeView getImageCodeForceRefresh:YES];
                break;
            case CNCaptchaTypePuzzle:
                self.regiPuzzleViewConstH.constant = CNPuzzleCodeImageHeight;
                self.regHanImgCodeViewH.constant = CNPuzzleCodeImageHeight;
                self.regHanImgCodeView.hidden = YES;
                self.regiPuzzleView.hidden = NO;
                self.regiPuzzleView.delegate = self;
                [self.regiPuzzleView getPuzzleImageCodeForceRefresh:YES];
                break;
            default:
                break;
        }
    }
}


@end
