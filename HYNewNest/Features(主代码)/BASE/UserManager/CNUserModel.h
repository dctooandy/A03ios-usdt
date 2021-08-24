//
//  CNUserModel.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/25.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SamePhoneLoginNameItem : CNBaseModel
@property (nonatomic , assign) NSInteger              customerLevel;
@property (nonatomic , copy) NSString              * flag;
@property (nonatomic , copy) NSString              * lastLoginDate;
@property (nonatomic , copy) NSString              * loginName;
@end

@interface SamePhoneLoginNameModel : CNBaseModel
@property (nonatomic , copy) NSString              * messageId;
@property (nonatomic , copy) NSString              * validateId;
@property (nonatomic , copy) NSArray<SamePhoneLoginNameItem *> * samePhoneLoginNames;
@property (nonatomic , copy) NSArray<SamePhoneLoginNameItem *> * loginNames;
@end

@interface CNUserModel : CNBaseModel

@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *beforeLoginDate;
@property (nonatomic, copy)NSString *currency; //账号上分货币
@property (nonatomic, copy)NSString *rfCode;
@property (nonatomic, assign)BOOL customerType; // 会员类型：YES 真钱，NO 试玩
@property (nonatomic, copy)NSString *loginName;
@property (nonatomic, copy)NSString *maxCustLevel; //？
@property (nonatomic, copy)NSString *mobileNo;
@property (nonatomic, assign)BOOL newAccountFlag;
@property (nonatomic, assign)BOOL newWalletFlag;
@property (nonatomic, copy)NSString *noLoginDays;
@property (nonatomic, copy)NSString *subAccountFlag;
@property (nonatomic, assign)NSInteger starLevel;// 等级
@property (nonatomic, copy)NSString *starLevelName;
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *uiMode;
@property (nonatomic, strong)NSArray *uiModeOptions;


@end

NS_ASSUME_NONNULL_END
