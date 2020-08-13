//
//  CNStatementView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/16.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNStatementView.h"

@interface CNStatementView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrOfHoverWidth;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation CNStatementView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    self.textView.backgroundColor = self.backgroundColor;
    self.textView.textColor = kHexColorAlpha(0xFFFFFF, 0.6);
    self.textView.font = [UIFont systemFontOfSize:AD(14)];
    self.constrOfHoverWidth.constant = AD(345);
}

+ (void)showWithTitle:(NSString *)title content:(NSString *)content{
    
    CNStatementView *alert = [[CNStatementView alloc] init];
    alert.lblTitle.text = title;
    alert.textView.text = content;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
}


- (IBAction)defaultAction:(id)sender {
    [self removeFromSuperview];
}

@end
