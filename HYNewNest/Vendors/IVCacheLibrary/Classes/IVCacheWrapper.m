//
//  IVCacheWrapper.m
//  Pods
//
//  Created by liu nian on 3/22/16.
//
//



#import "IVCacheWrapper.h"

#if DEBUG
#define NLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NLLog(xx, ...)  ((void)0)
#endif

NSString * const IVCacheGatewayKey = @"IVCacheGatewayKey";    //网关
NSString * const IVCacheH5DomainKey = @"domain";   //手机站域名
NSString * const IVCacheCDNKey = @"cdnurl";         //CDN
NSString * const IVCacheAllH5DomainsKey = @"allDomains";   //所有手机站域名
NSString * const IVCacheGameDomainKey = @"kCacheGameDomain";   //游戏站
NSString * const IVCacheAllGameDomainsKey = @"kCacheAllGameDomains";   //所有游戏站

static NSString *const VALUE_KEY = @"cacheValue";
static NSString *const SAVETIME_KEY = @"saveTime_key";
static NSString *const TIMEOUT_KEY = @"timeout_key";

@interface IVCacheWrapper ()
@property (nonatomic, strong) dispatch_queue_t file_queue_t;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation IVCacheWrapper

- (id)init{
    if (self = [super init]) {
        _cache = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
        [self checkDirectory:[self projectCacheFilePath]];
    }
    return self;
}

+ (IVCacheWrapper *)sharedInstance
{
    static IVCacheWrapper *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[super allocWithZone:NULL] init];
    });
    return shareManager;
}

#pragma ---------------------供JS调用------------------------------------
+ (BOOL)writeJSONString:(NSString*)jsonString forKey:(NSString*)key isSaveFile:(BOOL)isSaveFile{
    if (key == nil) return NO;
    NSData *data = nil;
    if (jsonString) {
        data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return  [[IVCacheWrapper sharedInstance] writeData:data forKey:key isSaveFile:isSaveFile];
}
+ (NSString*)readJSONStringForKey:(NSString*)key requestId:(NSString*)requestId{
    NSString *jsonString;
    NSData *data = [[IVCacheWrapper sharedInstance] readDataForKey:key];
    if (data) {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"requestId"] = requestId;
    dic[@"method"] = @"callback";
    dic[@"data"] = jsonString;
    return [self dictionaryToJSONString:dic];
}

#pragma ---------------------供Native调用--------------------------------

+ (id)objectForKey:(NSString*)key{
    NSData *jsonData = [[IVCacheWrapper sharedInstance] readDataForKey:key];
    return [self analyticalData:jsonData key:key];
}
+ (id)objectFromMemoryForKey:(NSString*)key
{
    NSData *jsonData = [[IVCacheWrapper sharedInstance].cache valueForKey:key];
    return [self analyticalData:jsonData key:key];
}
+ (id)analyticalData:(NSData *)data key:(NSString *)key
{
    if (!data) {
        return nil;
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSNumber *saveTime = [dic valueForKey:SAVETIME_KEY];
    NSNumber *timeout = [dic valueForKey:TIMEOUT_KEY];
    //判断是否超时
    if (saveTime && timeout) {
        NSTimeInterval duration = currentTime - [saveTime doubleValue];
        if (duration > [timeout doubleValue]) {
            [self setObject:nil forKey:key];
            return nil;
        }
    }
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic[VALUE_KEY];
    }
    return nil;
}

+ (BOOL)setObject:(id)object forKey:(NSString*)key{
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:object forKey:VALUE_KEY];
    NSString *jsonStr = nil;
    if (dic.count > 0) {
        jsonStr = [self dictionaryToJSONString:dic];
    }
    return [self writeJSONString:jsonStr forKey:key isSaveFile:YES];
}
+ (BOOL)setObjectToMemory:(id)object forKey:(NSString *)key
{
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:object forKey:VALUE_KEY];
    NSString *jsonStr = nil;
    if (dic.count > 0) {
        jsonStr = [self dictionaryToJSONString:dic];
    }
    return [self writeJSONString:jsonStr forKey:key isSaveFile:NO];
    
}
+ (BOOL)setObject:(id)object forKey:(NSString*)key timeout:(NSTimeInterval)timeout
{
    NSMutableDictionary *dic = @{}.mutableCopy;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    [dic setValue:object forKey:VALUE_KEY];
    [dic setValue:@(timeout) forKey:TIMEOUT_KEY];
    [dic setValue:@(currentTime) forKey:SAVETIME_KEY];
    NSString *jsonStr = [self dictionaryToJSONString:dic];
    return [self writeJSONString:jsonStr forKey:key isSaveFile:YES];
}
+ (id)modelForKey:(NSString *)key
{
    return [[IVCacheWrapper sharedInstance] readModelForKey:key];
}
+ (BOOL)setModel:(id)model forKey:(NSString *)key
{
    return [[IVCacheWrapper sharedInstance] writeModel:model forKey:key];
}

+ (BOOL)clearCache{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    [self clearCachesWithPath:libraryPath Content:@"/Caches"];
    [self clearCachesWithPath:libraryPath Content:@"/WebKit"];
    [self clearCachesWithPath:libraryPath Content:@"/Cookies"];
    [[NSFileManager defaultManager] removeItemAtPath:NSTemporaryDirectory() error:nil];
    return YES;
}

+ (void)clearCachesWithPath:(NSString *)path Content:(NSString *)content {
    NSString *cachesPath = [path stringByAppendingString:content];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subFilePaths = [fileManager contentsOfDirectoryAtPath:cachesPath error:nil];
    NSLog(@"删除(%@)目录下所有文件", content);
    for (NSString *subFilePath in subFilePaths) {
        NSString *tempPath = [cachesPath stringByAppendingPathComponent:subFilePath];
        [fileManager removeItemAtPath:tempPath error:nil];
    }
}
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dict
{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}


#pragma mark private
- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NLLog(@"error to set do not backup attribute, error = %@", error);
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NLLog(@"create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:path];
    }
}

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}
- (NSString *)applicationCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) lastObject];
}
#pragma mark - 保存数据情况缓存
- (NSString *)projectCacheFilePath{
    NSString *cacheDirectory = [self applicationCachesDirectory];
    return [cacheDirectory stringByAppendingPathComponent:@"ResponseCache"];
}
- (NSString *)filePathForKey:(NSString *)key{
    return [[self projectCacheFilePath] stringByAppendingPathComponent:key];
}

- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        NLLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

#pragma public methods
- (BOOL)isCacheVersionExpiredForKey:(NSString *)key toCacheTimeInSeconds:(int)cacheTimeInSeconds{
    // check cache existance
    NSString *path = [self filePathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        return YES;
    }
    // check cache time
    int seconds = [self cacheFileDuration:path];
    if (seconds < 0 || seconds > cacheTimeInSeconds) {
        return YES;
    }
    return NO;
}

#pragma mark - read
- (NSData*)readDataForKey:(NSString*)key{
    if(!key){
        return nil;
    }
    [_lock lock];
    NSData *cacheData = [_cache objectForKey:key];
    if(cacheData){
        [_lock unlock];
        return cacheData;
    }else{
        NSString *filepath =[self filePathForKey:key];
        NSData *fileData =  [[NSFileManager defaultManager] contentsAtPath:filepath];
        if(fileData){
            [_cache setObject:fileData forKey:key];
        }
        [_lock unlock];
        return fileData;
    }
}

- (id)readModelForKey:(NSString*)key{
    if(!key){
        return nil;
    }
    NSString *filepath  = [self filePathForKey:key];
    return [self readModelFromPath:filepath];
}

- (id)readModelFromPath:(NSString *)path{
    NSFileManager *fileman = [NSFileManager defaultManager];
    if ([fileman fileExistsAtPath:path]){
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return nil;
}
#pragma mark - write
- (BOOL)writeData:(NSData*)data forKey:(NSString*)key isSaveFile:(BOOL)isSaveFile
{
    if (data ) {
        [_lock lock];
        [_cache setObject:data forKey:key];
        [_lock unlock];
    }else{
        [_lock lock];
        [_cache removeObjectForKey:key];
        [_lock unlock];
    }
    if (!isSaveFile) {
        return YES;
    }
    NSString *filepath  = [self filePathForKey:key];
    __block BOOL result = NO;
    dispatch_async(self.file_queue_t, ^{
        if (data) {
            result = [[NSFileManager defaultManager] createFileAtPath:filepath contents:data attributes:nil];
        }else{
            if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                NSError *error = nil;
                result = [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
                if (error) {
                    NLLog(@"error:%@",error);
                }
            }
        }
    });
    return result;
}

- (BOOL)writeModel:(id)model forKey:(NSString *)key{
    NSString *filepath  = [self filePathForKey:key];
    return [self writeModel:model toPath:filepath];
}

- (BOOL)writeModel:(id)model toPath:(NSString *)path{
    return [NSKeyedArchiver archiveRootObject:model toFile:path];
}

#pragma mark - remove
- (void)removeCacheDataForKey:(NSString *)key{
    NSString *filepath  = [self filePathForKey:key];
    // check cache existance
    NSString *path = [self filePathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        [_lock lock];
        [_cache removeObjectForKey:key];
        [_lock unlock];
        __block BOOL result = NO;
        dispatch_async(self.file_queue_t, ^{
            NSError *error = nil;
            result = [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
            if (error) {
                NLLog(@"error:%@",error);
            }
        });
    }
}
#pragma mark getter
- (dispatch_queue_t)file_queue_t{
    if (_file_queue_t == nil) {
        _file_queue_t = dispatch_queue_create("com.PusceneSerialQueue.fileCache", DISPATCH_QUEUE_SERIAL);
    }
    return _file_queue_t;
}

@end
