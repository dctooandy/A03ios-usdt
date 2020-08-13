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

@interface HYWithdrawAddCardFooter ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation HYWithdrawAddCardFooter


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.layer.cornerRadius = AD(10);
    [self.addBtn setTitle:[CNUserManager shareManager].isUsdtMode?@"添加地址":@"添加银行卡" forState:UIControlStateNormal];
    [self addDottedLineWithView:self.bgView borderColor:kHexColor(0x6D778B) fillColor:kHexColor(0x212137)];
}

- (IBAction)addAddrClick:(id)sender {
    CNAddAddressVC *vc = [CNAddAddressVC new];
    vc.addrType = HYAddressTypeUSDT;
    [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
