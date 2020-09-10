//
//  VIPMonlyAlertCell.h
//  HYNewNest
//
//  Created by zaky on 9/3/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "V_SlideCardCell.h"
#import "VIPMonthlyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VIPMonlyAlertType) {
    VIPMonlyAlertTypePersonal = 0,   //个人战报
    VIPMonlyAlertTypeCondition,      //入会情况
    VIPMonlyAlertTypeValue,          //送出价值

};

@protocol VIPMonlyAlertDelegate <NSObject>
// 看看月报
- (void)didTapMonthlyReport;
// 领取奖励
- (void)didTapReceiveGift;
// 滑动下一个(关闭)
- (void)didTapNextOne;
@end

@interface VIPMonlyAlertCell : V_SlideCardCell

- (void)setupAlertType:(VIPMonlyAlertType)type delegate:(id)delegate dataDict:(VIPMonthlyModel *)model;

@end

NS_ASSUME_NONNULL_END
