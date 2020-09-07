//
//  TAExampleDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-23.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAExampleDotView.h"

static CGFloat const kAnimateDuration = 1;

@interface TAExampleDotView ()
{
    CGPoint _origPoint;
    CGSize _origSize;
}
@end

@implementation TAExampleDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (void)initialization
{
    self.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.5);
    self.layer.cornerRadius = self.width*0.5;
    
}


- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    _origPoint = self.jk_origin;
    _origSize = self.size;
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.height = self->_origSize.height * 2;
        self.y = self->_origPoint.y - self->_origSize.height;
        self.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x2E99F0) toColor:kHexColor(0x02EED9) withHeight:self.height];
    } completion:nil];
}

- (void)animateToDeactiveState
{

    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.5);
        self.height = self->_origSize.height;
        self.y = self->_origPoint.y;
    } completion:nil];
}

@end
