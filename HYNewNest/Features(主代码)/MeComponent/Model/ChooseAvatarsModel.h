//
//  ChooseAvatarsModel.h
//  HyEntireGame
//
//  Created by bux on 2018/10/16.
//  Copyright © 2018 kunlun. All rights reserved.
//

#import "CNBaseModel.h"


@interface AvatarGroupModel : NSObject

@property (strong,nonatomic) NSString *groupId; //!<分组id
@property (strong,nonatomic) NSString *groupName; //!<分组名称
@property (strong,nonatomic) NSArray *imgs; //!<图片组

@end

@interface ChooseAvatarsModel : CNBaseModel

@property (strong, nonatomic) NSDictionary *avatars;
@property (strong,nonatomic) NSDictionary *types; 
@property (strong,nonatomic) NSString *baseUrl; //!<图片地址 前半部分
@property (strong,nonatomic) NSString *defaultAvatar; //!<默认头像


//额外属性
@property (strong,nonatomic) NSMutableArray *groupTitles; //!<分组名称组
@property (strong,nonatomic) NSMutableArray *groups; //!<头像组
/// 生成额外属性
-(void)formatGroups;

@end


