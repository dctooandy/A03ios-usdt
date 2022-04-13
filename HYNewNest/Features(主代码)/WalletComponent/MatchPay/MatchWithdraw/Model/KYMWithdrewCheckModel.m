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
    if (amountList.count > 9) {
        self.currentAmountList = [amountList subarrayWithRange:NSMakeRange(0, 9)];
    } else {
        self.currentAmountList = amountList;
    }
}
- (void)setInputAmount:(NSString *)inputAmount
{
    _inputAmount = inputAmount;
    self.currentAmountList = [self getRecommendAmountFromAmount:inputAmount];
    
}
/// 计算合理推荐金额
- (NSArray *)getRecommendAmountFromAmount:(NSString *)amount {
    
    NSArray *sourceArray = self.amountList;
    
    if (sourceArray.count < 9) {
        return sourceArray;
    }
    
    if (amount == nil || amount.length == 0) {
        return [sourceArray subarrayWithRange:NSMakeRange(0, 9)];
    }
    
    NSMutableArray *sortArr = [sourceArray mutableCopy];
    KYMWithdrewAmountModel *model = [KYMWithdrewAmountModel new];
    model.amount = amount;
    [sortArr addObject:model];
    
    sortArr = [[sortArr sortedArrayUsingComparator:^NSComparisonResult(KYMWithdrewAmountModel *  _Nonnull obj1, KYMWithdrewAmountModel *  _Nonnull obj2) {
        if (obj1.amount.intValue < obj2.amount.intValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }] mutableCopy];
    
    NSInteger index = [sortArr indexOfObject:model];

    if (index <= 5) {
        return [sourceArray subarrayWithRange:NSMakeRange(0, 9)];
    } else if  (index > (sourceArray.count - 5)) {
        return [sourceArray subarrayWithRange:NSMakeRange(sourceArray.count - 9, 9)];
    } else {
        return [sourceArray subarrayWithRange:NSMakeRange(index - 5, 9)];
    }
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
