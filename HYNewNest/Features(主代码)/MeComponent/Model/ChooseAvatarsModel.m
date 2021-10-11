//
//  ChooseAvatarsModel.m
//  HyEntireGame
//
//  Created by bux on 2018/10/16.
//  Copyright © 2018 kunlun. All rights reserved.
//

#import "ChooseAvatarsModel.h"


@implementation AvatarGroupModel

@end

@implementation ChooseAvatarsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"defaultAvatar":@"default"};
}

- (void)formatGroups{
    self.groupTitles = [NSMutableArray array];
    self.groups = [NSMutableArray array];
    [self.groupTitles addObject:@"全部"];
    
    NSArray *sortedKeys= [[self.types allKeys]sortedArrayUsingSelector:@selector(compare:)];
    if (self.avatars.count > 0) {
        for (NSString *key in sortedKeys) {
            NSString *title = self.types[key];
            if ([title containsString:@"女郎"]) {
                title = @"女郎";
            }
            [self.groupTitles addObject:[NSString stringWithFormat:@"%@",title]];
            
            AvatarGroupModel *group = [[AvatarGroupModel alloc]init];
            group.groupId = [NSString stringWithFormat:@"%@",key];
            group.groupName = [NSString stringWithFormat:@"%@",title];
            group.imgs = [NSArray arrayWithArray:self.avatars[group.groupId]];
            [self.groups addObject:group];
        }
    }
    
    //插入系统默认头像组到第一组
    AvatarGroupModel *systemDefaultGroup = [[AvatarGroupModel alloc]init];
    systemDefaultGroup.groupName = @"系统默认";
    systemDefaultGroup.imgs = [NSArray arrayWithObject:self.defaultAvatar?:@"1.png"];
    [self.groups insertObject:systemDefaultGroup atIndex:0];
}

@end
