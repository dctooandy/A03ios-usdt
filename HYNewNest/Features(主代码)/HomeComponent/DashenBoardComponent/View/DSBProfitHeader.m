//
//  DSBProfitHeader.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBProfitHeader.h"
#import "UILabel+Gradient.h"
#import "BYDashenBoardConst.h"


@interface DSBProfitHeader()

// socket
@property (weak, nonatomic) IBOutlet UIView *dewdropBoard;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *zhuangNum;
@property (weak, nonatomic) IBOutlet UILabel *xianNum;
@property (weak, nonatomic) IBOutlet UILabel *heNum;
@property (weak, nonatomic) IBOutlet UILabel *zhuangduiNum;
@property (weak, nonatomic) IBOutlet UILabel *xianduiNum;


@end

@implementation DSBProfitHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundView = ({
//        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
//        bg.backgroundColor = [UIColor clearColor];
//        bg;
//    });
    [self drawLines];
}

- (void)drawLines {
    // 线的路径 横线
    CGFloat ballWH = 32;
    for (int i=0; i<6; i++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, ballWH + ballWH*i)];
        [linePath addLineToPoint:CGPointMake(self.dewdropBoard.width, ballWH + ballWH*i)];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 1;
        lineLayer.strokeColor = kSepaLineColor.CGColor;
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil;
        [self.dewdropBoard.layer addSublayer:lineLayer];
    }
    // 线的路径 竖线
    for (int i=0; i<11; i++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(ballWH+i*ballWH, 0)];
        [linePath addLineToPoint:CGPointMake(ballWH+i*ballWH, self.dewdropBoard.height)];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 1;
        lineLayer.strokeColor = kSepaLineColor.CGColor;
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil;
        [self.dewdropBoard.layer addSublayer:lineLayer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

}

@end
