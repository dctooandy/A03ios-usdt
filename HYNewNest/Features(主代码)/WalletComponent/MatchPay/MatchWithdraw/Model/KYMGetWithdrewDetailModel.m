//
//  KYMGetWithdrewDetailModel.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMGetWithdrewDetailModel.h"

@implementation KYMGetWithdrewDetailDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (void)setBankAccountNo:(NSString *)bankAccountNo
{
    _bankAccountNo = bankAccountNo;
    if (_bankAccountNo.length > 4) {
        _bankAccountNo = [_bankAccountNo substringToIndex:4];
        _bankAccountNo = [NSString stringWithFormat:@"%@ xxxx xxxx xxxx",_bankAccountNo];
    }
}
- (void)setBankIcon:(NSString *)bankIcon
{
    _bankIcon = bankIcon;
    if (_bankIcon.length < 2) {
        return;
    }
    if ([_bankIcon hasPrefix:@"/"]) {
        _bankIcon = [_bankIcon substringFromIndex:1];
    }
    _bankIcon = [NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].cdn,_bankIcon];
}
@end

@implementation KYMGetWithdrewDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [KYMGetWithdrewDetailDataModel class]};
}
- (void)setData:(KYMGetWithdrewDetailDataModel *)data
{
    _data = data;
}

@end
