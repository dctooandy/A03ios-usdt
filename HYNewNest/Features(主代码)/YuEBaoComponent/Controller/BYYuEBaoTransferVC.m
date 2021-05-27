//
//  BYYuEBaoTransferVC.m
//  HYNewNest
//
//  Created by zaky on 5/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYYuEBaoTransferVC.h"
#import "CNTwoStatusBtn.h"
#import "CNYuEBaoRequest.h"
#import "BalanceManager.h"

@interface BYYuEBaoTransferVC ()
{
    BOOL _isAmountRight;
}
@property (weak, nonatomic) IBOutlet UILabel *lbThird;
@property (weak, nonatomic) IBOutlet UILabel *lbTransableAmout;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrency;
@property (weak, nonatomic) IBOutlet UITextField *tfTransAmout;
@property (weak, nonatomic) IBOutlet UILabel *lbTips;
@property (weak, nonatomic) IBOutlet UILabel *lbWrongMsg;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *btnComfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnAllTrans;
@property (assign,nonatomic) YEBTransferType type;
@property (strong,nonatomic) CNYuEBaoConfigModel *model;
@end

@implementation BYYuEBaoTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnComfirm.enabled = NO;
    
    [self.tfTransAmout setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfTransAmout setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfTransAmout addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfTransAmout addTarget:self action:@selector(amountTfDidResignFirstResponder:) forControlEvents:UIControlEventEditingDidEnd];
    
    if (self.type == YEBTransferTypeDeposit) {
        self.title = @"转入余额宝";
        self.lbThird.text = @"可提币余额";
        [self.btnComfirm setTitle:@"确认转入" forState:UIControlStateNormal];
        self.tfTransAmout.placeholder = @"请输入转入金额";
        if (self.model.maxAmount == -1) {
            self.lbTips.text = [NSString stringWithFormat:@"最低买入金额%ldUSDT", (long)self.model.minAmount];
        } else {
            self.lbTips.text = [NSString stringWithFormat:@"最低买入金额%ldUSDT，最高可买入%ldUSDT", (long)self.model.minAmount, (long)self.model.maxAmount];
        }
        
        [self.lbTransableAmout showIndicatorIsBig:YES];
        [BalanceManager requestWithdrawAbleBalanceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            NSNumber *num = model.withdrawBal;
            [self.lbTransableAmout hideIndicatorWithText:[num jk_toDisplayNumberWithDigit:2]];
        }];
        
    } else {
        self.title = @"转出余额宝";
        self.lbThird.text = @"余额宝总额";
        [self.btnComfirm setTitle:@"确认转出" forState:UIControlStateNormal];
        self.tfTransAmout.placeholder = @"请输入转出金额";
        self.lbTips.text = @"放的越久，利息越多";
        
        // 只支持全部转出
        self.lbWrongMsg.text = @"*余额宝仅支持全部转出";
        self.lbWrongMsg.hidden = NO;
        self.lbWrongMsg.textColor = kHexColor(0x4C8BD8);
        self.tfTransAmout.userInteractionEnabled = NO;
        self.btnAllTrans.hidden = YES;
        
        NSNumber *num = @(self.model.yebAmount.floatValue + self.model.yebInterest.floatValue);
        self.lbTransableAmout.text = [num jk_toDisplayNumberWithDigit:2];
        [self allTransferOutMove];
        if (self.tfTransAmout.text.floatValue > 0) {
            self.btnComfirm.enabled = YES;
        }
    }
    
}

- (instancetype)initWithType:(YEBTransferType)type  configModel:(CNYuEBaoConfigModel *)model{
    self = [super init];
    self.type = type;
    self.model = model;
    return self;
}


#pragma mark - ACTION

- (void)allTransferInMove {
    NSString *amount = self.lbTransableAmout.text;
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    amount = [amount componentsSeparatedByString:@"."].firstObject;
    self.tfTransAmout.text = amount;
    [self amountTfDidResignFirstResponder:self.tfTransAmout];
}

- (void)allTransferOutMove {
    NSString *trasnAmount = [self.lbTransableAmout.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    self.tfTransAmout.text = trasnAmount;
    [self.tfTransAmout resignFirstResponder];
}

- (IBAction)didTapAllTransBtn:(id)sender {
    [self allTransferInMove];
}

- (IBAction)didTapComfirmTransBtn:(id)sender {
    
    NSNumber *amount = [NSNumber numberWithDouble:self.tfTransAmout.text.doubleValue];
    if (self.type == YEBTransferTypeDeposit) {
        [CNYuEBaoRequest transferInYuEBaoAmount:amount handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [CNYuEBaoRequest transferOutYuEBaoAmount:amount handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}


#pragma mark - TextField

- (void)amountTfDidResignFirstResponder:(UITextField *)tf {
    [self amountTfDidChange:tf];
}

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    // 校验金额
    if (![text isPrueIntOrFloat]) {
        _isAmountRight = NO;
    } else if ([text floatValue] < self.model.minAmount) { // 最小 提现/转入 金额
        _isAmountRight = NO;
    } else if ([text floatValue] > self.model.maxAmount){ // 最大 提现/转入 金额
        _isAmountRight = NO;
    } else {
        _isAmountRight = YES;
    }
    _lbWrongMsg.hidden = _isAmountRight;
    _btnComfirm.enabled = _isAmountRight;
}

@end
