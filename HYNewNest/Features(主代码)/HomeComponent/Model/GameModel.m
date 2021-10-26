//
//  GameModel.m
//  HyEntireGame
//
//  Created by kunlun on 2018/9/27.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "GameModel.h"

@implementation PostMapModel

@end
@implementation PostMapNewModel

@end
@implementation GameModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
//    return @{@"postMap":[PostMapModel class]};
    return @{@"postMapNew":[PostMapNewModel class]};
}

@end
