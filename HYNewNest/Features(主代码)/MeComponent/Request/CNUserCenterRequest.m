//
//  CNUserCenterRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"

@implementation CNUserCenterRequest

+ (void)modifyUserRealName:(nullable NSString *)realName
                    gender:(nullable NSString *)gender
                     birth:(nullable NSString *)birth
                    avatar:(nullable NSString *)avatar
          onlineMessenger2:(nullable NSString *)onlineMessenger2
                     email:(nullable NSString *)email
                   handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    if (!KIsEmptyString(realName)) {
        param[@"realName"] = realName;
    }
    if (!KIsEmptyString(gender)) {
        param[@"gender"] = gender;
    }
    if (!KIsEmptyString(birth)) {
        param[@"birth"] = birth;
    }
    if (!KIsEmptyString(avatar)) {
        param[@"avatar"] = avatar;
    }
    if (!KIsEmptyString(onlineMessenger2)) {
        param[@"onlineMessenger2"] = onlineMessenger2;
    }
    if (!KIsEmptyString(email)) {
        param[@"email"] = email;
    }
    
    [self POST:(config_modifyUserInfo) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        // 刷新信息
        [CNLoginRequest getUserInfoByTokenCompletionHandler:nil];
        handler(responseObj, errorMsg);
    }];
}

+ (void)getAllAvatarsHanlder:(HandlerBlock)handler {
    [self POST:kGatewayExtraPath(config_new_requestAvatars) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)requestOtherGameAppListHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:[CNUserManager shareManager].userInfo.token?:@"" forKey:@"token"];
    
    [self POST:kGatewayExtraPath(config_home_otherGame) parameters:paramDic completionHandler:handler];
}

+ (void)queryLimitBonusValueHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"keys"] = @"limitRedValue";
    
    [self POST:kGatewayExtraPath(config_new_queryByKeyList) parameters:param completionHandler:handler];
}

+ (void)changeLimitBonusContent:(NSString *)content
                        handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"content"] = content;
    
    [self POST:(config_changeLimitBonus) parameters:param completionHandler:handler];
}

+ (void)queryLetterPageNo:(NSInteger)pageNo
                 pageSize:(NSInteger)pageSize
                  handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"pageNo"] = @(pageNo);
    param[@"pageSize"] = @(pageSize);
    
    [self POST:(config_letter_query) parameters:param completionHandler:handler];
}

+ (void)queryUserSubscribHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"type"] = @(1); //订阅类型[1:短信; 2:邮件; 3:站内信][暂时只支持短信]
    
    [self POST:(config_subscrib_query) parameters:param completionHandler:handler];
}

+ (void)modifyUserSubscribArray:(NSArray<UserSubscribItem *> *)subscribes
                        handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"type"] = @(1);
    NSMutableArray *subArr = @[].mutableCopy;
    for (UserSubscribItem *item in subscribes) {
        [subArr addObject:@{@"subscribed":item.subscribed, @"code":item.code}];
    }
    param[@"subscribes"] = subArr;
    
    [self POST:(config_subscrib_modify) parameters:param completionHandler:handler];
}

+ (void)cancelWithdrawBillRequestId:(NSString *)referenceId
                            handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"referenceId"] = referenceId;
    
    [self POST:(config_drawCancelRequest) parameters:param completionHandler:handler];
}

+ (void)reminderBillReferenceId:(NSString *)referenceId
                           type:(NSInteger)type
                        handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"referenceId"] = referenceId;
    param[@"type"] = @(type);
    
    [self POST:(config_reminder) parameters:param completionHandler:handler];
}

+ (void)submitSugestionContent:(NSString *)content handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"content"] = content;
    
    [self POST:(config_sugestion) parameters:param completionHandler:handler];
}

+ (void)querySuggestionHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"pageSize"] = @100;
    
    [self POST:(config_querySugestion) parameters:param completionHandler:handler];
}

+ (void)queryAgentRecordsHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"flag"] = @4;
    
    [self POST:kGatewayExtraPath(config_queryAgentRecord) parameters:param completionHandler:handler];
}

@end
