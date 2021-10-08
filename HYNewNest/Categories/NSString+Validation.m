//
//  NSString+Validation.m
//  LoginViewDemo
//
//  Created by zdd on 16/3/14.
//  Copyright © 2016年 zdd. All rights reserved.
//

#import "NSString+Validation.h"
// 真实姓名
#define kValidationRealName @"(^[\u4e00-\u9fa5]{1}[\u4e00-\u9fa5\\·]{0,8}[\u4e00-\u9fa5]{1}$)|(^[a-zA-Z]{1}[a-zA-Z\\s]{0,10}[a-zA-Z]{1,10}$)"
//手机号码验证 ok
#define kValidationPhone @"^((1[3456789][0-9]))\\d{8}$"
//邮箱验证  ^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
#define kValidationMail @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
//身份证验证
#define kValidationIDCard @"^\\d{8,18}|[0-9x]{8,18}|[0-9X]{8,18}?$"
//IP地址验证
#define kValidationIP @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))"
//日期中的月验证(01~09和1~12)
#define kValidationMonth @"^(0?[1-9]|1[0-2])$"
//日期中的日验证(01~09和1~31)
#define kValidationDay @"^((0?[1-9])|((1|2)[0-9])|30|31)$"
//密码验证 ok
//#define kValidationPassword @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{8,20}$"
#define kValidationPassword @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
////用户名验证 ok
//#define kValidationUserName @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,16}$"
#define kValidationUserName @"^(?=.*?[0-9])[fF][0-9a-zA-Z]{4,10}$"

//登入用户名验证 符合A01 13码
#define kValidationLoginUserName @"^[fF][0-9a-zA-Z]{4,12}$"
//银行卡简单验证 16位和19位
#define kValidationBankCard @"^\\d{16,19}$"
//验证码纯数字6位
#define kValidationPhoneCode @"^\\d{6}"
//中文验证
#define kValidationChinese @"^[\u4e00-\u9fa5]{2,10}$"
//验证字母和数字
#define kValidationLetterOrNumber @"^[a-zA-Z0-9\u4e00-\u9fa5]{4,16}$"
// URL
#define kValidationURL @"((http|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
//支付宝姓名
#define kValidationALIPAYNAME @"^[\u4E00-\u9FA5`~!@#$%^&*()+=|{}':;,\\[\\].<>/?…—‘”“’·]+$"
//usdt
#define kValidationUSDTAddr @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,80}$"
//wx账号
#define kValidationWechat @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$"

@implementation NSString (Validation)

- (BOOL)validationType:(ValidationType)validationType
{
    return [self validationExpression:[self expressionByValidationType:validationType]];
}

- (BOOL)validationExpression:(NSString *)expression
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",expression];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPrueInt
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    int intVal;
    return [scanner scanInt:&intVal] && [scanner isAtEnd];
}

- (BOOL)isPrueFloat
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float floatVal;
    return [scanner scanFloat:&floatVal] && [scanner isAtEnd];
}

- (BOOL)isPrueIntOrFloat
{
    return [self isPrueFloat]||[self isPrueInt];
}

/**
 *  根据类型返回对应的正则表达式
 *
 *  @param type 待验证的正则表达式
 *
 *  @return 正则表达式
 */
- (NSString *)expressionByValidationType:(ValidationType)type
{
    NSString *str;
    switch (type) {
        case ValidationTypePhone:
            str = kValidationPhone;
            break;
        case ValidationTypeMail:
            str = kValidationMail;
            break;
        case ValidationTypeIDCard:
            str = kValidationIDCard;
            break;
        case ValidationTypeIP:
            str = kValidationIP;
            break;
        case ValidationTypeMonth:
            str = kValidationMonth;
            break;
        case ValidationTypeDay:
            str = kValidationDay;
            break;
        case ValidationTypePassword:
            str = kValidationPassword;
            break;
        case ValidationTypeUserName:
            str = kValidationUserName;
            break;
        case ValidationTypeBankCard:
            str = kValidationBankCard;
            break;
        case ValidationTypePhoneCode:
            str = kValidationPhoneCode;
            break;
        case ValidationTypeChinese:
            str = kValidationChinese;
            break;
        case ValidationTypeLetterOrNumber:
            str = kValidationLetterOrNumber;
            break;
        case ValidationTypeURL:
            str = kValidationURL;
            break;
        case ValidationALIPAYNAME:
            str = kValidationALIPAYNAME;
            break;
        case ValidationTypeUSDTAddress:
            str = kValidationUSDTAddr;
            break;
        case ValidationTypeWechat:
            str = kValidationWechat;
            break;
        case ValidationTypeRealName:
            str = kValidationRealName;
            break;
        case ValidationTypeLoginName:
            str = kValidationLoginUserName;
            break;
        default:
            str = @"";
            break;
    }
    return str;
}
@end
