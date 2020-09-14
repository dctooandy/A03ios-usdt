//
//  CNGloryRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNGloryRequest.h"

@implementation CNGloryRequest


NSString *const A03ArticleTagListString[] = {
    [A03ArticleTagListEssence] = @"精选",
    [A03ArticleTagListDigit] = @"数字播报",
    [A03ArticleTagListBrief] = @"币游简报",
    [A03ArticleTagListTrends] = @"币游动态",
    [A03ArticleTagListMasterGame] = @"AG环亚大师赛"
};

+ (void)getA03ArticlesTagList:(A03ArticleTagList)tagList
                      handler:(HandlerBlock)handler{
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"appGroup"] = @"GROUP_A03_H5_REAL_NEW";
//    param[] = @"5" forKey:@"articleType"]; //?数字播报才有?
    param[@"pageNo"] = @(1);
    param[@"pageSize"] = @(500);
    param[@"tagList"] = A03ArticleTagListString[tagList];
    
    [self POST:kGatewayExtraPath(config_getArticels) parameters:param completionHandler:handler];
}

@end
