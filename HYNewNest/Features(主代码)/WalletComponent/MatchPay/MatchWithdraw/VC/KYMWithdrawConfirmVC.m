//
//  KYMWithdrawConfirmVC.m
//  HYNewNest
//
//  Created by Key.L on 2022/2/26.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "KYMWithdrawConfirmVC.h"
#import "KYMWithdrewAmountListView.h"
#import "KYMWithDrewHomeNotifyView.h"
#import "KYMSubmitButton.h"
#import "Masonry.h"
#import "KYMWidthdrewUtility.h"
#import "CNAmountInputView.h"
#import "CNCodeInputView.h"

@interface KYMWithdrawConfirmVC ()<KYMWithdrewAmountCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLBWidth;
@property (strong ,nonatomic) KYMWithdrewAmountListView *amountListView;
@property (strong, nonatomic) CNAmountInputView *amountInputView;
@property (strong, nonatomic) CNCodeInputView *codeInputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) KYMSubmitButton *submitBitn;

@end

@implementation KYMWithdrawConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.balanceLB.text =  [KYMWidthdrewUtility getMoneyString:[self.balanceModel.withdrawBal doubleValue]];
    self.mainView.layer.cornerRadius = 20;
    self.mainView.layer.masksToBounds = YES;
    self.amountListView = [[KYMWithdrewAmountListView alloc] init];
    self.amountListView.amountArray = self.checkModel.data.amountList;
    self.amountListView.delegate = self;
    [self.contentView addSubview:self.amountListView];
    
    
    NSUInteger lineCount = 0;
    if (self.checkModel.data.amountList.count > 0) {
        lineCount = ceilf(self.checkModel.data.amountList.count / 3.0) ;
    }
    CGFloat matchWithdrewAmountH = 0;
 
    if (lineCount > 0 && !self.isForceNormalWithdraw) {
        matchWithdrewAmountH = 40 * lineCount + 16 + 50 + 8 * (lineCount - 1);
    }
    
    [self.amountListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLB.mas_bottom).offset(15);
        make.left.equalTo(self.balanceLB);
        make.right.equalTo(self.contentView).offset(-30);
        make.height.offset(matchWithdrewAmountH);
    }];
    
    self.amountInputView = [CNAmountInputView new];
    self.amountInputView.delegate = self;
    self.amountInputView.codeType = CNAmountTypeWithdraw;
    self.amountInputView.model = self.balanceModel;
    [self.amountInputView setPlaceholder:@"请输入提款金额"];
    [self.contentView addSubview:self.amountInputView];
    
    self.codeInputView = [CNCodeInputView new];
    self.codeInputView.delegate = self;
    self.codeInputView.codeType = CNCodeTypeOldFundPwd;
    [self.codeInputView setPlaceholder:@"请输入资金密码"];
    [self.contentView addSubview:self.codeInputView];
    
    [self.amountInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountListView);
        make.top.equalTo(self.amountListView.mas_bottom).offset(0);
        make.height.offset(89);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.15];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountInputView);
        make.top.equalTo(self.amountInputView.mas_bottom);
        make.height.offset(0.5);
    }];
    
    [self.codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountListView);
        make.top.equalTo(self.amountInputView.mas_bottom).offset(0);
        make.height.offset(89);
    }];
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.15];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeInputView);
        make.top.equalTo(self.codeInputView.mas_bottom);
        make.height.offset(0.5);
    }];

    self.submitBitn = [[KYMSubmitButton alloc] init];
    [self.submitBitn addTarget:self action:@selector(submitBitnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitBitn];
    [self.submitBitn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeInputView.mas_bottom).offset(20);
        make.left.right.equalTo(self.codeInputView);
        make.height.offset(48);
    }];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.balanceLBWidth.constant = [self.balanceLB.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.balanceLB.font} context:nil].size.width + 1;
    self.contentViewHeight.constant = CGRectGetMaxY(self.submitBitn.frame) + 24;
}

- (void)submitBitnClicked:(UIButton *)button
{
    BOOL isMatchWithdraw = (self.amountListView.selectedIndexPath != nil);
    self.submitHandler(self.codeInputView.code, self.amountInputView.money, isMatchWithdraw);
}
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)textChanged:(UITextField *)textField
//{
//    if (textField == self.amountTF) {
//        [self.amountListView setCurrentAmount:textField.text];
//    }
//
//    if ([KYMWidthdrewUtility isValidateWithdrawPwdNumber:self.pwdTF.text] && self.amountTF.text.length > 0) {
//        self.submitBitn.enabled = true;
//    } else {
//        self.submitBitn.enabled = false;
//    }
//}
- (void)matchWithdrewAmountCellDidSelected:(KYMWithdrewAmountListView *)view indexPath:(NSIndexPath *)indexPath
{
    self.amountInputView.money = view.amountArray[indexPath.row].amount;
    
    if ([KYMWidthdrewUtility isValidateWithdrawPwdNumber:self.codeInputView.code] && self.amountInputView.money.length > 0) {
        self.submitBitn.enabled = true;
    } else {
        self.submitBitn.enabled = false;
    }
}
#pragma mark Input Delegate
- (void)amountInputViewTextChange:(CNAmountInputView *)view {
    [self.amountListView setCurrentAmount:view.money];
    [self.submitBitn setEnabled:(view.correct && view.money.length > 0) && self.codeInputView.correct];
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    [self.submitBitn setEnabled:(view.correct && self.amountInputView.money.length > 0) && self.codeInputView.correct];
}
@end
