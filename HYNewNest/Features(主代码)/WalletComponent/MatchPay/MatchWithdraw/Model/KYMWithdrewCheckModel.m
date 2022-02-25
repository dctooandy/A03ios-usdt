//
//  KYMWithdrewCheckModel.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewCheckModel.h"

@implementation KYMWithdrewCheckDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"amountList" : [KYMWithdrewAmountModel class]};
}
- (void)setAmountList:(NSArray<KYMWithdrewAmountModel *> *)amountList
{
    _amountList = amountList;
    
    if (amountList.count <= 0) {
        return;
    }
    NSString *miniAmountStr = amountList[0].amount;
    for (int i = 0; i < amountList.count; i++) {
        if (i > 0) {
            CGFloat amount = [amountList[i].amount doubleValue];
            CGFloat miniAmount = [miniAmountStr doubleValue];
            miniAmount = MIN(amount, miniAmount);
            miniAmountStr = [NSString stringWithFormat:@"%0.lf",miniAmount];
        }
    }
    self.miniAmount = miniAmountStr;
}
- (void)removeAmountBiggerThanTotal:(NSString *)totatlAmount
{
    if (self.amountList.count == 0) {
        return;
    }
    NSMutableArray *mArr = self.amountList.mutableCopy;
    for (KYMWithdrewAmountModel *model in self.amountList) {
        if ([totatlAmount doubleValue] < [model.amount doubleValue]) {
            [mArr removeObject:model];
        }
    }
    self.amountList = mArr.copy;
}
@end

@implementation KYMWithdrewCheckModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [KYMWithdrewCheckDataModel class]};
}
- (void)setData:(KYMWithdrewCheckDataModel *)data
{
    _data = data;
}
@end
