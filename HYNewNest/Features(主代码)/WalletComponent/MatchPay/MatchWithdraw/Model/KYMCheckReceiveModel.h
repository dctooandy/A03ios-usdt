//
//  KYMResponseBodyModel.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/23.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMCheckReceiveModel : NSObject
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *requestId;
@end

NS_ASSUME_NONNULL_END
