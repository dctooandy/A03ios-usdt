//
//  CNMatchDepositStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMatchDepositStatusVC.h"
#import "CNMAlertView.h"
#import <UIImageView+WebCache.h>

#import "CNMatchPayRequest.h"
#import "PublicMethod.h"


@interface CNMatchDepositStatusVC ()

#pragma mark - 中间金额视图
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLb;

#pragma mark - 中间银行卡视图，一共有4行信息栏
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *subBankName;
/// 复制内容标签组
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *contentLbArray;
/// 复制按钮
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCopyArray;

#pragma mark - 底部按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
///倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeInterval;

#pragma mark - 数据参数
@property (nonatomic, strong) CNMBankModel *bankModel;

@end

@implementation CNMatchDepositStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(goToBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI {
    self.bankView.layer.cornerRadius = 8;
    self.title = @"充值";
    
    for (UIButton *btn in self.btnCopyArray) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"复制"];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[attributeString length]}];
        [attributeString addAttribute:NSForegroundColorAttributeName value:btn.titleLabel.textColor range:NSMakeRange(0,[attributeString length])];

        //设置下划线颜色
        [attributeString addAttribute:NSUnderlineColorAttributeName value:btn.titleLabel.textColor range:(NSRange){0,[attributeString length]}];
        [btn setAttributedTitle:attributeString forState:UIControlStateNormal];
    }
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self showLoading];
    [CNMatchPayRequest queryDepisit:self.transactionId finish:^(id responseObj, NSString *errorMsg) {
        [self hideLoading];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            [weakSelf reloadUIWithModel:[CNMBankModel cn_parse:[dic objectForKey:@"data"]]];
            return;
        }
        [self showError:errorMsg];
    }];
}

- (void)reloadUIWithModel:(CNMBankModel *)bank {
    if (bank == nil) {
        return;
    }
    self.bankModel = bank;
    
    // 银行卡栏目信息
    self.amountLb.text = [NSString stringWithFormat:@"%ld", bank.amount.integerValue];
    [self.bankLogo sd_setImageWithURL:[NSURL URLWithString:[PublicMethod nowCDNWithUrl:bank.bankIcon]]];
    self.bankName.text = bank.bankName;
    self.accountName.text = bank.bankAccountName;
    self.accountNo.text = [self addSpaceForNum:bank.bankAccountNo];
    self.subBankName.text = bank.bankBranchName;
    self.amountTipLb.text = [NSString stringWithFormat:@"完成存款将获得%.2f元存款礼金，24小时到账", (bank.amount.doubleValue *0.01)];

    
    switch (bank.status) {
        case CNMPayBillStatusSubmit:
            break;
        case CNMPayBillStatusPaying:
            break;
        case CNMPayBillStatusCancel:
            // 订单取消，直接回到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        case CNMPayBillStatusConfirm:
            
            break;
        case CNMPayBillStatusUnMatch:
            
            break;
        default:
            
            break;
    }
    
    if (bank.createdDateFmt > 0) {
        self.timeInterval = bank.createdDateFmt;
        [self.timer setFireDate:[NSDate distantPast]];
    } else {
        self.confirmBtn.enabled = YES;
    }
}

- (NSString *)addSpaceForNum:(NSString *)num {
    if (num.length == 0) {
        return num;
    }
    NSMutableString *string = [num mutableCopy];
    for (int i = 4; i < num.length; i += 4) {
        [string insertString:@" " atIndex:i+(i-4)/4];
    }
    return string;
}

- (void)timerCounter {
    
    self.timeInterval -= 1;
    if (self.timeInterval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.confirmBtn.enabled = YES;
        return;
    }
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认存款(%lds)", self.timeInterval] forState:UIControlStateDisabled];
}

#pragma mark - 按钮组事件

- (IBAction)confirm:(UIButton *)sender {
    [self commitDepisit];
}

- (void)commitDepisit {
    // 上报数据
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [CNMatchPayRequest commitDepisit:self.transactionId receiptImg:nil transactionImg:nil finish:^(id responseObj, NSString *errorMsg) {
        [self hideLoading];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            if ([[dic objectForKey:@"code"] isEqualToString:@"00000"]) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if (errorMsg) {
                    [CNTOPHUB showError:errorMsg];
                } else {
                    [CNTOPHUB showError:[dic objectForKey:@"message"]];
                }
            }
        }
    }];
}

- (IBAction)copyContent:(UIButton *)sender {
    if (sender.tag == 0) {//卡号
        [UIPasteboard generalPasteboard].string = self.bankModel.bankAccountNo;
    } else {
        [UIPasteboard generalPasteboard].string = self.contentLbArray[sender.tag].text;
    }
    [self showSuccess:@"复制成功"];
}

- (void)goToBack {
    if (_backToLastVC) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Setter Getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}
@end
