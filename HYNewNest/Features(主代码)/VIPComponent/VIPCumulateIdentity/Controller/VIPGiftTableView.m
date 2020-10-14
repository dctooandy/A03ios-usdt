//
//  VIPGiftTableView.m
//  HYNewNest
//
//  Created by zaky on 10/14/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPGiftTableView.h"

@interface VIPGiftTableView() <UIGestureRecognizerDelegate>


@end

@implementation VIPGiftTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
