//
//  A03ActivityManager.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A03PopViewModel.h"
#import "RedPacketsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CheckTimeCompleteBlock)(NSString * timeStr);
typedef void(^RedPacketCallBack)(NSString * _Nullable response, NSString * _Nullable error);
typedef void(^PopViewCallBack)(A03PopViewModel * _Nullable response, NSString * _Nullable error);
@interface A03ActivityManager : NSObject
@property(nonatomic,strong)RedPacketsInfoModel * redPacketInfoModel;
+ (A03ActivityManager *)sharedInstance;

//检查wms弹窗API
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock;
// 检查客制活动期间
- (void)checkTimeRedPacketRainWithCompletion:(RedPacketCallBack _Nullable)redPacketBlock WithDefaultCompletion:(RedPacketCallBack _Nullable)defaultBlock;
// 自动配出现在的CDN+URLPath
- (NSString *)nowCDNString:(NSString *)cdnString WithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
