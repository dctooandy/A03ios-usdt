//
//  ArticalModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticalModel : CNBaseModel
@property(nonatomic,copy) NSString *abstractName;
@property(nonatomic,copy) NSString *appGroup;
@property(nonatomic,copy) NSString *articleContent;
@property(nonatomic,copy) NSString *articleId;
@property(nonatomic,copy) NSString *articleType;
@property(nonatomic,copy) NSString *bannerTopUrl; //!<置顶的图片地址
@property(nonatomic,copy) NSString *bannerUrl;
@property(nonatomic,copy) NSString *commentCount;
@property(nonatomic,copy) NSString *flag;
@property(nonatomic,assign) BOOL isBanner; //!<是否是置顶到banner
@property(nonatomic,copy) NSString *layoutType; // 0（图片文章，有详情） 1（视频文章，有详情)  2(图片文章，无详情) 3(视频文章，无详情)
@property(nonatomic,copy) NSString *likeCount;
@property(nonatomic,copy) NSString *linkType;
@property(nonatomic,copy) NSString *linkUrl;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *pcLinkUrl;
@property(nonatomic,copy) NSString *pictureUrl;
@property(nonatomic,copy) NSString *publishDate;
@property(nonatomic,copy) NSString *readNum;
@property(nonatomic,copy) NSString *sortNo; //!<banner里的排序字段
@property(nonatomic,copy) NSString *tagList;
@property(nonatomic,copy) NSString *titleName;
@property(nonatomic,copy) NSString *upgradeNames;
@end

NS_ASSUME_NONNULL_END
