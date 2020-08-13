//
//  XmPlatformModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 平台旗下洗码
@interface XmPlatformListItem :CNBaseModel
@property (nonatomic , copy) NSString              * xmName;
@property (nonatomic , copy) NSString              * xmRate;//洗码比例
@property (nonatomic , copy) NSString              * xmType;//洗码类型

@end

/// 洗码平台模型
@interface XmPlatformModel :CNBaseModel
@property (nonatomic , assign) NSInteger              xmConfigId;
@property (nonatomic , copy) NSString              * xmConfigName;
@property (nonatomic , strong) NSArray <XmPlatformListItem *>  * xmPlatformList;

@end

NS_ASSUME_NONNULL_END
