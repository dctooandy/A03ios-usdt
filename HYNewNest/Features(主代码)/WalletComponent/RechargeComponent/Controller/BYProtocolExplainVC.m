//
//  BYProtocolExplainVC.m
//  HYNewNest
//
//  Created by zaky on 4/24/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYProtocolExplainVC.h"

@interface BYProtocolExplainVC ()

@end

@implementation BYProtocolExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = self.view.bounds;
    self.view.layer.mask = layer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
