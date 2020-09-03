//
//  VIPMonlyAlertCell.h
//  HYNewNest
//
//  Created by zaky on 9/3/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "V_SlideCardCell.h"

typedef NS_ENUM(NSInteger, VIPMonlyAlertType) {
    VIPMonlyAlertTypeCondition = 0, //入会情况
    VIPMonlyAlertTypeValue,         //送出价值
    VIPMonlyAlertTypePersonal       // 个人战报
};

NS_ASSUME_NONNULL_BEGIN

@interface VIPMonlyAlertCell : V_SlideCardCell

- (void)setupAlertType:(VIPMonlyAlertType)type AndDataDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
