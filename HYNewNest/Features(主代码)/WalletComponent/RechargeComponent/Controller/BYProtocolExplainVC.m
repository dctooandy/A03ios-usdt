//
//  BYProtocolExplainVC.m
//  HYNewNest
//
//  Created by zaky on 4/24/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYProtocolExplainVC.h"

@interface BYProtocolExplainVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;

@end

@implementation BYProtocolExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kHexColor(0x212137);
    
}

- (void)viewWillLayoutSubviews {
    
    _viewWidthCons.constant = kScreenWidth;
    [super viewWillLayoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = self.view.bounds;
    self.view.layer.mask = layer;
}


@end
