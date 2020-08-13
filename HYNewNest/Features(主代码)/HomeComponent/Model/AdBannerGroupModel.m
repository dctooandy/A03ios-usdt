//
//  AdBannerGroupModel.m
//  HYGEntire
//
//  Created by zaky on 21/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "AdBannerGroupModel.h"

@implementation AdBannerModel

@end

@implementation AdBannerGroupModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"bannersModel":@"imageGroups.TOP_BANNER"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"bannersModel":[AdBannerModel class]};
}

@end


@implementation DYAdBannerGroupModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"bannersModel":@"imageGroups.ZR_APP_SLOT_BANNER"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"bannersModel":[AdBannerModel class]};
}

@end

@implementation FriendShareGroupModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"bannersModel":@"imageGroups.SHARING_SET"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"bannersModel":[AdBannerModel class]};
}

@end
