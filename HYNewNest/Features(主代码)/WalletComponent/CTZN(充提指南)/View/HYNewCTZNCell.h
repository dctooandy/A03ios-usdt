//
//  HYNewCTZNCell.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTwoStatusBtn.h"
#import "CTZNModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYNewCTZNCell : UITableViewCell
@property (strong,nonatomic) CTZNModel *model;
@property (copy,nonatomic) void (^actionBlock)(NSString *type); //!<点了主按钮
@property (copy,nonatomic) void (^playBlock)(void); //!<点了播放视频
@end

NS_ASSUME_NONNULL_END
