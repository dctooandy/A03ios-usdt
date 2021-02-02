//
//  BYJSONHelper.m
//  HYNewNest
//
//  Created by zaky on 1/26/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYJSONHelper.h"

@implementation BYJSONHelper

#pragma mark -字典或数组转换成json串
+ (NSString *)dictOrArrayToJsonString:(NSDictionary *)dict{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


#pragma mark -json串转换成数组或字典
+ (id)dictOrArrayWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                    error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
    
}



@end
