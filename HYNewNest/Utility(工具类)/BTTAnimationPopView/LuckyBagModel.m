//
//  LuckyBagModel.m
//  HYNewNest
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "LuckyBagModel.h"

@implementation LuckyBagModel

-(NSArray*)amountData
{
    NSMutableArray * resultArray = [[NSMutableArray alloc] initWithObjects:@"共计:0￥",@"0张",@"0张",@"0张",@"0张",@"0张",@"0张", nil];
    for (LuckyBagDetailModel * subModel in self.data) {
        if ([subModel.amount isEqualToString:@"0"])
        {
            // 福卡红包
            if ([subModel.prizeName isEqualToString:@"龙腾虎跃"])
            {
                [resultArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.prizeName isEqualToString:@"藏龙卧虎"])
            {
                [resultArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.prizeName isEqualToString:@"人中龙虎"])
            {
                [resultArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.prizeName isEqualToString:@"如虎生翼"])
            {
                [resultArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.prizeName isEqualToString:@"生龙活虎"])
            {
                [resultArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
            if ([subModel.prizeName isEqualToString:@"虎虎生威"])
            {
                [resultArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%@张",subModel.count]];
            }
        }else
        {
            // 现金红包
            if ([subModel.currency isEqualToString:@"CNY"])
            {
                [resultArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"共计:%@￥",subModel.amount]];
            }else
            {
                [resultArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"共计:%@USDT",subModel.amount]];
            }
        }
    }
    return resultArray.mutableCopy;
}
@end

@implementation LuckyBagDetailModel

@end
