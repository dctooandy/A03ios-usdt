//
//  CNMAlertView.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/21/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMAlertView.h"
#import "AppDelegate.h"

@interface CNMAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, copy) dispatch_block_t commitAction;
@property (nonatomic, copy) dispatch_block_t cancelAction;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeInterval;
@end

@implementation CNMAlertView

+ (instancetype)showAlertTitle:(NSString *)title content:(NSString *)content desc:(NSString *)desc needRigthTopClose:(BOOL)need commitTitle:(NSString *)commit commitAction:(dispatch_block_t)commitAction cancelTitle:(NSString *)cancel cancelAction:(dispatch_block_t)cancelAction {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    // 允许一个弹框
    UIView *subview = [window viewWithTag:10001];
    if (subview) {
        [subview removeFromSuperview];
    }
    
    CNMAlertView *alert = [[CNMAlertView alloc] initWithFrame:window.bounds];
    alert.titleLb.text = title;
    alert.contentLb.text = content;
    alert.descLb.text = desc;
    alert.closeBtn.hidden = !need;
    alert.tag = 10001;
    
    CGRect frame = alert.btnView.bounds;
    alert.commitAction = commitAction;
    alert.cancelAction = cancelAction;
    [window addSubview:alert];
    
    // 添加按钮
    UIButton *commitBtn = [alert createBtnWithTitle:commit];
    [commitBtn addTarget:alert action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    alert.commitBtn = commitBtn;
    if (cancel) {
        commitBtn.frame = CGRectMake(15, 0, (frame.size.width-15*3)*0.5, frame.size.height);
        [alert.btnView addSubview:commitBtn];
        
        UIButton *cancelBtn = [alert createBtnWithTitle:cancel];
        [cancelBtn addTarget:alert action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(CGRectGetMaxX(commitBtn.frame)+15, 0, commitBtn.frame.size.width, commitBtn.frame.size.height);
        [alert.btnView addSubview:cancelBtn];
    } else {
        commitBtn.frame = CGRectMake(15, 0, frame.size.width-30, frame.size.height);
        [alert.btnView addSubview:commitBtn];
    }
    return alert;
}

+ (instancetype)show3SecondAlertTitle:(NSString *)title content:(nonnull NSString *)content interval:(NSInteger)interval commitAction:(nonnull dispatch_block_t)commitAction {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    // 允许一个弹框
    UIView *subview = [window viewWithTag:10001];
    if (subview) {
        [subview removeFromSuperview];
    }
    
    CNMAlertView *alert = [[CNMAlertView alloc] initWithFrame:window.bounds];
    alert.titleLb.text = title;
    alert.contentLb.text = content;
    alert.timeInterval = interval + 1;
    alert.closeBtn.hidden = YES;
    alert.tag = 10001;
    
    CGRect frame = alert.btnView.bounds;
    alert.commitAction = commitAction;
    [window addSubview:alert];

    // 添加按钮
    UIButton *commitBtn = [alert createBtnWithTitle:[NSString stringWithFormat:@"%ld秒后自动跳转", interval]];
    [commitBtn addTarget:alert action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.frame = CGRectMake(15, 0, frame.size.width-30, frame.size.height);
    [alert.btnView addSubview:commitBtn];
    alert.commitBtn = commitBtn;
    
    [alert.timer setFireDate:[NSDate distantPast]];
    return alert;
}


- (void)commit {
    [self removeFromSuperview];
    !self.commitAction ?: self.commitAction();
}

- (void)cancel {
    [self removeFromSuperview];
    !self.cancelAction ?: self.cancelAction();
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (UIButton *)createBtnWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = kHexColor(0x38385F);
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    btn.layer.cornerRadius = 24;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (void)timerCounter {
    self.timeInterval -= 1;
    if (self.timeInterval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timeInterval = 0;
    }
    [self.commitBtn setTitle:[NSString stringWithFormat:@"%ld秒后自动跳转", self.timeInterval] forState:UIControlStateNormal];
    
    if (self.timeInterval == 0) {
        [self commit];
    }
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
