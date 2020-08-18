//
//  CreditQueryResultModel.m
//  INTEDSGame
//
//  Created by Robert on 12/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import "CreditQueryResultModel.h"

@implementation CreditQueryDataModel

- (UIColor *)statsColor {
    if ([self.flagDesc containsString:@"等待"] || [self.flagDesc containsString:@"待核"]) {
        return kHexColor(0xAEA876);
    } else if ([self.flagDesc containsString:@"完成"] || [self.flagDesc containsString:@"已到账"] || [self.flagDesc containsString:@"批准"]) {
        return kHexColor(0x5A9F7C);
    } else if ([self.flagDesc containsString:@"失效"] || [self.flagDesc containsString:@"取消"]) {
        return kHexColor(0xBD4848);
    } else {
        return kHexColor(0xADBACD);
    }
}

- (NSString *)gameKindName {
    switch ([self.gameKind integerValue]) {
        case 1:
            return @"体育";
            break;
        case 2:
            return @"电投";
            break;
        case 3:
            return @"真人";
            break;
        case 5:
            return @"电游";
            break;
        case 7:
            return @"棋牌";
            break;
        case 8:
            return @"捕鱼";
            break;
        case 12:
            return @"彩票";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)gamePlatName {
    NSDictionary * gamePlatDict = @{@"035":@"MG厅",@"027":@"TTG厅",@"051":@"BSG厅",@"052":@"PNG厅",@"039":@"PT厅",@"017":@"BBIN厅",@"065":@"NT厅",@"067":@"PP厅",@"026":@"AG厅"};
    if (self.platformId) {
        if ([gamePlatDict.allKeys containsObject:self.platformId]) {
            return gamePlatDict[self.platformId];
        } else {
            return self.platformId;
        }
    } else {
        if ([gamePlatDict.allKeys containsObject:self.platform]) {
            return gamePlatDict[self.platformId];
        } else {
            return self.platformId;
        }
    }
}
@end

@implementation CreditQueryResultModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [CreditQueryDataModel class]};
}

@end
