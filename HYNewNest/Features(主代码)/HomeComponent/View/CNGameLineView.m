//
//  CNGameLineView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNGameLineView.h"

@interface CNGameLineView ()
@property (weak, nonatomic) IBOutlet UIView *usdtView;
@property (weak, nonatomic) IBOutlet UIView *cnyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usdtViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnyViewH;
@property (weak, nonatomic) IBOutlet UIButton *usdtBtn;
@property (weak, nonatomic) IBOutlet UIButton *cnyBtn;
@property (nonatomic, copy) dispatch_block_t cnyHandler;
@property (nonatomic, copy) dispatch_block_t usdtHandler;
@end

@implementation CNGameLineView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    // 添加边框颜色
//    [self addBorderColder:self.usdtBtn fromColor:kHexColor(0x2E99F0) toColor:kHexColor(0x02EED9)];
    self.usdtBtn.layer.cornerRadius = self.usdtBtn.frame.size.height * 0.5;
    self.usdtBtn.layer.masksToBounds = YES;
    self.usdtBtn.layer.borderWidth = 1;
    self.usdtBtn.layer.borderColor = kHexColor(0x2E99F0).CGColor;
    
    self.cnyBtn.layer.cornerRadius = self.cnyBtn.frame.size.height * 0.5;
    self.cnyBtn.layer.masksToBounds = YES;
    self.cnyBtn.layer.borderWidth = 1;
    self.cnyBtn.layer.borderColor = kHexColor(0xCFA461).CGColor;
}

+ (void)choseCnyLineHandler:(dispatch_block_t)cnyHandler
       choseUsdtLineHandler:(dispatch_block_t)usdtHandler {
    
    CNGameLineView *alert = [[CNGameLineView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.cnyHandler = cnyHandler;
    alert.usdtHandler = usdtHandler;
    
    // 没有线路就不展示
    if (usdtHandler == nil) {
        alert.usdtView.hidden = YES;
        alert.usdtViewH.constant = 0;
    }
    if (cnyHandler == nil) {
        alert.cnyView.hidden = YES;
        alert.cnyViewH.constant = 0;
    }
}



- (IBAction)usdtLineAction:(id)sender {
    if (self.usdtHandler) {
        self.usdtHandler();
    }
    [self removeFromSuperview];
}

- (IBAction)cnyLineAction:(id)sender {
    if (self.cnyHandler) {
        self.cnyHandler();
    }
    [self removeFromSuperview];
}


- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)addBorderColder:(UIView *)boarderView fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {

    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = boarderView.bounds;
    gradientLayer.colors = @[fromColor, toColor];

    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.lineWidth = 1.0;
    maskLayer.path = [UIBezierPath bezierPathWithRect:boarderView.bounds].CGPath;
    maskLayer.fillColor = fromColor.CGColor;
    maskLayer.strokeColor = toColor.CGColor;
    gradientLayer.mask = maskLayer;
    [boarderView.layer addSublayer:gradientLayer];
}


@end
