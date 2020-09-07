//
//  VIPNewVersionView.m
//  HYNewNest
//
//  Created by zaky on 9/6/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPNewVersionView.h"

#define kRedColor       kHexColor(0x8F1C34)
#define kGBKFont(s)     [UIFont fontWithName:@"FZLTDHK--GBK1-0" size:(s)]

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
    
    self.btmGradientView.backgroundColor = [self gradientFromColor:kHexColor(0xA6683B) toColor:kHexColor(0xDA9F5E) withWidth:kScreenWidth-16*2];
}

- (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width
{
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

- (void)setIdx:(NSInteger)idx {
    _idx = idx;
    NSMutableAttributedString *attrStr;
    
    switch (idx) {
        case 0:
            attrStr = [[NSMutableAttributedString alloc] initWithString:@"VIP私享会2.0\n" attributes:@{NSFontAttributeName:[UIFont fontPFM14], NSForegroundColorAttributeName:kRedColor}];
            [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"全新来袭" attributes:@{NSFontAttributeName:kGBKFont(31), NSForegroundColorAttributeName:kRedColor}]];
            self.contentTv.text = @"福利加码\n 赌尊降临";
            [self.btmBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            break;
        case 1:
            attrStr = [[NSMutableAttributedString alloc] initWithString:@"累计身份\n最高领百万" attributes:@{NSFontAttributeName:kGBKFont(24), NSForegroundColorAttributeName:kRedColor}];
            self.contentTv.text = @"累计私享会身份可领取礼品\n最少3次就可领\n24重超值礼品等您来拿\n最高可领百万大奖";
            [self.btmBtn setTitle:@"福利月" forState:UIControlStateNormal];
            break;
        case 2:
            attrStr = [[NSMutableAttributedString alloc] initWithString:@"全新赌尊等级\n享受更高权益" attributes:@{NSFontAttributeName:kGBKFont(24), NSForegroundColorAttributeName:kRedColor}];
            self.contentTv.text = @"入会礼金  9,888usdt\n转盘次数30次\n月分红 388usdt";
            [self.btmBtn setTitle:@"累计身份" forState:UIControlStateNormal];
            break;
        case 3:
            attrStr = [[NSMutableAttributedString alloc] initWithString:@"超级福利月\n百万大奖" attributes:@{NSFontAttributeName:kGBKFont(24), NSForegroundColorAttributeName:kRedColor}];
            self.contentTv.text = @"4月、8月、12月为专属福利月\n至尊转盘奖品大升级\n价值百万超级神秘大奖\n超高中奖率等您来抽";
            [self.btmBtn setTitle:@"我了解了" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.attrTopLb.attributedText = attrStr;
}

- (IBAction)didTapVersionBtn:(UIButton *)sender {
    MyLog(@"+++ %@", sender.titleLabel.text)
    if (self.tapBlock) {
        self.tapBlock(self.idx);
    }
}

@end
