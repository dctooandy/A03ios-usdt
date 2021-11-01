//
//  HYWithdrawAddCardFooter.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawAddCardFooter.h"
#import "UIView+DottedLine.h"
#import "CNAddAddressVC.h"
#import "CNAddBankCardVC.h"
#import "UIColor+Gradient.h"

@interface HYWithdrawAddCardFooter ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation HYWithdrawAddCardFooter


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.layer.cornerRadius = AD(10);
    [self.addBtn setTitle:[CNUserManager shareManager].isUsdtMode?@"添加地址":@"添加银行卡" forState:UIControlStateNormal];
    UIColor * tempColor = [UIColor gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withWidth:CGRectGetWidth(self.addBtn.frame)];
    [self.addBtn setTitleColor:kHexColor(0x19CECE) forState:UIControlStateNormal];
    [self.addBtn setTintColor:tempColor];
    [self dottedLineBorderWithView:self.bgView borderColor:kHexColor(0x6D778B) fillColor:kHexColor(0x212137)];
}

- (IBAction)addAddrClick:(id)sender {
    if ([CNUserManager shareManager].isUsdtMode) {
        CNAddAddressVC *vc = [CNAddAddressVC new];
        vc.addrType = HYAddressTypeDCBOX;
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    } else {
        CNAddBankCardVC *vc = [CNAddBankCardVC new];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
