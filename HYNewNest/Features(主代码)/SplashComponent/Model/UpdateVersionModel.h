//
//  UpdateVersionModel.h
//  INTEDSGame
//
//  Created by bux on 2018/5/1.
//  Copyright © 2018年 INTECH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateVersionModel : CNBaseModel

@property(nonatomic,strong) NSString *appDownUrl;
@property(nonatomic,strong) NSString *versionCode;
@property(nonatomic,strong) NSDictionary *upgradeDesc;
@property(nonatomic,strong) NSString *versionId;
@property(nonatomic,strong) NSString *flag;
@property (strong,nonatomic) NSArray *domains;

@end
