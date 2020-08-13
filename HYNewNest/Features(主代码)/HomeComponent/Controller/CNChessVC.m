//
//  CNChessVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNChessVC.h"

@interface CNChessVC ()

@end

@implementation CNChessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)totalHeight {
    // 1个模块
    CGFloat itemHeight = (kScreenWidth - 15*2) * 140/345.0;
    return  (itemHeight + 16);
}

// AS真人
- (IBAction)ASReal:(id)sender {
    [NNPageRouter jump2GameName:@"AS真人棋牌" gameType:@"BAC" gameId:@"" gameCode:@"A03064"];
}

@end
