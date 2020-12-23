//
//  IVCacheWrapper.h
//  Pods
//
//  Created by liu nian on 3/22/16.
//
//

#import <Foundation/Foundation.h>

extern NSString * const IVCacheGatewayKey;    //网关
extern NSString * const IVCacheH5DomainKey;   //手机站域名
extern NSString * const IVCacheCDNKey;         //CDN
extern NSString * const IVCacheAllH5DomainsKey;   //所有手机站域名
extern NSString * const IVCacheGameDomainKey;   //游戏站
extern NSString * const IVCacheAllGameDomainsKey;   //所有游戏站

@interface IVCacheWrapper : NSObject

@property (nonatomic, strong) NSMutableDictionary *cache;

#pragma ---------------------供JS调用------------------------------------
+ (BOOL)writeJSONString:(NSString*)jsonString forKey:(NSString*)key isSaveFile:(BOOL)isSaveFile;

+ (NSString*)readJSONStringForKey:(NSString*)key requestId:(NSString*)requestId;

#pragma ---------------------供Native调用--------------------------------

/**
 获取缓存数据
 */
+ (id)objectForKey:(NSString*)key;
/**
 从内存中读取
 */
+ (id)objectFromMemoryForKey:(NSString*)key;
/**
 存储数据
 磁盘和内存
 */
+ (BOOL)setObject:(id)object forKey:(NSString*)key;
/**
 存储数据
 只存在内存
 */
+ (BOOL)setObjectToMemory:(id)object forKey:(NSString*)key;
/**
 存储数据
 可以设置超时，单位为秒
 */
+ (BOOL)setObject:(id)value forKey:(NSString*)key timeout:(NSTimeInterval)timeout;
/**
 获取缓存数据
 返回任意归档对象
 */
+ (id)modelForKey:(NSString*)key;
/**
 存储归档对象
 */
+ (BOOL)setModel:(id)model forKey:(NSString*)key;

/**
 删除LibraryDirectory目录下Caches，WebKit，Cookies缓存，WebView的cookie，cahce数据
 删除NSTemporaryDirectory()数据
 */
+ (BOOL)clearCache;

@end
