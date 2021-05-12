//
//  BYYuEBaoTransferVC.m
//  HYNewNest
//
//  Created by zaky on 5/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYYuEBaoTransferVC.h"
#import "CNTwoStatusBtn.h"

@interface BYYuEBaoTransferVC ()
{
    BOOL _isAmountRight;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTransableAmout;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrency;
@property (weak, nonatomic) IBOutlet UITextField *tfTransAmout;
@property (weak, nonatomic) IBOutlet UILabel *lbTips;
@property (weak, nonatomic) IBOutlet UILabel *lbWrongMsg;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *btnComfirm;
@property (assign,nonatomic) YEBTransferType type;
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
}

- (instancetype)initWithType:(YEBTransferType)type {
    self = [super init];
    _type = type;
    if (type == YEBTransferTypeDeposit) {
        self.title = @"转入余额宝";
        self.lbTips.text = @"放的越久，利息越多";
        [self.btnComfirm setTitle:@"确认转入" forState:UIControlStateNormal];
    } else {
        self.title = @"转出余额宝";
        self.lbTips.text = @"最低买入金额100USDT，最高可买入50000USDT";
        [self.btnComfirm setTitle:@"确认转出" forState:UIControlStateNormal];
    }
    return self;
}


#pragma mark - ACTION

- (IBAction)didTapAllTransBtn:(id)sender {
}

- (IBAction)didTapComfirmTransBtn:(id)sender {
    //网络请求...
    [self.navigationController popViewControllerAnimated:YES];
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
    } else if ([text floatValue] < 1) { // 最小 提现/转入 金额
        _isAmountRight = NO;
    } else if ([text floatValue] > 1000){ // 最大 提现/转入 金额
        _isAmountRight = NO;
    } else {
        _isAmountRight = YES;
    }
    _lbWrongMsg.hidden = _isAmountRight;
    _btnComfirm.enabled = _isAmountRight;
}

@end
