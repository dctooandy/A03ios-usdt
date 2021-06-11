//
//  BYMissionCompleteVC.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    MissionCompleteTypeLimite = 0,
    MissionCompleteTypeMore
} MissionCompleteType;

@interface BYMissionCompleteVC : CNBaseVC
@property (nonatomic, assign) MissionCompleteType type;
@property (nonatomic, strong) CNTaskReceived *result;
@property (nonatomic, strong) NSMutableArray<CNTaskReceived *> *resultArray;
@end

NS_ASSUME_NONNULL_END
