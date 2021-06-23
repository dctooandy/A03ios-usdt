//
//  BYNewbieModel.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/24.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieModel.h"

@implementation BYNewbieTaskModel
- (BOOL)isBeyondClaimTime {
    // 倒计时结束失效
    NSString *endDate = self.end_date;
    NSDate *eDate = [NSDate jk_dateWithString:endDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval sec = [eDate timeIntervalSinceNow];
    return sec <= 0;
}
@end

