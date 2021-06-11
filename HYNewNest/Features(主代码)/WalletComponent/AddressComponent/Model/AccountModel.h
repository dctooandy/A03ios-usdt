//
//  AccountModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountModel : CNBaseModel

@property (nonatomic , copy) NSString              * accountId;
@property (nonatomic , copy) NSString              * accountName;
@property (nonatomic , copy) NSString              * accountNo;
@property (nonatomic , copy) NSString              * accountType;
@property (nonatomic , copy) NSString              * backgroundColor;
@property (nonatomic , copy) NSString              * bankAlias;
@property (nonatomic , copy) NSString              * bankBranchName;
@property (nonatomic , copy) NSString              * bankIcon;
@property (nonatomic , copy) NSString              * bankName;
@property (nonatomic , copy) NSString              * catalog;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * flag;
@property (nonatomic , assign) BOOL                isDefault;
@property (nonatomic , copy) NSString              * isOpen;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , copy) NSString              * protocol;
@property (nonatomic , copy) NSString              * province;

@end

NS_ASSUME_NONNULL_END
