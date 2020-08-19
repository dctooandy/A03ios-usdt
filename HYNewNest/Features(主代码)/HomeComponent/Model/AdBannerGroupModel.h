//
//  AdBannerGroupModel.h
//  HYGEntire
//
//  Created by zaky on 21/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


/// banner子模型
@interface AdBannerModel : CNBaseModel

@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *imgCode;
@property (copy, nonatomic) NSString *imgExUrl;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *linkType;
@property (copy, nonatomic) NSString *linkUrl;
@property (assign, nonatomic) NSInteger sortNo;
@property (nonatomic, strong) NSDictionary *linkParam; //@{@"mode":@"usdt"} 判断banner是哪种模式下才展示

@end


@protocol AdBannerModel <NSObject>

@end


/// 首页banner模型
@interface AdBannerGroupModel : CNBaseModel

@property(nonatomic,copy)   NSString *customerId;
@property(nonatomic,copy)   NSString *domainName; //图片url头
@property(nonatomic,strong) NSArray <AdBannerModel *> *bannersModel;

@end


/// 电游banner模型
@interface DYAdBannerGroupModel : CNBaseModel

@property(nonatomic,copy)   NSString *customerId;
@property(nonatomic,copy)   NSString *domainName; //图片url头
@property(nonatomic,strong) NSArray <AdBannerModel *> *bannersModel;

@end

/// 好友推荐
@interface FriendShareGroupModel : CNBaseModel

@property(nonatomic,copy)   NSString *customerId;
@property(nonatomic,copy)   NSString *domainName; //url头
@property(nonatomic,strong) NSArray <AdBannerModel *> *bannersModel;

@end

NS_ASSUME_NONNULL_END
