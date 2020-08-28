//
//  UIWindow+Motion.m
//  uknow
//
//  Created by uknow on 2019/7/25.
//

#import "UIWindow+Motion.h"
#import <objc/runtime.h>

@implementation UIWindow (Motion)

- (void)setBackView:(UIView *)backView {
    
    objc_setAssociatedObject(self, @"backView", backView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)backView {
    return objc_getAssociatedObject(self, @"backView");
}

- (void)setButtonBackView:(UIView *)buttonBackView {
    
    objc_setAssociatedObject(self, @"buttonBackView", buttonBackView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)buttonBackView {
    return objc_getAssociatedObject(self, @"buttonBackView");
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (NSClassFromString(@"Lookin")) {
        
        CGRect frame = [UIApplication sharedApplication].keyWindow.frame;
        
        UIView *backView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        self.backView = backView;
        backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [backView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:backView];
        
        UIView *buttonBackView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 240)*0.5, (frame.size.height - 176)*0.5, 240, 176)];
        self.buttonBackView = buttonBackView;
        buttonBackView.layer.cornerRadius = 10.0;
        buttonBackView.layer.masksToBounds = YES;
        buttonBackView.contentMode = UIViewContentModeScaleAspectFit;
        buttonBackView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:buttonBackView];
        
        NSArray *titles = [NSArray arrayWithObjects:@"导出当前UI结构", @"审查元素", @"3D视图", @"取消", nil];
        for (NSInteger i = 0; i < 4; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*44, 240, 44)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:i==3?[UIColor darkGrayColor]:[UIColor systemOrangeColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonBackView addSubview:btn];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];;
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
            break;
        case 3:
            [self dismiss];
            break;
            
        default:
            break;
    }
    
    [self dismiss];
}
- (void)dismiss {

    [self.backView removeFromSuperview];
    [self.buttonBackView removeFromSuperview];
}

@end
