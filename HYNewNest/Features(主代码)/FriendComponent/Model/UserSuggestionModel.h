//
//  UserSuggestionModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**{
    "content":"456",
    "createdDate":"2020-08-05 11:49:48",
    "flag":"2",
    "lastUpdate":"2020-08-05 14:25:33",
    "remarks":"您好，您有遇到任何问题可以随时联系在线客服的哦，24小时为您服务，祝您游戏愉快、盈利多多",
    "sendTo":0,
    "subject":"客户反馈建议",
    "suggestType":"0"
}*/

/// 意见反馈模型
@interface UserSuggestionModel : CNBaseModel

/// 内容
@property (nonatomic, copy) NSString *content;
/// 时间
@property (nonatomic, copy) NSString *createdDate;
/// 内容是：“客户反馈内容”
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger sendTo;
@property (nonatomic, assign) NSInteger suggestType;
@property (nonatomic, copy) NSString *remarks;
/// 时间
@property (nonatomic, copy) NSString *lastUpdate;
@end

NS_ASSUME_NONNULL_END
