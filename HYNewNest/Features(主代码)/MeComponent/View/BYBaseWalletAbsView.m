//
//  BYBaseWalletAbsView.m
//  HYNewNest
//
//  Created by zaky on 3/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYBaseWalletAbsView.h"

@implementation BYBaseWalletAbsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

- (instancetype)init
{
    NSAssert(![self isMemberOfClass:[BYBaseWalletAbsView class]], @"BYBaseWalletAbsView is an abstract class, you should not instantiate it directly.");
    
    return [super init];
}

@end
