//
//  KeyChain.h
//  NetWorkFramework
//
//  Created by Robert on 16/01/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
/** keyChain保存  */
@interface KeyChain : NSObject
#pragma mark 保存数据
/**
 *   保存数据
 *
 *  @param data 数据
 *  @param key  key值
 */
+ (void)setObject:(id)data forKey:(NSString*)key;

#pragma mark 获取到相应的数据
/**
 *  获取到相应的数据
 *
 *  @param key 对应的key
 *
 *  @return id对像
 */
+ (id)objectForKey:(NSString *)key;

#pragma mark 清除数据
/**
 *  清除数据
 *
 *  @param key 对应的key
 */
+ (void)removeObject:(NSString *)key;
    
    
/**
*  获取设备唯一标识ID
*
*/
+(NSString*)getKeychainIdentifierUUID ;
    
    
    
@end
