//
//  VIPNewVersionView.m
//  HYNewNest
//
//  Created by zaky on 9/6/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPNewVersionView.h"

#define kRedColor kHexColor(0x8F1C34)
#define kGBKFont  [UIFont fontWithName:@"FZLTDHK--GBK1-0" size:24]

@interface VIPNewVersionView ()
@property (weak, nonatomic) IBOutlet UILabel *attrTopLb;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UILabel *btmLb;
@property (weak, nonatomic) IBOutlet UILabel *btmSubLb;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
@property (weak, nonatomic) IBOutlet UIView *btmGradientView;

@end

@implementation VIPNewVersionView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.btmGradientView.backgroundColor = [self gradientFromColor:kHexColor(0xA6683B) toColor:kHexColor(0xDA9F5E) withWidth:71];
}

- (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width
{
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

- (void)setIdx:(NSInteger)idx {
    _idx = idx;
    
    //TODO:-
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"累计身份\n最高领百万" attributes:@{NSFontAttributeName:kGBKFont, NSForegroundColorAttributeName:kRedColor}];
    self.attrTopLb.attributedText = attrStr;
}

@end
