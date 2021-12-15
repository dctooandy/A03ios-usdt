//
//  AppdelegateManager.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/8.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppdelegateManager : NSObject
@property (nonatomic, assign) IVNEnvironment environment;
/**
所有网关列表
 */
@property (nonatomic, copy, nullable) NSArray *gateways;
/**
所有网关列表
 */
@property (nonatomic, copy, nullable) NSArray *websides;
+ (instancetype)shareManager ;
- (void)checkDomainHandler:(void (^)(void))handler ;
- (void)recheckDomainWithTestSpeed;
@end

NS_ASSUME_NONNULL_END
