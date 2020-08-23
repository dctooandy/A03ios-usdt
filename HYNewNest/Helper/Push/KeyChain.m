//
//  KeyChain.m
//  NetWorkFramework
//
//  Created by Robert on 16/01/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "KeyChain.h"

@implementation KeyChain

#pragma mark 保存数据
/**
 *   保存数据
 *
 *  @param data 数据
 *  @param key  key值
 */
+ (void)setObject:(id)data forKey:(NSString*)key {
    // 通过key搜索字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // 删除之前的旧值
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // 添加新的值到字典中
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 把搜索字典添加到keyChain中
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark 清除数据
/**
 *  清除数据
 *
 *  @param key 对应的key
 */
+ (void)removeObject:(NSString *)key {
    // 根据key查找到搜索字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // 把对应的数据删除掉
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

#pragma mark 获取到相应的数据
/**
 *  获取到相应的数据
 *
 *  @param key 对应的key
 *
 *  @return id对像
 */
+ (id)objectForKey:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

    
+(NSString*)getKeychainIdentifierUUID{
    
    NSString *identifyUUID =   [self objectForKey:@"IdentifierUUID"];
    if(identifyUUID.length < 1 ){
        NSString *identifyUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        identifyUUID =  identifyUUID.length > 1 ? identifyUUID : @"" ;
        [self setObject:identifyUUID forKey:@"IdentifierUUID"];
    }
    return identifyUUID ;
}
    
#pragma mark 私有方法
/**
 *  通过key值获取到对应的数据
 *
 *  @param key 对应的key
 *
 *  @return NSMutableDictionary
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    // 找到搜索字典
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

@end
