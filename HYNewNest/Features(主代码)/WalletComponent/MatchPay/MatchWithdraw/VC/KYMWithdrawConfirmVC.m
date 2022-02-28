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
@interface KYMWithdrawConfirmVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLBWidth;
@property (strong ,nonatomic) KYMWithdrewAmountListView *amountListView;
@property (strong, nonatomic) UITextField *pwdTF;


@end

@implementation KYMWithdrawConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.balanceLB.text = self.balance;
    self.balanceLBWidth.constant = [self.balance boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.balanceLB.font} context:nil].size.width + 1;
    
    self.contentView.layer.cornerRadius = 20;
    self.contentView.layer.masksToBounds = YES;
    self.amountListView = [[KYMWithdrewAmountListView alloc] init];
    self.amountListView.amountArray = self.checkModel.data.amountList;
    [self.contentView addSubview:self.amountListView];
    
    NSUInteger lineCount = self.checkModel.data.amountList.count / 3 > 0 ? self.checkModel.data.amountList.count / 3 : 1;
    CGFloat matchWithdrewAmountH = 40 * lineCount + 16 + 8 * (lineCount - 1) + 21;
    [self.amountListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLB.mas_bottom).offset(15);
        make.left.equalTo(self.balanceLB);
        make.right.equalTo(self.contentView).offset(-30);
        make.height.offset(matchWithdrewAmountH);
    }];
    
    self.pwdTF = [[UITextField alloc] init];
    self.pwdTF.placeholder = @"请输入资金密码";
    [self.contentView addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountListView);
        make.top.equalTo(self.amountListView.mas_bottom).offset(17);
        make.height.offset(40);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.15];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pwdTF);
        make.top.equalTo(self.pwdTF.mas_bottom);
        make.height.offset(0.5);
    }];
    KYMWithDrewHomeNotifyView *notifyVeiw = [[KYMWithDrewHomeNotifyView alloc] init];
    notifyVeiw.canUseCount = self.checkModel.data.remainWithdrawTimes;
    [self.contentView addSubview:notifyVeiw];
    [notifyVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(14);
        make.left.right.equalTo(lineView);
        make.height.offset(210);
    }];
    
    KYMSubmitButton *submitBitn = [[KYMSubmitButton alloc] init];
    [self.contentView addSubview:submitBitn];
    [submitBitn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notifyVeiw.mas_bottom).offset(20);
        make.left.right.equalTo(notifyVeiw);
        make.height.offset(48);
    }];
}

- (void)setBalance:(NSString *)balance
{
    _balance = balance;
}
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
