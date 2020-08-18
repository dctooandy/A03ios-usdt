//
//  CNRealPersonVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNRealPersonVC.h"
#import "CNGameLineView.h"

@interface CNRealPersonVC ()

@end

@implementation CNRealPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (CGFloat)totalHeight {
    // 2个模块，间隔 16
    CGFloat itemHeight = (kScreenWidth - 15*2) * 115/345.0;
    return  (itemHeight + 16) * 2;
}

// 进入AGQJ
- (IBAction)AGQJ:(id)sender {
    NSLog(@"AGQJ");
    [CNGameLineView choseCnyLineHandler:([CNUserManager shareManager].isUsdtMode == NO) ? (^{
        //???: CNY 线路是啥？
        
    }):nil choseUsdtLineHandler:^{
        [NNPageRouter jump2GameName:@"真人百家乐-旗舰厅" gameType:@"BAC" gameId:@"" gameCode:@"A03003"];
    }];
}

// 进入AGIN
- (IBAction)AGIN:(id)sender {
    [NNPageRouter jump2GameName:@"真人百家乐-国际厅" gameType:@"BAC" gameId:@"" gameCode:@"A03026"];
}


@end
