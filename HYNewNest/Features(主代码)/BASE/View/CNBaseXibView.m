//
//  CNBaseXibView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

@implementation CNBaseXibView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadViewFromXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)loadViewFromXib {
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (!contentView) {
        return;
    }
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

@end
