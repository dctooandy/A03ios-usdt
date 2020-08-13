//
//  HYXiMaTopView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYXiMaTopView.h"

@interface HYXiMaTopView ()
@property (weak, nonatomic) IBOutlet UILabel *lblXimaCurrency;
@end

@implementation HYXiMaTopView

- (void)loadViewFromXib {
    self.backgroundColor = [UIColor clearColor];
    [super loadViewFromXib];
    
    if (![CNUserManager shareManager].isUsdtMode) {
        self.lblXimaCurrency.text = @"CNY";
    }
}

- (IBAction)didClickRule:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
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
