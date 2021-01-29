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
    
    self.backgroundView = ({
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = kSepaLineColor;
        bg;
    });
    
    [self drawLines];
    
    // 点击头部滚到 盈利榜
    [self jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {

        id vc = [NNControllerHelper currentRootVcOfNavController];
        if ([NSStringFromClass([vc class]) isEqualToString:@"CNHomeVC"]) {
            for (UIView *view in [vc view].subviews) {
                if ([view isKindOfClass:[UIScrollView class]] && view.height > 500) {
                    UIScrollView *scroll = (UIScrollView *)view;
                    [scroll setContentOffset:CGPointMake(0, 674) animated:YES];
                    break;
                }
            }
        }
    }];
}

- (void)drawLines {

    // 线的路径 横线
    for (int i=0; i<6; i++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, kDewBall_WH + kDewBall_WH*i)];
        [linePath addLineToPoint:CGPointMake(self.dewdropBoard.width, kDewBall_WH + kDewBall_WH*i)];
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
        [linePath moveToPoint:CGPointMake(kDewBall_WH+i*kDewBall_WH, 0)];
        [linePath addLineToPoint:CGPointMake(kDewBall_WH+i*kDewBall_WH, kDewBall_WH*6)];
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
//
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // 格子线条颜色
//    CGContextSetStrokeColorWithColor(context, kSepaLineColor.CGColor);
//    CGContextBeginPath(context);
//
//    NSInteger numRows = 6;
//    NSInteger numColumns = 12; //列
//    CGFloat gridWH = AD(31.36);
//
//    // 背景色
////    CGRect rectangleGrid = CGRectMake(,,self.frame.size.width,gridHeight);
////    CGContextAddRect(context, rectangleGrid);
////    CGContextSetFillColorWithColor(context, [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor);
////    CGContextFillPath(context);
//
//    for (int i = 0; i < numColumns; i++) {
//        //columns 列
//        CGContextMoveToPoint(context, gridWH+i*gridWH, 0);
//        CGContextAddLineToPoint(context, gridWH+i*gridWH, self.dewdropBoard.height);
//    }
//    for (int i = 0; i < numRows; i++) {
//        //row 行
//        CGContextMoveToPoint(context, 0, gridWH+i*gridWH);
//        CGContextAddLineToPoint(context, self.dewdropBoard.width, gridWH+i*gridWH);
//    }
//
//    CGContextStrokePath(context);
//    CGContextSetAllowsAntialiasing(context, YES);
//
////    NSInteger gridNum = numRows * ;
////    for (int i = ; i < gridNum; i ++) {
////        int targetColumn = i%;
////        int targetRow = i/;
////        int targetX = targetColumn * (GRID_WIDTH+)+;
////        int targetY =  targetRow * (GRID_HEIGHT+)+;
////
////         NSString *gridStr = [NSString stringWithFormat:@"%d",i+];
////
////        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
////            UIColor *fontColor;
////            if (targetColumn ==  || targetColumn == ) {
////                fontColor = [UIColor redColor];
////            }
////            else
////            {
////                fontColor = [UIColor blackColor];
////            }
////
////            [gridStr drawInRect:CGRectMake(targetX, targetY, self.frame.size.width, GRID_WIDTH) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:],NSForegroundColorAttributeName:fontColor}];
////        }
////        else
////        {
////            [gridStr drawInRect:CGRectMake(targetX, targetY, self.frame.size.width, GRID_WIDTH) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
////
////            CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
////        }
////
////    }
//}



// 露珠
- (void)setupDrewsWith:(NSDictionary<NSString *,RoundResItem *> *)allDicts {
    
    NSInteger zong = 0;
    NSInteger zhuang = 0;
    NSInteger xian = 0;
    NSInteger he = 0;
    NSInteger zhuangdui = 0;
    NSInteger xiandui = 0;
    
    for (UIView *view in self.dewdropBoard.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    // 时间戳 升序排序
    NSArray *allVal = [allDicts allValues];
    NSArray *sortedArray = [allVal sortedArrayUsingComparator:^NSComparisonResult(RoundResItem *obj1, RoundResItem *obj2){
        if (obj1.timestamp > obj2.timestamp) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    
    // 6韩 12列
    CGFloat ballWH = AD(25.0);
    CGFloat centerSpace = (kDewBall_WH-ballWH) * 0.5;
    for (RoundResItem *item in sortedArray) {
        
        UILabel *ballLb = [UILabel new];
        ballLb.textColor = [UIColor whiteColor];
        ballLb.layer.cornerRadius = AD(12.5);
        ballLb.font = [UIFont fontPFRegular:AD(12)];
        ballLb.textAlignment = NSTextAlignmentCenter;
        
        if (item.pair.intValue == 1) {
            zhuangdui += 1;
        } else if (item.pair.intValue == 2) {
            xiandui += 1;
        }
        if (item.banker_val.intValue > item.player_val.intValue) {
            zhuang += 1;
            ballLb.layer.backgroundColor = kZhuanColor.CGColor;
            ballLb.text = @"庄";
        } else if (item.banker_val.intValue == item.player_val.intValue) {
            he += 1;
            ballLb.layer.backgroundColor = kHeColor.CGColor;
            ballLb.text = @"和";
        } else {
            xian += 1;
            ballLb.layer.backgroundColor = kXianColor.CGColor;
            ballLb.text = @"闲";
        }
        
        ballLb.frame = CGRectMake(kDewBall_WH * (zong/6) + centerSpace, kDewBall_WH * (zong%6) + centerSpace, ballWH, ballWH);
        [self.dewdropBoard addSubview:ballLb];
        
        zong += 1;
    }
    
    self.totalNum.text = [NSString stringWithFormat:@"总 %ld", zong];
    self.zhuangNum.text = [NSString stringWithFormat:@"庄 %ld", zhuang];
    self.xianNum.text = [NSString stringWithFormat:@"闲 %ld", xian];
    self.heNum.text = [NSString stringWithFormat:@"和 %ld", he];
    self.zhuangduiNum.text = [NSString stringWithFormat:@"庄对 %ld", zhuangdui];
    self.xianduiNum.text = [NSString stringWithFormat:@"闲对 %ld", xiandui];
}

@end
