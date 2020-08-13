//
//  CNUserDetailModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNUserDetailModel : CNBaseModel
/// 绑定比特币账户数量
@property (nonatomic , assign) NSInteger              btcNum;
/// 绑定银行卡数量
@property (nonatomic , assign) NSInteger              bankCardNum;
/// 绑定币付宝账户数量
@property (nonatomic , assign) NSInteger              bfbNum;
/// 绑定小金库数量
@property (nonatomic , assign) NSInteger              dcboxNum;
@property (nonatomic , assign) NSInteger              ethNum;
@property (nonatomic , assign) NSInteger              mbtcNum;

@property (nonatomic , assign) NSInteger              aliaNum;
@property (nonatomic , assign) NSInteger              aliqNum;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) NSInteger              blackFlag;
@property (nonatomic , copy) NSString              * clubLevel;
@property (nonatomic , copy) NSString              * customerId;
@property (nonatomic , assign) NSInteger              customerType;
/// 会员信用等级
@property (nonatomic , copy) NSString              * depositLevel;
/// 性别
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * integral;
@property (nonatomic , copy) NSString              * loginDate;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , assign) NSInteger              loginNameFlag;
@property (nonatomic , assign) NSInteger              mobileNoBind;
@property (nonatomic , copy) NSString              * mobileNo;
@property (nonatomic , assign) NSInteger              newAccountFlag;
@property (nonatomic , assign) NSInteger              newWalletFlag;
/// 绑定的微信
@property (nonatomic , copy) NSString              * onlineMessenger2;
/// 邮箱
@property (nonatomic, copy) NSString               *email;
@property (nonatomic , copy) NSString              * priorityLevel;
@property (nonatomic , copy) NSString              * promotionFlag;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * registDate;
/// 会员星级
@property (nonatomic , assign) NSInteger              starLevel;
///会员星级名称
@property (nonatomic , copy) NSString              * starLevelName;
@property (nonatomic , assign) NSInteger              subAccountFlag;
@property (nonatomic , assign) NSInteger              usdtNum;
@property (nonatomic , copy) NSString              * verifyCode;
@property (nonatomic, copy) NSString                *birthday;
@end

NS_ASSUME_NONNULL_END
