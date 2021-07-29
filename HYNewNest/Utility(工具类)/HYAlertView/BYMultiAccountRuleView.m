//
//  BYMultiAccountRuleView.m
//  HYNewNest
//
//  Created by zaky on 7/9/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYMultiAccountRuleView.h"
#import "CNTwoStatusBtn.h"

@implementation BYMultiAccountRuleView

+ (void)showRuleWithLocatedY:(CGFloat)y {
    BYMultiAccountRuleView *a = [[BYMultiAccountRuleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [a setupViewsWithY:y];
    [a show];
}

- (void)setupViewsWithY:(CGFloat)y {
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"编组 17"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y);
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(AD(345));
        make.height.mas_equalTo(AD(267));
    }];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgv);
        make.width.mas_equalTo(AD(305));
        make.height.mas_equalTo(48);
        make.bottom.equalTo(imgv).offset(-20);
    }];

}


@end
