//
//  CNRechargeChosePayTypeVC.m
//  HYNewNest
//
//  Created by Cean on 2020/8/12.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNRechargeChosePayTypeVC.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"
#import "SGQRCodeGenerateManager.h"
#import "CNTradeRecodeVC.h"

@interface CNRechargeChosePayTypeVC ()

@property (weak, nonatomic) IBOutlet UIButton *qrBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewH;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
/// 金额
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
/// 银行名称
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
/// 卡号
@property (weak, nonatomic) IBOutlet UILabel *cardNoLb;
/// 账户名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
/// 银行支行
@property (weak, nonatomic) IBOutlet UILabel *subBankNameLb;
/// 银行logo
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
/// 二维码
@property (weak, nonatomic) IBOutlet UIImageView *qrIcon;
/// 银行卡信息
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *tipLb;

@property (nonatomic, strong) BQPaymentModel *model;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;
@end

@implementation CNRechargeChosePayTypeVC

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)countDown {
    self.seconds --;
    self.timeLb.text = [NSString stringWithFormat:@"%02ld:%02ld", _seconds/60, _seconds%60];
    if (_seconds <= 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - View Life

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithModel:(BQPaymentModel *)model {
    self = [super init];
    _model = model;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    
    NSString *countDown_MMss = _model.payLimitTime;
    self.timeLb.text = countDown_MMss;
    NSInteger min = [[countDown_MMss componentsSeparatedByString:@":"].firstObject integerValue];
    NSInteger sec = [[countDown_MMss componentsSeparatedByString:@":"].lastObject integerValue];
    self.seconds = min * 60 + sec;
    [self.timer fire];
    
    self.amountLb.text = [NSString stringWithFormat:@"%@", _model.amount];
    self.bankNameLb.text = _model.bankName;
    [self.bankLogoIV sd_setImageWithURL:[NSURL getUrlWithString:_model.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
    self.cardNoLb.text = _model.accountNo;
    self.accountNameLb.text = _model.accountName;
    self.subBankNameLb.text = _model.bankBranchName;
    
    if (!KIsEmptyString(_model.qrCode)) {
        self.qrIcon.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:_model.qrCode imageViewWidth:self.qrIcon.height];
        self.bankView.hidden = YES;
    } else {
        self.tagsViewH.constant = 0;
        self.tagsView.hidden = YES;
        self.qrIcon.hidden = YES;
    }
    
    switch ([_model.payWayType integerValue]) {
        case 0:
            [self.btnSubmit setTitle:@"启动支付宝客户端" forState:UIControlStateNormal];
            [self.btnSubmit setImage:[UIImage imageNamed:@"Icon Alipay"] forState:UIControlStateNormal];
            self.tipLb.text = @"温馨提示：修改金额和重复支付订单无效，支付宝提示到账时间为2小时，实际到账时间为3-5分钟，请放心支付。";
            break;
        case 1:
            [self.btnSubmit setTitle:@"启动微信支付" forState:UIControlStateNormal];
            [self.btnSubmit setImage:[UIImage imageNamed:@"Icon Alipay Copy"] forState:UIControlStateNormal];
            self.tipLb.text = @"温馨提示：修改金额和重复支付订单无效，微信提示到账时间为2小时，实际到账时间为3-5分钟，请放心支付。";
            break;
        case 2:
            [self.btnSubmit setTitle:@"完成支付" forState:UIControlStateNormal];
            self.tipLb.text = @"温馨提示：可登录您的网银账号，汇款到此账号。";
            break;
        default:
            break;
    }
}


#pragma - mark 按钮事件
 
// 扫码支付
- (IBAction)qrPay:(UIButton *)sender {
    sender.selected = YES;
    self.cardBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    
    self.bankView.hidden = YES;
    self.qrIcon.hidden = NO;
}

// 卡号支付
- (IBAction)cardPay:(UIButton *)sender {
    sender.selected = YES;
    self.qrBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    
    self.bankView.hidden = NO;
    self.qrIcon.hidden = YES;
}

// 复制卡号
- (IBAction)copyCardNo:(id)sender {
    [UIPasteboard generalPasteboard].string = self.cardNoLb.text;
    [CNTOPHUB showSuccess:@"已复制到剪切板！"];
}

// 复制姓名
- (IBAction)copyAccountName:(id)sender {
    [UIPasteboard generalPasteboard].string = self.accountNameLb.text;
    [CNTOPHUB showSuccess:@"已复制到剪切板！"];
}

// 复制支行名称
- (IBAction)copySubBankName:(id)sender {
    [UIPasteboard generalPasteboard].string = self.subBankNameLb.text;
    [CNTOPHUB showSuccess:@"已复制到剪切板！"];
}

// 客户端
- (IBAction)submit:(UIButton *)sender {
    NSString *urlStr;
    NSString *appName;
    switch ([self.model.payWayType integerValue]) {
        case 0:
            urlStr = @"alipayqr://platformapi/startapp?saId=20000116";
            appName = @"支付宝";
            break;
        case 1:
            urlStr = @"weixin://";
            appName = @"微信";
            break;
        case 2:
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
            break;
    }
    NSURL *URL = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"正在为您跳转.."];
        }];
    } else {
        [CNTOPHUB showError:[NSString stringWithFormat:@"您尚未安装%@客户端", appName]];
    }
}

// 查询进度
- (IBAction)checkProcess:(id)sender {
    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
}

@end
