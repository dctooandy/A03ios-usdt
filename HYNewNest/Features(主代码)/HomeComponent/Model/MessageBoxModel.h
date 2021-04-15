//
//  MessageBoxModel.h
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageBoxModel : CNBaseModel

@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * isLogin;
@property (nonatomic , copy) NSString              * domainList;
@property (nonatomic , copy) NSString              * parmas;
@property (nonatomic , copy) NSString              * domainListTwo;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * showType;

//字段。 fixedLevel：配置固定星级显示, level：配置大于等于星级显示
@property (nonatomic , copy) NSDictionary              * parmasDict;
@property (copy,nonatomic,nullable) NSString        * fixedLevel;
@property (copy,nonatomic,nullable) NSString        * level;
@end

NS_ASSUME_NONNULL_END
