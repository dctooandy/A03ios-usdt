//
//  GameModel.h
//  HyEntireGame
//
//  Created by kunlun on 2018/9/27.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "CNBaseModel.h"


@interface PostMapModel : CNBaseModel

@property(nonatomic,copy) NSString *gameID;
@property(nonatomic,copy) NSString *gameType;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *username;

@end


/// InGame 接口获取到的游戏模型
@interface GameModel : CNBaseModel

@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *formMethod;
@property(nonatomic,strong) PostMapModel *postMap;

@end



