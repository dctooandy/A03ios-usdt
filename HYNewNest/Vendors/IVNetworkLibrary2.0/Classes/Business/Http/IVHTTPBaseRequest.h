//
//  IVBaseRequest.h
//  IVNetworkLibrary2.0
//
//  Created by Key on 14/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "KYHTTPManager.h"
#import "IVJResponseObject.h"
#import "UIDevice+IVInfo.h"
#import "NSDictionary+IVN.h"

NS_ASSUME_NONNULL_BEGIN


/**
 *  运行环境
 */
typedef NS_ENUM(NSInteger,IVNEnvironment){
//    IVNEnvironmentDevelop = 0,// 开发
    IVNEnvironmentTest = 0,// 测试
//    IVNEnvironmentPublishTest = 2,// 运测
    IVNEnvironmentPublish = 1,// 运营
};

@interface IVHTTPBaseRequest : KYHTTPManager

@property (nonatomic, assign) IVNEnvironment environment;
/**
 appId
 */
@property (nonatomic, copy) NSString *appId;
/**
 登录用户token
 */
@property (nonatomic, copy) NSString *token;
/**
 登录用户名
 */
@property (nonatomic, copy) NSString *loginName;

/**
 当前使用的网关
 */
@property (nonatomic, copy) NSString *gateway;

/**
 产品标识
 */
@property (nonatomic, copy) NSString *productId;
/**
 productCode
 */
@property (nonatomic, copy) NSString *productCode;
/**
 渠道标识
 */
@property (nonatomic, copy) NSString *parentId;
/**
 扩展header
 非全局，只是当前请求添加。如果需要设置全局，请使用[IVHttpManager shareManager].extendedHeaders方式
 如果原header中存在已有字段，使用extendedHeadersz中的值
 */
@property (nonatomic, copy) NSDictionary *extendedHeaders;
@property (nonatomic, copy) NSString *qid;
@property (nonatomic, strong) id parameters;
@end

NS_ASSUME_NONNULL_END
