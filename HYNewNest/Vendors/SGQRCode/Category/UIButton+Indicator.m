//
//  UIButton+Indicator.m
//  HYGEntire
//
//  Created by zaky on 20/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "UIButton+Indicator.h"
#import "NSString+Font.h"
#import <objc/runtime.h>

static NSString *const IndicatorViewKey = @"indicatorView";
static NSString *const ButtonTextObjectKey = @"buttonTextObject";
static NSString *const ImageViewKey = @"imageView";
@implementation UIButton (Indicator)

- (void)showIndicatorWithTitle:(NSString *)title{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self setTitle:title.length > 0 ? title:@"" forState:UIControlStateNormal];
    CGFloat width = [self.titleLabel.text getWidthWithMaxHeight:24 inFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
    indicator.center = CGPointMake(self.bounds.size.width / 2 - width/2 - 25, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &ButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &IndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.enabled = NO;
    [self addSubview:indicator];
}

- (void)showIndicator{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2 , self.bounds.size.height / 2);;
    [indicator startAnimating];
    
    objc_setAssociatedObject(self, &IndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.enabled = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:indicator];
}

- (void)hideIndicator{
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &ButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &IndicatorViewKey);
    
    self.enabled = YES;
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
}

/** 显示图片 */
- (void)showWithImageName:(NSString *)imageName title:(NSString *)title bgColor:(UIColor *)bgColor{
    
    [self setTitle:title.length > 0 ? title:@"" forState:UIControlStateNormal];
    self.backgroundColor = bgColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.bounds = CGRectMake(0, 0, 25, 25);
    
    CGFloat width = [self.titleLabel.text getWidthWithMaxHeight:24 inFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:16]];
    imageView.center = CGPointMake(self.bounds.size.width / 2 - width/2 - 30, self.bounds.size.height / 2);
    NSString *currentButtonText = self.titleLabel.text;
    objc_setAssociatedObject(self, &ButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ImageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
    self.enabled = NO;
    [self addSubview:imageView];
}

/** 隐藏图片 */
- (void)hideImage{
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &ButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &ImageViewKey);
    
    self.enabled = YES;
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
}

@end
