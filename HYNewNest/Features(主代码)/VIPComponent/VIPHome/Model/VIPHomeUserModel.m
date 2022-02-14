//
//  VIPHomeUserModel.m
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPHomeUserModel.h"

@implementation HistoryBet
@end


@implementation EquityDataItem
- (NSNumber*)depositCNYAmount
{
    return [NSNumber numberWithInt:(_depositAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)betCNYAmount
{
    return [NSNumber numberWithInt:(_betAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)ydfhCnyAmount
{
    return [NSNumber numberWithInt:(_ydfhAmount.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)rhljCnyAmount
{
    return [NSNumber numberWithInt:(_rhljAmount.intValue * CnyAndUsdtRate)];
}
@end


@implementation VIPHomeUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"equityData": [EquityDataItem class],
             @"prizeList": [VIPRewardAnocModel class]};
}
- (NSNumber*)totalDepositCNYAmount
{
    return [NSNumber numberWithInt:(_totalDepositAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)totalBetCNYAmount
{
    return [NSNumber numberWithInt:(_totalBetAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSArray <EquityDataItem *>*)equityData
{
    if (_equityData.count > 0)
    {
        return  _equityData;
    }else
    {
        NSArray *tempArray = [[NSArray alloc] init];
        EquityDataItem *tempEquityData1 = [[EquityDataItem alloc] init];
        tempEquityData1.betAmount = @9282000;
        tempEquityData1.clubLevel = @"2";
        tempEquityData1.currency = @"USDT";
        tempEquityData1.depositAmount = @1391000;
        tempEquityData1.rhljAmount = @268;
        tempEquityData1.ydfhAmount = @128;
        tempEquityData1.zzzpTime = @"3";

        EquityDataItem *tempEquityData2 = [[EquityDataItem alloc] init];
        tempEquityData2.betAmount = @18570500;
        tempEquityData2.clubLevel = @"3";
        tempEquityData2.currency = @"USDT";
        tempEquityData2.depositAmount = @3250000;
        tempEquityData2.rhljAmount = @568;
        tempEquityData2.ydfhAmount = @158;
        tempEquityData2.zzzpTime = @"5";

        EquityDataItem *tempEquityData3 = [[EquityDataItem alloc] init];
        tempEquityData3.betAmount = @46423000;
        tempEquityData3.clubLevel = @"4";
        tempEquityData3.currency = @"USDT";
        tempEquityData3.depositAmount = @7891000;
        tempEquityData3.rhljAmount = @858;
        tempEquityData3.ydfhAmount = @208;
        tempEquityData3.zzzpTime = @"10";

        EquityDataItem *tempEquityData4 = [[EquityDataItem alloc] init];
        tempEquityData4.betAmount = @92852500;
        tempEquityData4.clubLevel = @"5";
        tempEquityData4.currency = @"USDT";
        tempEquityData4.depositAmount = @13923000;
        tempEquityData4.rhljAmount = @2388;
        tempEquityData4.ydfhAmount = @258;
        tempEquityData4.zzzpTime = @"15";

        EquityDataItem *tempEquityData5 = [[EquityDataItem alloc] init];
        tempEquityData5.betAmount = @185711500;
        tempEquityData5.clubLevel = @"6";
        tempEquityData5.currency = @"USDT";
        tempEquityData5.depositAmount = @32500000;
        tempEquityData5.rhljAmount = @5588;
        tempEquityData5.ydfhAmount = @308;
        tempEquityData5.zzzpTime = @"20";

        EquityDataItem *tempEquityData6 = [[EquityDataItem alloc] init];
        tempEquityData6.betAmount = @371423000;
        tempEquityData6.clubLevel = @"7";
        tempEquityData6.currency = @"USDT";
        tempEquityData6.depositAmount = @0;
        tempEquityData6.rhljAmount = @9888;
        tempEquityData6.ydfhAmount = @388;
        tempEquityData6.zzzpTime = @"30";

        tempArray = @[tempEquityData1,tempEquityData2,tempEquityData3,tempEquityData4,tempEquityData5,tempEquityData6];
        return tempArray.copy;
    }
}
@end
