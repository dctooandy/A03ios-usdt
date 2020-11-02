//
//  HYRechProcButton.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechProcButton.h"
@interface HYRechProcButton ()
@property (nonatomic, strong) CAShapeLayer *triangleLy;
@property (nonatomic, strong) UIImageView *gougou;
@end

@implementation HYRechProcButton

#pragma mark - LAZY

- (CAShapeLayer *)triangleLy {
    if (!_triangleLy) {
        CAShapeLayer *trangle = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.width-24, self.height)];
        [path addLineToPoint:CGPointMake(self.width, self.height-24)];
        [path addLineToPoint:CGPointMake(self.width, self.height)];
        [path addLineToPoint:CGPointMake(self.width-24, self.height)];
        trangle.path = path.CGPath;
        UIColor *color = [UIColor jk_gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withHeight:self.height];
        trangle.fillColor = color.CGColor;
        [self.layer addSublayer:trangle];
        _triangleLy = trangle;
    }
    return _triangleLy;
}

- (UIImageView *)gougou {
    if (!_gougou) {
        UIImageView *gougou = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-16, self.height-16, 16, 16)];
        gougou.image = [UIImage imageNamed:@"icon-choosen"];
        gougou.contentMode = UIViewContentModeCenter;
        [self addSubview:gougou];
        _gougou = gougou;
    }
    return _gougou;
}


#pragma mark - INIT

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

- (instancetype)commonInit {
    
//    self.backgroundColor = kHexColor(0x212137);
    self.titleLabel.font = [UIFont fontPFR15];
    
    UIColor *gcolor = [UIColor jk_gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withHeight:40];
    [self setTitleColor:gcolor forState:UIControlStateSelected];
    [self setTitleColor:kHexColor(0x6D778B) forState:UIControlStateNormal];
        
    self.layer.borderColor = kHexColor(0x6D778B).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        // 选中样式
        UIColor *gcolor = [UIColor jk_gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withHeight:40];
        self.layer.borderColor = gcolor.CGColor;
        self.titleLabel.font = [UIFont fontPFM15];
        
        self.triangleLy.hidden = NO;
        self.gougou.hidden = NO;
        
    } else {
        self.layer.borderColor = kHexColor(0x6D778B).CGColor;
        self.titleLabel.font = [UIFont fontPFR15];
        
        self.triangleLy.hidden = YES;
        self.gougou.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
