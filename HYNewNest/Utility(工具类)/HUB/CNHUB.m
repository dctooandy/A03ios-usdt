//
//  CNHUB.m
//  HYNewNest
//
//  Created by Cean on 2020/7/17.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNHUB.h"

@interface CNHUB ()
@property (nonatomic, strong) NSTimer *hideTimer;
@property (weak, nonatomic) IBOutlet UIImageView *tipIV;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation CNHUB

+ (void)showError:(NSString *)error {
    if (error.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CNHUB *view = [self creatTipViewWithMsg:error];
        view.tipIV.image = [UIImage imageNamed:@"l_wrong"];
    });
}

+ (void)showSuccess:(NSString *)success {
    if (success.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CNHUB *view = [self creatTipViewWithMsg:success];
        view.tipIV.image = [UIImage imageNamed:@"l_right"];
    });
}

+ (void)showWaiting:(NSString *)wait {
    if (wait.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CNHUB *view = [self creatTipViewWithMsg:wait];
        view.tipIV.image = [UIImage imageNamed:@"编组"];
        view.centerY = kScreenHeight*0.5;
    });
}

+ (void)showAlert:(NSString *)alert {
    if (alert.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CNHUB *view = [self creatTipViewWithMsg:alert];
        view.tipIV.image = [UIImage imageNamed:@"l_prob"];
    });
}

+ (instancetype)creatTipViewWithMsg:(NSString *)msg {
    CGFloat fontSize = 14, left = 30, otherLength = 76, y = 60;
    CGFloat textLength = msg.length * fontSize;
    CGFloat mixWidth = kScreenWidth - left * 2;
    int numLine  = ceil(textLength / (mixWidth - otherLength));
    CGFloat height = numLine * (fontSize+4) + 38;
    
    if ((textLength + otherLength) < mixWidth) {
        left = (kScreenWidth - (textLength + otherLength)) / 2.0;
        mixWidth = textLength + otherLength;
    }
    CGRect frame = CGRectMake(left, y, mixWidth, height);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    CNHUB *tipView = [[CNHUB alloc] initWithFrame:frame];
    tipView.layer.cornerRadius = 5;
    tipView.layer.masksToBounds = YES;
    tipView.tipLabel.text = msg;
    [window addSubview:tipView];
    [tipView creatTimer];
    return tipView;
}

- (void)creatTimer {
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerAciton) userInfo:nil repeats:NO];
}

- (void)timerAciton {
    [self.hideTimer invalidate];
    self.hideTimer = nil;
    [self removeFromSuperview];
}

@end
