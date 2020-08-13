//
//  CNGloryRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "ArticalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNGloryRequest : CNBaseNetworking

typedef NS_ENUM(NSInteger, A03ArticleTagList) {
    A03ArticleTagListEssence = 0, //精选
    A03ArticleTagListMasterGame,  //大师赛
    A03ArticleTagListTrends,      //动态
    A03ArticleTagListBrief,       //简报
    A03ArticleTagListDigit        //数字播报
};


/// 获取文章列表 （风采，数字播报）
/// @param tagList 文章类型
+ (void)getA03ArticlesTagList:(A03ArticleTagList)tagList handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
