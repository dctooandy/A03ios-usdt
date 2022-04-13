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
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "CNMUploadView.h"

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
@property (weak, nonatomic) IBOutlet UILabel *actionTipLb;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
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
    self.backBtn.layer.cornerRadius = 24;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    
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
        if (errorMsg) {
            [CNTOPHUB showError:errorMsg];
            return;
        }
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            [weakSelf reloadUIWithModel:[CNMBankModel cn_parse:[dic objectForKey:@"data"]]];
        }
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
    
    //确认按钮状态
    if (bank.needUploadFlag == 1) {
        self.confirmBtn.enabled = YES;
        [self.confirmBtn setTitle:@"上传凭证" forState:UIControlStateNormal];
        self.actionTipLb.text = @"请完成存款后，再点击上传凭证";
    } else if ([bank.manualStatus isEqualToString:@"4"]) {// 交易挂起
        self.confirmBtn.hidden = YES;
    } else {
        if (bank.status == CNMPayBillStatusConfirm) {
            [self.confirmBtn setTitle:@"上传凭证" forState:UIControlStateNormal];
            self.actionTipLb.text = @"请完成存款后，再点击上传凭证";
        } else {
            [self.confirmBtn setTitle:@"确认存款" forState:UIControlStateNormal];
            self.actionTipLb.text = @"请完成存款后，再点击确认存款";
        }
        if (bank.createdDateFmt > 0) {
            self.timeInterval = bank.createdDateFmt;
            [self.timer setFireDate:[NSDate distantPast]];
        } else {
            self.confirmBtn.enabled = YES;
        }
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
    __weak typeof(self) weakSelf = self;
    if (self.bankModel.needUploadFlag == 1) {
        [CNMUploadView showUploadViewTo:self billId:self.bankModel.transactionId promo:NO commitDeposit:^(NSArray *receiptImages, NSArray *recordImages) {
            // 存款已确认不需要确认
            if (weakSelf.bankModel.status == CNMPayBillStatusConfirm) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [weakSelf commitDepisitWithReceiptImages:receiptImages recordImages:recordImages];
            }
        }];
    } else {
        if (self.bankModel.status == CNMPayBillStatusConfirm) {
            [CNMUploadView showUploadViewTo:self billId:self.bankModel.transactionId promo:YES commitDeposit:^(NSArray * _Nonnull receiptImages, NSArray * _Nonnull recordImages) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [self commitDepisitWithReceiptImages:nil recordImages:nil];
        }
    }
}

- (void)commitDepisitWithReceiptImages:(NSArray *)receiptImages recordImages:(NSArray *)recordImages {
    // 上报数据
    [self showLoading];
    [CNMatchPayRequest commitDepisit:self.transactionId receiptImg:receiptImages.lastObject transactionImg:recordImages finish:^(id responseObj, NSString *errorMsg) {
        [self hideLoading];
        if (errorMsg) {
            [CNTOPHUB showError:errorMsg];
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)goToHomePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)customerServer {
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [self showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持"];
        }
    }];
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
