//
//  IVCTextView.m
//  IVCheckNetworkLibrary
//
//  Created by key.l on 12/5/20.
//  Copyright © 2020 Key. All rights reserved.
//

#import "IVCTextView.h"

@implementation IVCTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}
- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end
