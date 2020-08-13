//
//  ABCOneKeyRegisterBFBHelper.h
//  HYGEntire
//
//  Created by zaky on 18/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddBFBBlock)(void);
@interface ABCOneKeyRegisterBFBHelper : NSObject

+(id)shareInstance;
+(void)attempDealloc;

/// 牛逼的一键绑定主方法
/// @param addBFBBlock 回调方法 刷新界面
- (void)startOneKeyRegisterBFBHandler:(AddBFBBlock)addBFBBlock;

//- (void)sendVerifyCode:(nullable void(^)(void))successHandler;
//
//- (void)bindBitollAccount:(NSString *)accountNo
//                  handler:(void(^)(void))successHandler;

@end

NS_ASSUME_NONNULL_END
