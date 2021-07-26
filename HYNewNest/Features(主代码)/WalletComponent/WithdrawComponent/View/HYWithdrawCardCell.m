//
//  HYWithdrawCardCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawCardCell.h"
#import "UILabel+Gradient.h"
#import "NSURL+HYLink.h"
#import <UIImageView+WebCache.h>

@interface HYWithdrawCardCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProtocol;
@property (weak, nonatomic) IBOutlet UILabel *lblCardAddr;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

//@property (nonatomic, strong) CAShapeLayer *triangleLy;
//@property (nonatomic, strong) UIImageView *gougou;
@end

@implementation HYWithdrawCardCell

//- (CAShapeLayer *)triangleLy {
//    if (!_triangleLy) {
//        CAShapeLayer *trangle = [CAShapeLayer layer];
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(kScreenWidth-30-24, 86)];
//        [path addLineToPoint:CGPointMake(kScreenWidth-30, 86-24)];
//        [path addLineToPoint:CGPointMake(kScreenWidth-30, 86)];
//        [path addLineToPoint:CGPointMake(kScreenWidth-30-24, 86)];
//        trangle.path = path.CGPath;
//        UIColor *color = [UIColor jk_gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withHeight:self.bgView.height];
//        trangle.fillColor = color.CGColor;
//        [self.bgView.layer addSublayer:trangle];
//        _triangleLy = trangle;
//    }
//    return _triangleLy;
//}

//- (UIImageView *)gougou {
//    if (!_gougou) {
//        UIImageView *gougou = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30-16, 86-16, 16, 16)];
//        gougou.image = [UIImage imageNamed:@"icon-choosen"];
//        gougou.contentMode = UIViewContentModeCenter;
//        [self.bgView addSubview:gougou];
//        _gougou = gougou;
//    }
//    return _gougou;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView.backgroundColor = kHexColor(0x272749);
    self.bgView.layer.cornerRadius = 10;
//    self.bgView.layer.borderWidth = AD(1);
    self.bgView.layer.masksToBounds = YES;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        UIColor *color = [UIColor jk_gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withHeight:self.bgView.height];
        
        self.bgView.layer.borderColor = color.CGColor;
        [self.lblTitle setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
        self.lblCardAddr.textColor = kHexColor(0x19CECE);
        self.lblProtocol.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
        
//        self.triangleLy.hidden = NO;
//        self.gougou.hidden = NO;
        self.selectedImageView.hidden = false;
        
    } else {
        self.bgView.layer.borderColor = kHexColor(0x6D778B).CGColor;
        self.lblTitle.textColor = kHexColor(0x6D778B);
        self.lblCardAddr.textColor = kHexColorAlpha(0x10B4DD, 0.5);
        self.lblProtocol.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
        
//        self.triangleLy.hidden = YES;
//        self.gougou.hidden = YES;
        self.selectedImageView.hidden = true;
    }
}

- (void)setModel:(AccountModel *)model {
    _model = model;
    self.lblTitle.text = model.bankName;
    if ([CNUserManager shareManager].isUsdtMode) {
        self.lblProtocol.text = model.protocol;
    } else {
        self.lblProtocol.text = model.accountType;
    }
    self.lblCardAddr.text = model.accountNo;
    [self.imgvIcon sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon]];
}

@end
