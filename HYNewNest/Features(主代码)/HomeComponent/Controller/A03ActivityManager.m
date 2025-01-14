//
//  A03ActivityManager.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "A03ActivityManager.h"
#import "CNHomeRequest.h"
#import "PublicMethod.h"
#import "RedPacketsRequest.h"

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
- (void)checkTimeRedPacketRainWithCompletion:(RedPacketCallBack _Nullable)redPacketBlock
                       WithDefaultCompletion:(RedPacketCallBack _Nullable)defaultBlock
{
    WEAKSELF_DEFINE
    [RedPacketsRequest getRainInfoTask:^(id responseObj, NSString *errorMsg) {
        weakSelf.redPacketInfoModel = [RedPacketsInfoModel cn_parse:responseObj];
        weakSelf.redPacketInfoModel.isDev = NO;
#ifdef DEBUG
        BOOL isRainningSetting = [[NSUserDefaults standardUserDefaults] boolForKey:RedPacketCustomSetting];
        if (isRainningSetting == YES)
        {
            NSString *selectString = [[NSUserDefaults standardUserDefaults] objectForKey:RedPacketRainningSelectValue];
            NSArray * timeArray = [selectString componentsSeparatedByString:@":"];
            int firstStartHour = [[timeArray firstObject] intValue];
            int firstStartMins = [[timeArray lastObject] intValue];
            int firstEndHour = (firstStartMins + 1) < 60 ? firstStartHour : (firstStartHour + 1);
            int firstEndMins = (firstStartMins + 1) < 60 ? (firstStartMins + 1) : 0;
            int secondStartHour = (firstEndMins + 1 < 60 ? firstEndHour : (firstEndHour + 1));
            int secondStartMins = firstEndMins + 1;
            int secondEndHour = (secondStartMins + 1 < 60 ? secondStartHour : (secondStartHour + 1));
            int secondEndMins = secondStartMins + 1;
            weakSelf.redPacketInfoModel.isDev = YES;
            weakSelf.redPacketInfoModel.firstStartAt = [NSString stringWithFormat:@"%d:%d:00",firstStartHour,firstStartMins];
            weakSelf.redPacketInfoModel.firstEndAt =  [NSString stringWithFormat:@"%d:%d:00",firstEndHour,firstEndMins];
            weakSelf.redPacketInfoModel.secondStartAt =  [NSString stringWithFormat:@"%d:%d:00",secondStartHour,secondStartMins];
            weakSelf.redPacketInfoModel.secondEndAt =  [NSString stringWithFormat:@"%d:%d:00",secondEndHour,secondEndMins];
        }
#endif
        [weakSelf serverTime:^(NSString *timeStr) {
            if (timeStr.length > 0)
            {
                NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
                BOOL isBeforeDuration = [duractionArray[0] boolValue];
                BOOL isActivityDuration = [duractionArray[1] boolValue];
                if (isBeforeDuration || isActivityDuration)
                {
                    // 不到时间,预热
                    // 活动期间
                    if (redPacketBlock)
                    {
                        redPacketBlock(isActivityDuration ? @"1" : nil,nil);
                    }
                }else
                {
                    // 过了活动期
                    if (defaultBlock)
                    {
                        defaultBlock(nil,nil);
                    }
                }
            }
        }];
    }];
}
-(void)serverTime:(CheckTimeCompleteBlock)completeBlock {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    completeBlock([dateFormatter stringFromDate:timeDate]);
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
