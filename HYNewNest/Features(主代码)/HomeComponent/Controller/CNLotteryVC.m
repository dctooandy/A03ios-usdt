//
//  CNLotteryVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNLotteryVC.h"
#import "HYInGameHelper.h"

@interface CNLotteryVC ()

@end

@implementation CNLotteryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (CGFloat)totalHeight {
    // 2个模块，间隔 16
    CGFloat itemHeight = (kScreenWidth - 15*2) * 115/345.0;
//    return  (itemHeight + 16) * 2;
    return (itemHeight + 16);
}

// AG彩票
- (IBAction)AGLottery:(id)sender {
//    [NNPageRouter jump2GameName:@"彩票" gameType:@"" gameId:@"直接进厅" gameCode:@"A03004"];
    [[HYInGameHelper sharedInstance] inGame:InGameTypeKENO];
}

// QC刮刮乐
- (IBAction)QCLottery:(id)sender {
//    [NNPageRouter jump2GameName:@"QG刮刮乐" gameType:@"12" gameId:@"" gameCode:@"A03080"];
    [[HYInGameHelper sharedInstance] inGame:InGameTypeQG];
}


@end
