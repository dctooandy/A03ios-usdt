//
//  BYFirstFillBannerView.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYFirstFillBannerView.h"

@implementation BYFirstFillBannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -
#pragma mark IBAction
- (IBAction)firstFillClicked:(id)sender {
    if (self.delegate) {
        [self.delegate moreBannerClicked];
    }
}

- (IBAction)killSelf:(id)sender {
    [self removeFromSuperview];
}

@end
