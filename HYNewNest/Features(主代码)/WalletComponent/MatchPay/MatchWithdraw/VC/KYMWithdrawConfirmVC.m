//
//  KYMWithdrawConfirmVC.m
//  HYNewNest
//
//  Created by Key.L on 2022/2/26.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "KYMWithdrawConfirmVC.h"
#import "KYMWithdrewAmountListView.h"
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
    
}

- (void)setupSubViews
{
    self.amountListView = [[KYMWithdrewAmountListView alloc] init];
    self.amountListView.amountArray = self.checkModel.data.amountList;
    [self.contentView addSubview:self.amountListView];
    
    NSUInteger lineCount = self.checkModel.data.amountList.count / 3 > 0 ? : 1;
    CGFloat matchWithdrewAmountH = 40 * lineCount + 16 + 8 * (lineCount - 1) + 21;
    [self.amountListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLB.mas_bottom).offset(15);
        make.left.equalTo(self.balanceLB);
        make.right.equalTo(self.contentView).offset(-30);
        make.height.offset(matchWithdrewAmountH);
    }];
    
    self.pwdTF = [[UITextField alloc] init];
    
}

- (void)setBalance:(NSString *)balance
{
    _balance = balance;
    self.balanceLB.text = balance;
    self.balanceLBWidth.constant = [balance boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.balanceLB.font} context:nil].size.width + 1;
}
- (IBAction)closeBtnClicked:(id)sender {
}

@end
