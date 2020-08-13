//
//  ElecGameModel.h
//  HyEntireGame
//
//  Created by kunlun on 2018/9/27.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "CNBaseModel.h"

#pragma mark - 最近玩过
@interface ElecGameParamItem: CNBaseModel
@property (nonatomic , copy) NSString              * gameId;
@property (nonatomic , copy) NSString              * gameType;
@property (nonatomic , copy) NSString              * divName;
@property (nonatomic , copy) NSString              * gameName;
@property (nonatomic , copy) NSString              * gameCode;
@property (nonatomic , copy) NSString              * playLine;
@end


/// 最近玩过的电游
@interface ElecLogGameModel : CNBaseModel

@property(nonatomic,copy) NSString *gameImg;
@property(nonatomic,copy) NSString *gameName;
@property(nonatomic,strong) ElecGameParamItem *gameParam;
@property(nonatomic,copy) NSString *platformDisplayName;

@end


#pragma mark - 电游模型

/// 电游模型
@interface ElecGameModel : CNBaseModel

@property(nonatomic,copy) NSString *gameId;
@property(nonatomic,copy) NSString *gameImage;
@property(nonatomic,copy) NSString *gameName;
@property(nonatomic,copy) NSString *gameNameEn;
@property(nonatomic,assign) BOOL isFavorite; //是否收藏
@property(nonatomic,assign) BOOL isUpHot; //是否热门
@property(nonatomic,copy) NSString *payLine;
@property(nonatomic,copy) NSString *platformCode;
@property(nonatomic,copy) NSString *platformName;
@property(nonatomic,copy) NSString *gameType;
@property(nonatomic,assign) BOOL tryFlag;
@property(nonatomic,copy) NSString *gameHotValue; //??
@property(nonatomic,copy) NSString *popularity; //??
@end


/// 电游列表模型
@interface QueryElecGameModel : CNBaseModel

@property(nonatomic,copy) NSString *totalRow;
@property(nonatomic,assign) NSInteger totalPage;
@property(nonatomic,copy) NSString *pageSize;
@property(nonatomic,copy) NSString *pageNo;
@property(nonatomic,copy) NSArray <ElecGameModel *>*data;


@end






