//
//  IVOtherInfoModel.h
//  SuperSignSupport
//
//  Created by key.l on 17/10/2019.
//  Copyright © 2019 key.l. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVOtherInfoModel : NSObject
@property (nonatomic, copy) NSString *developer;
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *udidEncrypt;
@property (nonatomic, copy) NSString *agentId;
@property (nonatomic, strong) id signParam;
@property (nonatomic, copy) NSString *signParamString;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) NSMutableDictionary *undefinedKeyDict;
@end

NS_ASSUME_NONNULL_END
