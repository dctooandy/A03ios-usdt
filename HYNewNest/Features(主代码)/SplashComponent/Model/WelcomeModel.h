//
//  WelcomeModel.h
//  INTEDSGame
//
//  Created by bux on 2018/3/26.
//  Copyright © 2018年 INTECH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNBaseModel.h"
#import "UpdateVersionModel.h"


@interface WelcomeModel : CNBaseModel

@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) NSString *key0;
@property(nonatomic,copy) NSString *link;
@property(nonatomic,copy) NSString *addrServiceUrl;
@property(nonatomic,copy) NSString *mWebUrl;
@property(nonatomic,copy) NSString *h5DownUrl;
@property(nonatomic,copy) NSString *h5VersionId;
@property(nonatomic,copy) NSString *h5Md5;
@property(nonatomic,copy) NSString *publicKey;
@property(nonatomic,copy) NSString *info;
@property(nonatomic,copy) NSString *webInfo;



@end

@interface InfoModel : CNBaseModel
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *u2token;

@end

