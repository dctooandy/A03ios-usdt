//
//  PublicMethod.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "PublicMethod.h"
#import "AppDelegate.h"
#import <CoreImage/CoreImage.h>
#import "RedPacketsInfoModel.h"
#import "A03ActivityManager.h"

@implementation PublicMethod

/**
 *获取当前window的根控制器
 */
+(UIViewController *)getRootViewController
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.window.rootViewController;
}


/**
 *根据控制器名字获得其对于的控制器
 */
+(UIViewController *)getVCByItsClassName:(NSString *)className
{
    //循环遍历tabbar的自控制器
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarVC = (UITabBarController*)appDelegate.window.rootViewController;
        for (UINavigationController * navVC in tabBarVC.viewControllers) {
            for (UIViewController * temVC in navVC.viewControllers) {
                if ([temVC isKindOfClass:NSClassFromString(className)]) {
                    return temVC;
                }
            }
        }
    }
    return nil;
}

/**
 *获取当前选中的导航控制器
 */
+ (UINavigationController *)getCurrentNavVC
{
    //循环遍历tabbar的自控制器
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarVC = (UITabBarController*)appDelegate.window.rootViewController;
        UINavigationController * navVC = tabBarVC.childViewControllers[tabBarVC.selectedIndex];
        return [navVC isKindOfClass:[UINavigationController class]] ? navVC : nil;
    }
    return nil;
}

/**
 *获取当前屏幕显示的viewcontroller
 */
+(UIViewController *)getCurrentVC
{
    UIViewController * result = nil;
    UIViewController * rootVC = [PublicMethod getRootViewController];
    if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        result = ((UINavigationController *)rootVC).visibleViewController;
    }
    else if ([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbarVC = (UITabBarController*)rootVC;
        UIViewController * tabbarSelectVC = [tabbarVC.childViewControllers objectAtIndex:tabbarVC.selectedIndex];
        if ([tabbarSelectVC isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController *)tabbarSelectVC).visibleViewController;
        }
    }
    return result;
}

/**
 * 获取当前顶层窗口
 */
+ (UIWindow *)getTopWindow {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 300)];
    aView.backgroundColor = [UIColor redColor];
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    return window;
}


/**
 获取当前的window
 
 @return 当前的window
 */
+ (UIWindow *)currentWindow {
    return [UIApplication sharedApplication].delegate.window;
}



#pragma mark - 字典与字符串互相转换

/**
 *NSString转JSON
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *JSON转NSString
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                         
                                                        options:NSJSONWritingPrettyPrinted
                         
                                                          error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (CGSize)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(CGFloat)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    
    return rect.size;
}


/**
 * 生成随机数
 */
+ (NSString *)generateUUID {
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

/**
 * 创建指定名字的文件夹
 * 路径如下
 * /Documents/FlyingPigeon/(工号)/fileName
 * fileName:音视频、数据库等文件所在目录的名字。
 * 保证不同用户登录的时候，自动切换到其工号所对应的文件夹目录下
 */
+ (NSString *)createDirectoryWithFileName:(NSString *)fileName userName:(NSString *)userName {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * appName = @"A01";
    NSString * tempPath = [[array objectAtIndex:0] stringByAppendingPathComponent:appName];
    tempPath = [tempPath stringByAppendingPathComponent:userName];
    NSString * path = [tempPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            NSLog(@"%@",error);
        }
        return path;
    }
    return path;
}

/**
 某个时间和当前时间比较是否超过时间间隔
 @param timeInterval 时间间隔
 @param time 要比较的时间
 @return 比较的结果
 */
+ (BOOL)compareCurrentTimeinterval:(NSInteger)timeInterval compareTime:(NSTimeInterval)time {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970] ;
    if (nowTime - timeInterval > timeInterval) {
        return NO;
    }
    return YES;
}



+ (NSString*)getPreferredLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSLog(@"当前语言:%@", preferredLang);
    return preferredLang;
}


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSData *)dataFromBase64String:(NSString *)base64 {
    if (base64 && ![base64 isEqualToString:@""]) {
        if (base64 == nil || [base64 length] == 0)
            return nil;
        
        static char *decodingTable = NULL;
        if (decodingTable == NULL)
        {
            decodingTable = (char *)malloc(256);
            if (decodingTable == NULL)
                return nil;
            memset(decodingTable, CHAR_MAX, 256);
            NSUInteger i;
            for (i = 0; i < 64; i++)
                decodingTable[(short)encodingTable[i]] = i;
        }
        
        const char *characters = [base64 cStringUsingEncoding:NSASCIIStringEncoding];
        if (characters == NULL)     //  Not an ASCII string!
            return nil;
        char *bytes = (char *)malloc((([base64 length] + 3) / 4) * 3);
        if (bytes == NULL)
            return nil;
        NSUInteger length = 0;
        
        NSUInteger i = 0;
        while (YES)
        {
            char buffer[4];
            short bufferLength;
            for (bufferLength = 0; bufferLength < 4; i++)
            {
                if (characters[i] == '\0')
                    break;
                if (isspace(characters[i]) || characters[i] == '=')
                    continue;
                buffer[bufferLength] = decodingTable[(short)characters[i]];
                if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                {
                    free(bytes);
                    return nil;
                }
            }
            
            if (bufferLength == 0)
                break;
            if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            {
                free(bytes);
                return nil;
            }
            
            //  Decode the characters in the buffer to bytes.
            bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
            if (bufferLength > 2)
                bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
            if (bufferLength > 3)
                bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
        
        bytes = (char *)realloc(bytes, length);
        NSData *data = [NSData dataWithBytesNoCopy:bytes length:length];
        
        return data;
        //        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

/**
 *  @return 当前时间距1970年的毫秒数
 */
+ (NSString *)timeIntervalSince1970 {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *mid = [NSString stringWithFormat:@"%lld",(unsigned long long)time];
    
    return mid;
}

+ (int)second:(NSDate *)date_ {
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitSecond];
    return ordinality;
}

+ (int)minute:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitMinute];
    return ordinality;
}

+ (int)hour:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitHour];
    return ordinality;
}

+ (int)day:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitDay];
    return ordinality;
}

+ (int)month:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitMonth];
    return ordinality;
}

+ (int)year:(NSDate *)date_
{
    int ordinality = (int)[self ordinality:date_ ordinalitySign:NSCalendarUnitYear];
    return ordinality;
}

+ (BOOL)isDateToday:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    //[cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitDay
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}


+ (BOOL)isDateYesterday:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *yesterday=[NSDate dateWithTimeIntervalSinceNow:-86400];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitDay
                         startDate:&start
                          interval:&extends
                           forDate:yesterday];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

/* 判断date_是否在当前星期 */
+ (BOOL)isDateThisWeek:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setFirstWeekday:2];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDateThisMonth:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDateThisYear:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitYear
                         startDate:&start
                          interval:&extends
                           forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate_
                   second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components: unit fromDate: secondDate_];
    
    if ([fistComponets year] == [secondComponets year]){
        return YES;
    }
    return NO;
}

+ (BOOL)twoDateIsSameMonth:(NSDate *)fistDate_
                    second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitYear;
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit fromDate:secondDate_];
    
    if ([fistComponets month] == [secondComponets month] &&
        [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_
                  second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
    NSDateComponents *fistComponets = [calendar components: unit fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components: unit fromDate:secondDate_];
    
    if ([fistComponets day] == [secondComponets day] &&
        [fistComponets month] == [secondComponets month] &&
        [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}

+(NSString *)lastDateStr:(NSInteger)minus {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval lastTime = -minus * 24 * 60 * 60;
    NSDate * date = [[NSDate date] dateByAddingTimeInterval:lastTime];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date_
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date_];
    
    return range.length;
}

+ (NSDate *)dateByAddingComponents:(NSDate *)date_
                  offsetComponents:(NSDateComponents *)offsetComponents_
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents_
                                                        toDate:date_
                                                       options:0];
    return endOfWorldWar3;
}

+ (NSDate *)startDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:date_];
    if (ok){
        return beginningOfMonth;
    }
    else{
        return nil;
    }
}

+ (NSDate *)endDateInMonthOfDate:(NSDate *)date_
{
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:date_];
    if (ok){
        NSDate *endDate = [beginningOfMonth dateByAddingTimeInterval:interval];
        return endDate;
    }
    else{
        return nil;
    }
}

- (BOOL)isDateThisWeek:(NSDate *)date
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                         startDate:&start
                          interval:&extends
                           forDate:today];
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSDate *)returnTheDayAfterThreeMouthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+3];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+ (NSDate *)returnTheDayBeforeOneWeekWithDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-7];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

+ (BOOL)isAdultWithBirthday:(NSString *)birthday
{
    NSString *birthdayStr = birthday;
    NSInteger birthYear = [[birthdayStr substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSInteger birthMonth = [[birthdayStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSInteger birthDay = [[birthdayStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger currentYear = [[currentDateString substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSInteger currentMonth = [[currentDateString substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSInteger currentDay = [[currentDateString substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    BOOL isAdult = NO;
    if ((currentYear - birthYear) > 18 ) {
        isAdult = YES;
    } else if ((currentYear - birthYear) == 18) {
        if (currentMonth > birthMonth) {
            isAdult = YES;
        } else if (currentMonth == birthMonth) {
            if ((currentDay - birthDay) >= 0) {
                isAdult = YES;
            }
        }
    }
    return  isAdult;
}

#pragma mark - 私有方法
+ (NSInteger)ordinality:(NSDate *)date_ ordinalitySign:(NSCalendarUnit)ordinalitySign_
{
    NSInteger ordinality = -1;
    if (ordinalitySign_ < NSCalendarUnitEra || ordinalitySign_ > NSCalendarUnitWeekdayOrdinal){
        return ordinality;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:ordinalitySign_ fromDate:date_];
    
    switch (ordinalitySign_)
    {
        case NSCalendarUnitSecond:
        {
            ordinality = [components second];
            break;
        }
            
        case NSCalendarUnitMinute:
        {
            ordinality = [components minute];
            break;
        }
            
        case NSCalendarUnitHour:
        {
            ordinality = [components hour];
            break;
        }
            
        case NSCalendarUnitDay:
        {
            ordinality = [components day];
            break;
        }
            
        case NSCalendarUnitMonth:
        {
            ordinality = [components month];
            break;
        }
            
        case NSCalendarUnitYear:
        {
            ordinality = [components year];
            break;
        }
            
        default:
            break;
    }
    
    return ordinality;
}



+ (UIViewController *)mostFrontViewController {
    UIViewController *vc = [self rootViewController];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}

+ (UIViewController*)currentViewController
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
#pragma mark 判断是否为空字符串
+ (BOOL)isBlankString:(NSString *)aStr{
    
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    
    return NO;
    
}

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory {
    NSString *path = [directory stringByAppendingPathComponent:folderName];
    NSURL *folderURL = [NSURL URLWithString:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            return folderURL;
        }else {
            NSLog(@"创建文件失败 %@", error.localizedFailureReason);
            return nil;
        }
        
    }
    return folderURL;
}

+ (NSString*)dataPath {
    static NSString *_dataPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    });
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:_dataPath]){
        [fm createDirectoryAtPath:_dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    return _dataPath;
}

+ (NSMutableDictionary *)commonH5ArgumentWithUserParameters:(NSDictionary *)parameters{
    NSMutableDictionary *argument = nil;
    if (parameters) {
        argument = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        argument = @{}.mutableCopy;
    }
    argument[@"newApi"] = @"1";
    NSString *appToken = @"";//[IVNetwork appToken];
    argument[@"appToken"] =  appToken ? appToken : @"";
    NSString *udid = @"";
    argument[@"deviceid"] = udid;//[NSString isBlankString:udid] ? [IVNetwork getDeviceId] : udid;
    if ([IVHttpManager shareManager].loginName.length) {
        argument[@"userToken"] = [IVHttpManager shareManager].userToken;
        argument[@"accountName"] = [IVHttpManager shareManager].loginName;
    }
    return argument;
}

+ (BOOL)isValidateLeaveMessage:(NSString *)leaveMessage{
    //预留信息只支持数字,英文小写或中文字符.务必牢记,保护您的交易安全
    NSString *regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@",regular];
    BOOL result = [predicate evaluateWithObject:leaveMessage];
    return result;
}
+ (BOOL)checkRealName:(NSString *)realName {
    //中文，英文，·符号，长度2~14位
    NSString *realNameRegex = @"[a-zA-Z·\u4e00-\u9fa5]{2,14}";
    NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNameRegex];
    if (![realNamePredicate evaluateWithObject:realName]) {
        return NO;
    }
    return YES;
}
+ (BOOL)checkBitcoinAddress:(NSString *)btcAddress {
    NSString *bitcoinRegex = @"^[a-zA-Z0-9]{6,40}";
    NSPredicate *bitcoinPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bitcoinRegex];
    if (![bitcoinPredicate evaluateWithObject:btcAddress]) {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"^(1)[3456789]\\d{9}";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if (![phonePredicate evaluateWithObject:phone]) {
        
        return NO;
    }
    return YES;
}
+ (BOOL)isValidateEmail:(NSString *)originalEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [email evaluateWithObject:originalEmail];
}
/** 正则表达式验证密码是否合法 YES 合法，NO 不合法 */
+ (BOOL)isValidatePwd:(NSString *)originalPwd{
    NSString *pwdRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,10}";
    NSPredicate *pwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    return [pwd evaluateWithObject:originalPwd];
}
+ (BOOL)isValidateBankNumber:(NSString *)number{
    NSString *numberRegex = @"^[0-9]{16,21}";
    NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [num evaluateWithObject:number];
}
+ (BOOL)isValidateWithdrawPwdNumber:(NSString *)number{
    NSString *numberRegex = @"^\\d{6,6}$";
    NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [num evaluateWithObject:number];
}
/** 转换货币字符串 */
+ (NSString *)getMoneyString:(double)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
    numberFormatter.maximumFractionDigits = 2;
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}
+ (NSString*)getCurrentTimesWithFormat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:formatStr];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

+ (NSString *)transferNumToThousandFormat:(CGFloat)num {
    NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc] init];
    moneyFormatter.positiveFormat = @"###,##0.000";
    NSString *formatString = [moneyFormatter stringFromNumber:@(num)];
    return [formatString substringToIndex:formatString.length-1];
}


+ (NSString *)getLastWeekTime {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%ld----%ld",(long)weekDay,(long)day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1; weekDay == 1 == 周日
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *baseDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    
    //获取周一日期
    [baseDayComp setDay:day + firstDiff - 7];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:baseDayComp];
    
    //获取周末日期
    [baseDayComp setDay:day + lastDiff - 7];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:baseDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *firstDay = [NSString stringWithFormat:@"%@ 00:00:00",[formatter stringFromDate:firstDayOfWeek]];
    NSString *lastDay = [NSString stringWithFormat:@"%@ 23:59:59",[formatter stringFromDate:lastDayOfWeek]];
    NSLog(@"%@=======%@",firstDay,lastDay);
    
    NSString *dateStr = [NSString stringWithFormat:@"%@||%@",firstDay,lastDay];
    
    return dateStr;
    
}

+ (NSString *)getThisWeekDateString{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%ld----%ld",(long)weekDay,(long)day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1; weekDay == 1 == 周日
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *baseDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    
    NSString *dateStr = @"";
    for (NSInteger i=firstDiff; i<=0; i++) {
        NSLog(@"%ld",(long)i);
        [baseDayComp setDay:day + i];
        NSDate *dayOfWeek = [calendar dateFromComponents:baseDayComp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSLog(@"%@",[formatter stringFromDate:dayOfWeek]);
        if (firstDiff==0||i==0) {
            [dateStr stringByAppendingString:[formatter stringFromDate:dayOfWeek]];
            return dateStr;
        }else{
            [dateStr stringByAppendingString:[formatter stringFromDate:dayOfWeek]];
            [dateStr stringByAppendingString:@"#"];
        }
    }
    
    return dateStr;
}

+ (UIImage *)createImageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

+ (CGSize)getFontsHeightWithString:(NSString *)str {
    CGSize size = CGSizeZero;
    if (str.length) {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        
        size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attribute
                                           context:nil].size;
    }
    return size;
}

+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

// 生成二维码

+ (UIImage *)QRCodeMethod:(NSString *)qrCodeString {
    PublicMethod *strongSelf = [PublicMethod new];
    return [strongSelf createNonInterpolatedUIImageFormCIImage:[strongSelf createQRForString:qrCodeString] withSize:250.0f];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
//    UIGraphicsBeginImageContext(img.size);
//    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
//    UIImage *centerImg=[UIImage imageNamed:@"pay_Ali_Logo"];
//    CGFloat centerW = 60;
//    CGFloat centerH = 60;
//    CGFloat centerX = (img.size.width - 60) * 0.5;
//    CGFloat centerY = (img.size.height - 60) * 0.5;
//    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
//    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (BOOL)isChinese:(NSString *)string {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

+ (NSInteger)checkIsHaveNumAndLetter:(NSString *)str {
    //数字条件
    
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:str
                                 
                                                                       options:NSMatchingReportProgress
                                 
                                                                         range:NSMakeRange(0, str.length)];
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合英文字条件的有几个字节
    
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if (tNumMatchCount == str.length) {
        
        //全部符合数字，表示沒有英文
        
        return 1;
        
    } else if (tLetterMatchCount == str.length) {
        
        //全部符合英文，表示沒有数字
        
        return 2;
        
    } else if (tNumMatchCount + tLetterMatchCount == str.length) {
        
        //符合英文和符合数字条件的相加等于密码长度
        
        return 3;
        
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}

#pragma mark - 将某个时间转化成 时间戳

+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000] integerValue];
    return timeSp;
}

+ (NSString *)nowCDNWithUrl:(NSString *)url {
    BOOL cdn = [[IVHttpManager shareManager].cdn hasSuffix:@"/"];
    BOOL urlStr = [url hasPrefix:@"/"];
    
    NSString *str = nil;
    if (cdn) {
        str = [[IVHttpManager shareManager].cdn substringToIndex:[IVHttpManager shareManager].cdn.length - 1];
    } else {
        str = [IVHttpManager shareManager].cdn;
    }
    
    if (urlStr) {
        str = [NSString stringWithFormat:@"%@/%@",str,[url substringFromIndex:1]];
    } else {
        str = [NSString stringWithFormat:@"%@/%@",str,url];
    }
    return str;
}


+ (NSDate *)transferDateStringToDate:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}


+ (NSString *)getRandomTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmssS"];
    NSDate *date = [NSDate date];
    NSString *timeString = [formatter stringFromDate:date];
    
    int num = (arc4random() % 1000000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.6d", num];
    
    return [NSString stringWithFormat:@"%@%@",timeString,randomNumber];
    
}
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] ==NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] ==NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSString *)stringWithDecimalNumber:(double)num {
    return [[self decimalNumber:num] stringValue];
}

+ (NSDecimalNumber *)decimalNumber:(double)num {
    NSString *numString = [NSString stringWithFormat:@"%.3f", num];
    NSString *subNumber = [numString substringToIndex:numString.length-1];
    return [NSDecimalNumber decimalNumberWithString:subNumber];
}

+ (double)calculateTwoDecimals:(double)num {
    double amount = ((int)(num * 100))/100.0;
    return amount;
}

+(void)setViewSelectCorner:(UIRectCorner)position view:(UIView *)view cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:position cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}

//+(BOOL)isVipUser {
//    int currentHour = [PublicMethod hour:[NSDate date]];
//    return [IVNetwork savedUserInfo].starLevel >= 3 && [IVNetwork savedUserInfo] && currentHour >= 12 && currentHour <= 21;
//}

+(BOOL)checkProductDate:(NSString *)tempDate serverTime:(NSString *)serverTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:tempDate];
    NSDate *serverDate = [dateFormatter dateFromString:serverTime];
    // 判断是否大于server时间
    if ([date earlierDate:serverDate] != date) {
        return true;
    } else {
        return false;
    }
}
+(BOOL)checksStartDate:(NSString *)startTime EndDate:(NSString *)endTime serverTime:(NSString *)serverTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *serverDate = [dateFormatter dateFromString:serverTime];
    // 判断是否大于server时间
    if (([startDate earlierDate:serverDate] == startDate) &&
        ([serverDate earlierDate:endDate] == serverDate)) {
        return true;
    } else {
        return false;
    }
}
+(NSString *)serverTime {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:timeDate];
}
//检查红包雨是否在期间
+(NSArray *)redPacketDuracionCheck
{
    BOOL isBeforeDuration = [[[[A03ActivityManager sharedInstance] redPacketInfoModel] preStatus]  isEqual: @"1"] ? YES:NO;
    BOOL isActivityDuration = [[[[A03ActivityManager sharedInstance] redPacketInfoModel] status]  isEqual: @"1"] ? YES:NO;
    return @[[NSNumber numberWithBool:isBeforeDuration] ,[NSNumber numberWithBool:isActivityDuration]];
}
//返回下一场次红包雨的时间
+(int)countDownIntervalWithDurationTag:(BOOL)isActivityDuration
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *startDate;
    NSTimeInterval startDateTime = 0;
    NSTimeInterval secondStartDateTime = 0;
    NSTimeInterval countDownInterval = 0;
    RedPacketsInfoModel * model = [[A03ActivityManager sharedInstance] redPacketInfoModel];
    NSInteger totalPlusTimer = 0;
    NSArray * plusTimer = [[model firstStartAt] componentsSeparatedByString:@":"];
    if (plusTimer.count == 3)
    {
        NSInteger hourS = [(NSString *)[plusTimer firstObject] integerValue];
        NSInteger minS = [(NSString *)plusTimer[1] integerValue];
        NSInteger secS = [(NSString *)[plusTimer lastObject] integerValue];
        totalPlusTimer = hourS * 3600 + minS * 60 + secS;
    }else
    {
        
    }
    if (!isActivityDuration)
    {
        // 不到时间,预热
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        startDate = [dateFormatter dateFromString:RedPacketFirstStartTime];
        startDate = [dateFormatter dateFromString:model.startAt];
        startDateTime = [[NSDate date] timeIntervalSinceDate:startDate];
//        countDownInterval = -startDateTime;
        countDownInterval = -startDateTime + totalPlusTimer;

    }else
    {
        // 活动期间
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        startDate = [dateFormatter dateFromString:RedPacketFirstStartTime];// 第一天早上10点
//        startDateTime = (int)[[NSDate date] timeIntervalSinceDate:startDate] % (60 * 60 * 24);
//        secondStartDateTime = startDateTime - (60 * 60 * 4);
//
//        if (startDateTime < 0)
//        {
//            //早于10点
//            countDownInterval = -startDateTime;
//        } else if (secondStartDateTime < 0)
//        {
//            //介于10点到14点
//            countDownInterval = -secondStartDateTime;
//        }else
//        {
//            //晚于14点
//            countDownInterval = (60*60*24 - secondStartDateTime);
//        }
        countDownInterval = [model.leftTime integerValue];

    }
    return countDownInterval;
}
@end
