//
//  PayWayV3Model.m
//  HYGEntire
//
//  Created by zaky on 17/01/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "PayWayV3Model.h"

@implementation PayWayV3PayTypeItem

@end

@implementation PayWayV3Model
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"payTypeList": [PayWayV3PayTypeItem class]};
}
@end

@implementation DepositsBankModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID": @"id"};
}
@end

@implementation OnlineBankAmountType

@end

@implementation OnlineBankListItem

@end

@implementation OnlineBanksModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"bankList": [OnlineBankListItem class]};
}
@end




@implementation AmountListModel

@end


@implementation BQBankModel

@end
