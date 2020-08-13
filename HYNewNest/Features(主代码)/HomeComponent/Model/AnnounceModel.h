//
//  AnnounceModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 公告模型
@interface AnnounceModel : CNBaseModel
@property (copy, nonatomic) NSString *commentType;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *announceID;
@property (copy, nonatomic) NSString *title;
@end

NS_ASSUME_NONNULL_END
