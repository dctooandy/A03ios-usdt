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
//- (NSNumber*)depositCNYAmount
//{
//    return [NSNumber numberWithInt:(_depositAmount.intValue * CnyAndUsdtdDepositRate)];
//}
//- (NSNumber*)betCNYAmount
//{
//    return [NSNumber numberWithInt:(_betAmount.intValue * CnyAndUsdtdDepositRate)];
//}
//- (NSNumber*)ydfhCnyAmount
//{
//    return [NSNumber numberWithInt:(_ydfhAmount.intValue * CnyAndUsdtRate)];
//}
//- (NSNumber*)rhljCnyAmount
//{
//    return [NSNumber numberWithInt:(_rhljAmount.intValue * CnyAndUsdtRate)];
//}
@end


@implementation VIPHomeUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"equityData": [EquityDataItem class],
             @"prizeList": [VIPRewardAnocModel class]};
}
//- (NSNumber*)totalDepositCNYAmount
//{
//    return [NSNumber numberWithInt:(_totalDepositAmount.intValue * CnyAndUsdtdDepositRate)];
//}
//- (NSNumber*)totalBetCNYAmount
//{
//    return [NSNumber numberWithInt:(_totalBetAmount.intValue * CnyAndUsdtdDepositRate)];
//}
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
        tempEquityData1.rhljAmount = @1742;
        tempEquityData1.ydfhAmount = @832;
        tempEquityData1.zzzpTime = @"3";
        tempEquityData1.betAmountCNY = @64974000;
        tempEquityData1.betAmountUSDT = @9282000;
        tempEquityData1.depositAmountCNY = @8346000;
        tempEquityData1.depositAmountUSDT = @1391000;
        tempEquityData1.clubName = @"赌侠";
        tempEquityData1.chance = @"3";
        tempEquityData1.membershipBonusCNY = @10452;
        tempEquityData1.membershipBonusUSDT = @1742;
        tempEquityData1.monthlyDividendCNY = @4992;
        tempEquityData1.monthlyDividendUSDT = @832;

        EquityDataItem *tempEquityData2 = [[EquityDataItem alloc] init];
        tempEquityData2.betAmount = @18570500;
        tempEquityData2.clubLevel = @"3";
        tempEquityData2.currency = @"USDT";
        tempEquityData2.depositAmount = @3250000;
        tempEquityData2.rhljAmount = @3692;
        tempEquityData2.ydfhAmount = @1027;
        tempEquityData2.zzzpTime = @"5";
        tempEquityData2.betAmountCNY = @129993500;
        tempEquityData2.betAmountUSDT = @18570500;
        tempEquityData2.depositAmountCNY = @19500000;
        tempEquityData2.depositAmountUSDT = @3250000;
        tempEquityData2.clubName = @"赌霸";
        tempEquityData2.chance = @"5";
        tempEquityData2.membershipBonusCNY = @22152;
        tempEquityData2.membershipBonusUSDT = @3692;
        tempEquityData2.monthlyDividendCNY = @6162;
        tempEquityData2.monthlyDividendUSDT = @1027;

        EquityDataItem *tempEquityData3 = [[EquityDataItem alloc] init];
        tempEquityData3.betAmount = @46423000;
        tempEquityData3.clubLevel = @"4";
        tempEquityData3.currency = @"USDT";
        tempEquityData3.depositAmount = @7891000;
        tempEquityData3.rhljAmount = @5577;
        tempEquityData3.ydfhAmount = @1352;
        tempEquityData3.zzzpTime = @"10";
        tempEquityData1.betAmountCNY = @324961000;
        tempEquityData1.betAmountUSDT = @46423000;
        tempEquityData1.depositAmountCNY = @47346000;
        tempEquityData1.depositAmountUSDT = @7891000;
        tempEquityData1.clubName = @"赌王";
        tempEquityData1.chance = @"10";
        tempEquityData1.membershipBonusCNY = @33462;
        tempEquityData1.membershipBonusUSDT = @5577;
        tempEquityData1.monthlyDividendCNY = @8112;
        tempEquityData1.monthlyDividendUSDT = @1352;

        EquityDataItem *tempEquityData4 = [[EquityDataItem alloc] init];
        tempEquityData4.betAmount = @92852500;
        tempEquityData4.clubLevel = @"5";
        tempEquityData4.currency = @"USDT";
        tempEquityData4.depositAmount = @13923000;
        tempEquityData4.rhljAmount = @15522;
        tempEquityData4.ydfhAmount = @1677;
        tempEquityData4.zzzpTime = @"15";
        tempEquityData1.betAmountCNY = @649967500;
        tempEquityData1.betAmountUSDT = @92852500;
        tempEquityData1.depositAmountCNY = @83538000;
        tempEquityData1.depositAmountUSDT = @13923000;
        tempEquityData1.clubName = @"赌圣";
        tempEquityData1.chance = @"15";
        tempEquityData1.membershipBonusCNY = @93132;
        tempEquityData1.membershipBonusUSDT = @15522;
        tempEquityData1.monthlyDividendCNY = @10062;
        tempEquityData1.monthlyDividendUSDT = @1677;

        EquityDataItem *tempEquityData5 = [[EquityDataItem alloc] init];
        tempEquityData5.betAmount = @185711500;
        tempEquityData5.clubLevel = @"6";
        tempEquityData5.currency = @"USDT";
        tempEquityData5.depositAmount = @32500000;
        tempEquityData5.rhljAmount = @36322;
        tempEquityData5.ydfhAmount = @2002;
        tempEquityData5.zzzpTime = @"20";
        tempEquityData1.betAmountCNY = @1299980500;
        tempEquityData1.betAmountUSDT = @185711500;
        tempEquityData1.depositAmountCNY = @195000000;
        tempEquityData1.depositAmountUSDT = @32500000;
        tempEquityData1.clubName = @"赌神";
        tempEquityData1.chance = @"20";
        tempEquityData1.membershipBonusCNY = @217932;
        tempEquityData1.membershipBonusUSDT = @36322;
        tempEquityData1.monthlyDividendCNY = @12012;
        tempEquityData1.monthlyDividendUSDT = @2002;

        EquityDataItem *tempEquityData6 = [[EquityDataItem alloc] init];
        tempEquityData6.betAmount = @371423000;
        tempEquityData6.clubLevel = @"7";
        tempEquityData6.currency = @"USDT";
        tempEquityData6.depositAmount = @0;
        tempEquityData6.rhljAmount = @64272;
        tempEquityData6.ydfhAmount = @2522;
        tempEquityData6.zzzpTime = @"30";
        tempEquityData1.betAmountCNY = @2599961000;
        tempEquityData1.betAmountUSDT = @371423000;
        tempEquityData1.depositAmountCNY = @0;
        tempEquityData1.depositAmountUSDT = @0;
        tempEquityData1.clubName = @"赌尊";
        tempEquityData1.chance = @"30";
        tempEquityData1.membershipBonusCNY = @385632;
        tempEquityData1.membershipBonusUSDT = @64272;
        tempEquityData1.monthlyDividendCNY = @15132;
        tempEquityData1.monthlyDividendUSDT = @2522;

        tempArray = @[tempEquityData1,tempEquityData2,tempEquityData3,tempEquityData4,tempEquityData5,tempEquityData6];
        return tempArray.copy;
    }
}
@end
