//
//  UserSuggestionModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 意见反馈模型
@interface UserSuggestionModel : CNBaseModel

/// 内容
@property (nonatomic, copy) NSString *content;
/// 时间
@property (nonatomic, copy) NSString *createdDate;
/// 内容是：“客户反馈内容”
@property (nonatomic, copy) NSString *subject;
/// 没有接口文档都不知道是些啥
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger sendTo;
@property (nonatomic, assign) NSInteger suggestType;
@end

NS_ASSUME_NONNULL_END
