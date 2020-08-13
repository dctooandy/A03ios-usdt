//
//  OtherAppModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtherAppModel : CNBaseModel

@property (strong,nonatomic) NSString *appDesc;
@property (strong,nonatomic) NSString *appDownUrl;
@property (strong,nonatomic) NSString *appImage;
@property (strong,nonatomic) NSString *appName;
@property (strong,nonatomic) NSString *ID;

@end

NS_ASSUME_NONNULL_END
