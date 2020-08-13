//
//  CNSportVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNSportVC.h"

@interface CNSportVC ()

@end

@implementation CNSportVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat)totalHeight {
    // 3个模块，间隔 16
    CGFloat itemHeight = (kScreenWidth - 15*2) * 115/345.0;
    return  (itemHeight + 16) * 3;
}

// 进入沙巴
- (IBAction)SABA:(id)sender {
    [NNPageRouter jump2GameName:@"沙巴体育" gameType:@"7" gameId:@"" gameCode:@"A03031"];
}

// 进入易胜博
- (IBAction)YSB:(id)sender {
    [NNPageRouter jump2GameName:@"易胜博体育" gameType:@"" gameId:@"" gameCode:@"A03068"];
}

// 进入环亚
- (IBAction)HY:(id)sender {
    [NNPageRouter jump2GameName:@"币游体育" gameType:@"" gameId:@"" gameCode:@"A03062"];
}



@end
