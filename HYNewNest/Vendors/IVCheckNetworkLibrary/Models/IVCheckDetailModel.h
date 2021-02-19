//
//  IVCheckDetailModel.h
//  IVCheckNetwork
//
//  Created by Key on 13/08/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 检测网络状态类型
 */
typedef NS_ENUM(NSInteger,IVKCheckNetworkType){
    IVKCheckNetworkTypeUnkown = 0,// 未知
    IVKCheckNetworkTypeGateway = 1,// 网关
    IVKCheckNetworkTypeDomain = 2,// 手机站
    IVKCheckNetworkTypeGameDomian = 3,// GC
    IVKCheckNetworkTypeCDN = 4,// CDN
};

@interface IVCheckDetailModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) IVKCheckNetworkType type;
@end

NS_ASSUME_NONNULL_END
