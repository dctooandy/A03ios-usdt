//
//  PublicMethod.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublicMethod : NSObject

/**
 *获取当前window的根控制器
 */
+ (UIViewController *)getRootViewController;

/**
 *根据控制器名字获得其对于的控制器
 */
+ (UIViewController *)getVCByItsClassName:(NSString *)className;

/**
 *获取当前屏幕显示的控制器
 */
+ (UIViewController *)getCurrentVC;

/**
 *获取当前选中的导航控制器
 */
+ (UINavigationController *)getCurrentNavVC;

/**
 * 获取当前顶层窗口
 */
+ (UIWindow *)getTopWindow;

/**
 获取当前的window
 
 @return 当前的window
 */
+ (UIWindow *)currentWindow;


/*******************字典与字符串互相转换*******************/

/**
 *NSString转JSON
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *JSON转NSString
 */
+(NSString*)dictionaryToJson:(NSDictionary *)dic;


/*******************生成随机数*******************/

/**
 * 生成随机数
 */
+ (NSString *)generateUUID;


/**
 制定路径创建文件

 @param fileName 文件名
 @param userName 登录名
 @return 返回路径
 */
+ (NSString *)createDirectoryWithFileName:(NSString *)fileName userName:(NSString *)userName;


/**
 某个时间和当前时间比较是否超过时间间隔
 @param timeInterval 时间间隔
 @param time 要比较的时间
 @return 比较的结果
 */
+ (BOOL)compareCurrentTimeinterval:(NSInteger)timeInterval compareTime:(NSTimeInterval)time;

+ (NSString *)getPreferredLanguage;

+ (NSData *)dataFromBase64String:(NSString *)base64;

/**
 *  @return 当前时间距1970年的毫秒数
 */

+ (NSString *)timeIntervalSince1970;

//获取日期（date_）对用的元素
+ (int)second:(NSDate *)date_;
+ (int)minute:(NSDate *)date_;
+ (int)hour:(NSDate *)date_;
+ (int)day:(NSDate *)date_;
+ (int)month:(NSDate *)date_;
+ (int)year:(NSDate *)date_;

//判断date_是否和当前日期在指定的范围之内
+ (BOOL)isDateToday:(NSDate *)date_;
+ (BOOL)isDateYesterday:(NSDate *)date_;
+ (BOOL)isDateThisWeek:(NSDate *)date_;
+ (BOOL)isDateThisMonth:(NSDate *)date_;
+ (BOOL)isDateThisYear:(NSDate *)date_;

//判断两个时间是否在指定的范围之内
+ (BOOL)twoDateIsSameYear:(NSDate *)fistDate_ second:(NSDate *)secondDate_;
+ (BOOL)twoDateIsSameMonth:(NSDate *)fistDate_ second:(NSDate *)secondDate_;
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_ second:(NSDate *)secondDate_;

//前幾天的年月日（減多少決定）
+(NSString *)lastDateStr:(NSInteger)minus;

// 获取指定日期所在月的天数
+ (NSInteger)numberDaysInMonthOfDate:(NSDate *)date_;
+ (NSDate *)dateByAddingComponents:(NSDate *)date_ offsetComponents:(NSDateComponents *)offsetComponents_;

//获取指定日期所在的月对应的月开始时间和月结束时间
+ (NSDate *)startDateInMonthOfDate:(NSDate *)date_;
+ (NSDate *)endDateInMonthOfDate:(NSDate *)date_;

//判断指定日期是否是本周
- (BOOL)isDateThisWeek:(NSDate *)date;

//当前时间三个月后的时间
+ (NSDate *)returnTheDayAfterThreeMouthWithDate:(NSDate *)date;

// 某个时间一个星期之前的时间
+ (NSDate *)returnTheDayBeforeOneWeekWithDate:(NSDate *)date;
//是否为成年人
+ (BOOL)isAdultWithBirthday:(NSString *)birthday;

+ (UIViewController *)mostFrontViewController;
+ (UIViewController*)currentViewController;

/*******************判断是否为空字符串*******************/

+ (BOOL)isBlankString:(NSString *)aStr;

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory;

+ (NSString*)dataPath;

/**
 *  H5业务组合公共参数
 *
 *  @param parameters 业务自定义参数
 *
 *  @return 包含公共参数的请求参数
 */
+ (NSMutableDictionary *)commonH5ArgumentWithUserParameters:(NSDictionary *)parameters;

//检测预留信息是否合法
+ (BOOL)isValidateLeaveMessage:(NSString *)leaveMessage;
//检查真实姓名是否合法
+ (BOOL)checkRealName:(NSString *)realName;
//检查比特币地址是否合法
+ (BOOL)checkBitcoinAddress:(NSString *)btcAddress;
//正则表达式验证手机号码
+ (BOOL)isValidatePhone:(NSString *)phone;
//正则表达式验证邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)originalEmail;
//正则表达式验证密码是否合法
+ (BOOL)isValidatePwd:(NSString *)originalPwd;
//正则表达式验证银行卡是否合法
+ (BOOL)isValidateBankNumber:(NSString *)number;
//正则表达式验证資金密碼是否合法
+ (BOOL)isValidateWithdrawPwdNumber:(NSString *)number;
/** 转换货币字符串 */
+ (NSString *)getMoneyString:(double)money;

+ (NSString*)getCurrentTimesWithFormat:(NSString *)formatStr;


/**
 把数字转换为千分位模式

 @param num 要转换的数值
 @return 转换成功的数值
 */
+ (NSString *)transferNumToThousandFormat:(CGFloat)num;

+ (NSString *)getLastWeekTime;

+ (NSString *)getThisWeekDateString;

/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)createImageWithColor:(UIColor*)color;


+ (CGSize)getFontsHeightWithString:(NSString *)str;


/**
 判断字符串是否是纯数字

 @param checkedNumString 字符串
 @return 结果
 */
+ (BOOL)isNum:(NSString *)checkedNumString;

+ (UIImage *)QRCodeMethod:(NSString *)qrCodeString;


/**
 判断字符是否是中文字符串

 @param string 字符串
 @return 结果
 */
+ (BOOL)isChinese:(NSString *)string;

+ (NSInteger)checkIsHaveNumAndLetter:(NSString *)str;

#pragma mark - 将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;




// 当前CDN
+ (NSString *)nowCDNWithUrl:(NSString *)url;


+ (NSDate *)transferDateStringToDate:(NSString *)dateString;

//获取随机字符串，年月日时分秒+6位随机数
+ (NSString *)getRandomTimeString;
//是否在两个时间段内
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

+ (NSString *)stringWithDecimalNumber:(double)num;

//無條件捨去至小數點下2位
+ (double)calculateTwoDecimals:(double)num;

//設置指定圓角
+(void)setViewSelectCorner:(UIRectCorner)position view:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

//+(BOOL)isVipUser;

+(BOOL)checkProductDate:(NSString *)tempDate serverTime:(NSString *)serverTime;

+(BOOL)checksStartDate:(NSString *)startTime EndDate:(NSString *)endTime serverTime:(NSString *)serverTime;
+(NSString *)serverTime ;
+(NSArray *)redPacketDuracionCheck;
+(int)countDownIntervalWithDurationTag:(BOOL)isActivityDuration;
@end

NS_ASSUME_NONNULL_END
