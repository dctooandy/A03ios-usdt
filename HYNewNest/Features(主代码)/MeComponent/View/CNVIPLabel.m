//
//  CNVIPLabel.m
//  HYNewNest
//
//  Created by Cean on 2020/7/25.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNVIPLabel.h"

@interface CNVIPLabel ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation CNVIPLabel

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addBorderColder:self fromColor:kHexColor(0xFFE8A8) toColor:kHexColor(0x826020)];
    self.layer.cornerRadius = self.frame.size.height * 0.5;
    self.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
}

- (void)addBorderColder:(UIView *)boarderView fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = boarderView.bounds;
    gradientLayer.colors = @[(id)fromColor.CGColor, (id)toColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [boarderView.layer insertSublayer:gradientLayer atIndex:0];
}
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:fontSize];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}
@end
