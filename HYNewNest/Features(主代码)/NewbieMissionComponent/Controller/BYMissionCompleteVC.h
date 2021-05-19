//
//  BYMissionCompleteVC.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    MissionCompleteTypeFirstFill = 0,
    MissionCompleteTypeMore
} MissionCompleteType;

@interface BYMissionCompleteVC : CNBaseVC
@property (nonatomic, assign) MissionCompleteType type;
@end

NS_ASSUME_NONNULL_END
