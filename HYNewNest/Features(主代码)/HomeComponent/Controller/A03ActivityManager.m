//
//  A03ActivityManager.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "A03ActivityManager.h"
#import "CNHomeRequest.h"

@interface A03ActivityManager()
@property(nonatomic,strong)A03PopViewModel * popModel;
@end
@implementation A03ActivityManager
static A03ActivityManager * sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedSingleton = [[A03ActivityManager alloc] init];
        
    }
}
+ (A03ActivityManager *)sharedInstance {
    return sharedSingleton;
}
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock {
    
    WEAKSELF_DEFINE
    [CNHomeRequest checkPopviewHandler:^(id responseObj, NSString *errorMsg) {
        A03PopViewModel *subModel = [A03PopViewModel cn_parse:responseObj];
        if (subModel)
        {
            self->_popModel = subModel;
            int isShowType =[weakSelf.popModel.isShow intValue];
            switch (isShowType) {
//                    1. 预热时间内
//                    2. 活动时间内
//                    3. 不在预热也不在活动, 但有配置 (月工资弹窗)
//                    4. 今天不用再弹弹窗 (什么弹窗都不出现了)
                case 0://没配置任何东西
                    completionBlock(nil,nil);
                    break;
                case 1://预热彈窗
                    completionBlock(weakSelf.popModel,nil);
                    break;
                case 2://活动彈窗
                    completionBlock(nil,nil);
                    break;
                case 3://不在预热也不在活动, 但有配置
                    completionBlock(nil,nil);
                    break;
                case 4://今天不用再弹弹窗 (什么弹窗都不出现了)
                    completionBlock(nil,nil);
                    break;
                default:
                    break;
            }
        }
        
    }];
}
- (NSString *)nowCDNString:(NSString *)cdnString WithUrl:(NSString *)url {
    NSString *domainUrl = nil;
    domainUrl = [cdnString isEqualToString:@""] ? [IVHttpManager shareManager].cdn : cdnString ;
    BOOL cdn = [domainUrl hasSuffix:@"/"];
    BOOL urlStr = [url hasPrefix:@"/"];
    BOOL urlHttpStr = [url hasPrefix:@"http"];
    NSString *str = nil;
    if (cdn) {
        str = [domainUrl substringToIndex:domainUrl.length - 1];
    } else {
        str = domainUrl;
    }
    if (urlHttpStr)
    {
        str = url;
    }else{
        if (urlStr) {
            str = [NSString stringWithFormat:@"%@/%@",str,[url substringFromIndex:1]];
        } else {
            str = [NSString stringWithFormat:@"%@/%@",str,url];
        }
    }
    return str;
}

@end
