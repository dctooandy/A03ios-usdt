//
//  CNCaptchaRequest.m
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNCaptchaRequest.h"

@implementation CNCaptchaRequest

+ (void)getPuzzleImageCode:(NSUInteger)type
         completionHandler:(HandlerBlock)completionHandler {
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    [self POST:config_generateSlider parameters:paras completionHandler:completionHandler];
}

+ (void)verifyPuzzleImageCode:(NSUInteger)type
                      captcha:(NSString *)captcha
                    captchaId:(NSString *)captchaId
                      handler:(HandlerBlock)completionHandler {
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"captcha"] = captcha;
    paras[@"captchaId"] = captchaId;
    [self POST:config_validateSlider parameters:paras completionHandler:completionHandler];
}

@end
