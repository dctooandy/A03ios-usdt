//
//  BYMoreCompleteMission.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYMoreCompleteMissionView.h"

@implementation BYMoreCompleteMissionView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark IBaction
- (IBAction)moreClicked:(id)sender {
    if (self.delegate) {
        [delegate moreBannerClicked];
    }
}

@end
