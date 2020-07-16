//
//  CNStatementView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/16.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNStatementView.h"

@interface CNStatementView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation CNStatementView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    self.textView.backgroundColor = self.backgroundColor;
    self.textView.textColor = kHexColorAlpha(0xFFFFFF, 0.6);
}

+ (void)showStatement {
    CNStatementView *alert = [[CNStatementView alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
}


- (IBAction)defaultAction:(id)sender {
    [self removeFromSuperview];
}

@end
