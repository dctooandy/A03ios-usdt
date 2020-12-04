//
//  CNRealPersonVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNRealPersonVC.h"
#import "HYInGameHelper.h"

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

    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGQJ];
}

// 进入AGIN
- (IBAction)AGIN:(id)sender {

    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGIN];
}


@end
