//
//  OCBarrageBackgroundColorTextCell.m
//  OCBarrage
//
//  Created by QMTV on 2017/8/25.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "OCBarrageGradientBackgroundColorCell.h"

@implementation OCBarrageGradientBackgroundColorCell

- (void)updateSubviewsData {
    [super updateSubviewsData];
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self.textLabel setAttributedText:nil];
    [self addSubview:self.textLabel];
}

- (void)layoutContentSubviews {
    [super layoutContentSubviews];
    [self addGradientLayer];
}

- (void)convertContentToImage {
    UIImage *contentImage = [self.layer convertContentToImageWithSize:_gradientLayer.frame.size];
    [self.layer setContents:(__bridge id)contentImage.CGImage];
}

- (void)removeSubViewsAndSublayers {
    [super removeSubViewsAndSublayers];
    
    _gradientLayer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.center = _gradientLayer.position;
}

- (void)addGradientLayer {
    if (!self.gradientDescriptor.gradientColor) {
        return;
    }
    
    // A03需求需要，外面增加背景圆角边框
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)self.gradientDescriptor.gradientColor.CGColor, (__bridge id)self.gradientDescriptor.gradientColor.CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0.0, 0.0, self.textLabel.frame.size.width+60.0, self.textLabel.frame.size.height+24);
    
    gradientLayer.cornerRadius = gradientLayer.bounds.size.height *0.5;
    _gradientLayer = gradientLayer;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setBarrageDescriptor:(OCBarrageDescriptor *)barrageDescriptor {
    [super setBarrageDescriptor:barrageDescriptor];
    self.gradientDescriptor = (OCBarrageGradientBackgroundColorDescriptor *)barrageDescriptor;
}

@end
