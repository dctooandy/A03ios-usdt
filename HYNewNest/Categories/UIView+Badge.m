//
//  UIView+Badge.m
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "UIView+Badge.h"

@implementation UIView (Badge)

- (void)showRightTopImageName:(NSString *)imgName size:(CGSize)size offsetX:(float)offsetX offsetYMultiple:(float)offsetYM {
    UIImage *img = [UIImage imageNamed:imgName];
    NSAssert(img, @"找不到badge图片");
    UIImageView *badgeImgv = [[UIImageView alloc] init];
    badgeImgv.tag = 999;
    badgeImgv.image = img;
    CGRect tabFrame = self.frame;//確定小紅點的位置
    if (offsetX == 0) {
        offsetX = 1;
    }
    if (offsetYM == 0) {
        offsetYM = 0.01;
    }
    CGFloat x = ceilf(tabFrame.size.width + offsetX);
    CGFloat y = ceilf(offsetYM * tabFrame.size.height);
    badgeImgv.frame = CGRectMake(x, y, size.width, size.height);
    [self addSubview:badgeImgv];
    
}

//新增顯示
- (void)showRedAtOffSetX:(float)offsetX offsetYMultiple:(float)offsetYM OrValue:(NSString *)value{
    [self removeRedPoint];//新增之前先移除,避免重複新增
    //新建小紅點
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 998;
    CGFloat viewWidth = 12;
    if (value) {
        viewWidth = 18;
        UILabel *valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        valueLbl.text = value;
        valueLbl.font = [UIFont fontPFR12];
        valueLbl.textColor = [UIColor whiteColor];
        valueLbl.textAlignment = NSTextAlignmentCenter;
        valueLbl.clipsToBounds = YES;
        [badgeView addSubview:valueLbl];
    }

    badgeView.layer.cornerRadius = viewWidth / 2;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;//確定小紅點的位置
    if (offsetX == 0) {
        offsetX = 1;
    }
    if (offsetYM == 0) {
        offsetYM = 0.05;
    }
    CGFloat x = ceilf(tabFrame.size.width + offsetX);
    CGFloat y = ceilf(offsetYM * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, viewWidth, viewWidth);
    [self addSubview:badgeView];
}

//隱藏
- (void)hideRedPoint{
    [self removeRedPoint];
}

//移除
- (void)removeRedPoint{
    //按照tag值進行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 998 || subView.tag == 999) {
            [subView removeFromSuperview];
        }
    }
}


- (void)showRedPoint:(CGPoint)point value:(NSInteger )value {
    CGFloat viewWidth = 18;
    UILabel *valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(point.x-viewWidth*0.5, point.y-viewWidth*0.5, viewWidth, viewWidth)];
    valueLbl.text = [NSString stringWithFormat:@"%ld", value];
    valueLbl.font = [UIFont fontPFR12];
    valueLbl.textColor = [UIColor whiteColor];
    valueLbl.textAlignment = NSTextAlignmentCenter;
    valueLbl.backgroundColor = [UIColor redColor];
    valueLbl.clipsToBounds = YES;
    valueLbl.layer.cornerRadius = viewWidth*0.5;
    [self addSubview:valueLbl];
}

@end
