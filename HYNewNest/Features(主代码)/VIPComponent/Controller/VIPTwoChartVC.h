//
//  VIPTwoChartVC.h
//  HYNewNest
//
//  Created by zaky on 9/7/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VIPChartType) {
    VIPChartTypeBigGodBoard, // 大神榜
    VIPChartTypeRankRight,   // 等级特权
};

NS_ASSUME_NONNULL_BEGIN

@interface VIPTwoChartVC : UIViewController
- initWithType:(VIPChartType)type;
@end

NS_ASSUME_NONNULL_END
