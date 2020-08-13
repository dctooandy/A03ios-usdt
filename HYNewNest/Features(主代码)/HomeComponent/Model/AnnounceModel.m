//
//  AnnounceModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "AnnounceModel.h"

@implementation AnnounceModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"announceID":@"id"};
}
@end
