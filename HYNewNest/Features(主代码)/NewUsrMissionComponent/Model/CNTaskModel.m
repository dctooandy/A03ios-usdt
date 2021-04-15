//
//  CNTaskModel.m
//  HYNewNest
//
//  Created by zaky on 4/13/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNTaskModel.h"

@implementation Result
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID": @"id"};
}
@end


@implementation LimiteTask
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [Result class]};
}
@end


@implementation LoginTask
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [Result class]};
}
@end


@implementation UpgradeTask
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [Result class]};
}
@end


@implementation CNTaskModel
- (BOOL)isBeyondClaimTime {
    // 倒计时结束失效
    NSString *endDate = self.end_date;
    NSDate *eDate = [NSDate jk_dateWithString:endDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval sec = [eDate timeIntervalSinceNow];
    return sec <= 0;
}
@end
