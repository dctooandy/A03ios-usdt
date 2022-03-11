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

@interface KYMWithdrawConfirmVC ()<KYMWithdrewAmountCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLBWidth;
@property (strong ,nonatomic) KYMWithdrewAmountListView *amountListView;
@property (strong, nonatomic) UITextField *amountTF;
@property (strong, nonatomic) UITextField *pwdTF;
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
    self.balanceLB.text =  [KYMWidthdrewUtility getMoneyString:[self.balance doubleValue]];
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
    
    self.amountTF = [[UITextField alloc] init];
    self.amountTF.textColor = [UIColor whiteColor];
    self.amountTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"最小提现300元" attributes:@{NSFontAttributeName : self.amountTF.font,NSForegroundColorAttributeName : [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4]}];
    self.amountTF.attributedPlaceholder = attr;
    [self.amountTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.amountTF];
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountListView);
        make.top.equalTo(self.amountListView.mas_bottom).offset(17);
        make.height.offset(40);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.15];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountTF);
        make.top.equalTo(self.amountTF.mas_bottom);
        make.height.offset(0.5);
    }];
    
    self.pwdTF = [[UITextField alloc] init];
    self.pwdTF.textColor = [UIColor whiteColor];
    self.pwdTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:@"请输入资金密码" attributes:@{NSFontAttributeName : self.pwdTF.font,NSForegroundColorAttributeName : [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4]}];
    self.pwdTF.attributedPlaceholder = attr1;
    [self.pwdTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"l_password"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"l_password_s"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(pwdRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.pwdTF.rightView = rightBtn;
    self.pwdTF.rightViewMode = UITextFieldViewModeAlways;
    self.pwdTF.secureTextEntry = YES;
    [self.contentView addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountListView);
        make.top.equalTo(self.amountTF.mas_bottom).offset(17);
        make.height.offset(40);
    }];
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.15];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pwdTF);
        make.top.equalTo(self.pwdTF.mas_bottom);
        make.height.offset(0.5);
    }];

    self.submitBitn = [[KYMSubmitButton alloc] init];
    [self.submitBitn addTarget:self action:@selector(submitBitnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.submitBitn];
    [self.submitBitn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTF.mas_bottom).offset(20);
        make.left.right.equalTo(self.pwdTF);
        make.height.offset(48);
    }];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.balanceLBWidth.constant = [self.balanceLB.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.balanceLB.font} context:nil].size.width + 1;
    self.contentViewHeight.constant = CGRectGetMaxY(self.submitBitn.frame) + 24;
}
- (void)pwdRightBtnClicked:(UIButton *)button
{
    button.selected = !button.selected;
    self.pwdTF.secureTextEntry = !button.selected;
}
- (void)submitBitnClicked:(UIButton *)button
{
    BOOL isMatchWithdraw = (self.amountListView.selectedIndexPath != nil);
    self.submitHandler(self.pwdTF.text, self.amountTF.text, isMatchWithdraw);
}
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textChanged:(UITextField *)textField
{
    if (textField == self.amountTF) {
        [self.amountListView setCurrentAmount:textField.text];
    }
    
    if ([KYMWidthdrewUtility isValidateWithdrawPwdNumber:self.pwdTF.text] && self.amountTF.text.length > 0) {
        self.submitBitn.enabled = true;
    } else {
        self.submitBitn.enabled = false;
    }
}
- (void)matchWithdrewAmountCellDidSelected:(KYMWithdrewAmountListView *)view indexPath:(NSIndexPath *)indexPath
{
    self.amountTF.text = view.amountArray[indexPath.row].amount;
    
    if ([KYMWidthdrewUtility isValidateWithdrawPwdNumber:self.pwdTF.text] && self.amountTF.text.length > 0) {
        self.submitBitn.enabled = true;
    } else {
        self.submitBitn.enabled = false;
    }
}
@end
