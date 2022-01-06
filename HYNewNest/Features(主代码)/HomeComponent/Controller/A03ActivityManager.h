//
//  A03ActivityManager.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A03PopViewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PopViewCallBack)(A03PopViewModel * _Nullable response, NSString * _Nullable error);
@interface A03ActivityManager : NSObject

+ (A03ActivityManager *)sharedInstance;

//检查wms弹窗API
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock;
// 自动配出现在的CDN+URLPath
- (NSString *)nowCDNString:(NSString *)cdnString WithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
