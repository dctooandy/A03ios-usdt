//
//  KYMNetworingWrapper.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewRequest.h"


@implementation KYMWithdrewRequest


+ (void)checkChannelWithParams:(NSDictionary *)params callback:(KYMCallback)callback {
    kym_sendRequest(@"deposit/checkChannel",params, ^(BOOL status, NSString * msg , NSDictionary *body) {
        if (body == nil || body == NULL || ![body isKindOfClass:[NSDictionary class]]) {
            callback(NO, msg ? : @"操作失败，数据异常",@"");
            return;
        }
        KYMWithdrewCheckModel *model = [KYMWithdrewCheckModel yy_modelWithJSON:body];
        NSString *errMsg = model.message ? : msg;
        if ([model.code isEqualToString:@"00000"]) {
            callback(YES,model.message,model);
        } else {
            callback(NO,errMsg,model);
        }
    });
}
+ (void)createWithdrawWithParams:(NSDictionary *)params callback:(KYMCallback)callback {
    kym_sendRequest(@"withdraw/createRequest",params, ^(BOOL status, NSString * msg , id body) {
        if (body == nil || body == NULL || ![body isKindOfClass:[NSDictionary class]]) {
            callback(NO, msg ? : @"操作失败，数据异常",@"");
            return;
        }
        KYMCreateWithdrewModel *model = nil;
        model = [KYMCreateWithdrewModel yy_modelWithJSON:body];
        callback(status,msg,model);
    });
}
+ (void)getWithdrawDetailWithParams:(NSDictionary *)params callback:(KYMCallback)callback {
    kym_sendRequest(@"withdraw/getMMWithDrawDetail",params, ^(BOOL status, NSString * msg , id body) {
        if (body == nil || body == NULL || ![body isKindOfClass:[NSDictionary class]]) {
            callback(NO, msg ? : @"操作失败，数据异常",@"");
            return;
        }
        KYMGetWithdrewDetailModel *model = [KYMGetWithdrewDetailModel yy_modelWithJSON:body];
        
        callback(status,msg,model);
    });
}
+ (void)checkReceiveStatus:(NSDictionary *)params callback:(KYMCallback)callback {
    kym_sendRequest(@"withdraw/withdrawOperate",params, ^(BOOL status, NSString * msg , NSDictionary *body) {
        if (body == nil || body == NULL || ![body isKindOfClass:[NSDictionary class]]) {
            callback(NO, msg ? : @"操作失败，数据异常",@"");
            return;
        }
        KYMCheckReceiveModel *model = [KYMCheckReceiveModel yy_modelWithJSON:body];
        NSString *errMsg = model.message ? : msg;
        if ([model.code isEqualToString:@"00000"]) {
            callback(YES,model.message,model);
        } else {
            callback(NO,errMsg,model);
        }
    });
}
+ (void)cancelWithdrawWithParams:(NSDictionary *)params callback:(KYMCallback)callback {
    kym_sendRequest(@"withdraw/cancelRequest",params, ^(BOOL status, NSString * msg , id body) {
        if (body == nil || body == NULL || ![body isKindOfClass:[NSNumber class]]) {
            callback(NO, msg ? : @"操作失败，数据异常",@"");
            return;
        }
        if ([body boolValue]) {
            callback(YES, msg ,@(YES));
        } else {
            callback(NO, msg ,@(NO));
        }
    });
}
@end
