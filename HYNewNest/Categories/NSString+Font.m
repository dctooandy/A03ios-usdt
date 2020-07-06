//
//  NSString+Font.m
//  MLinkTeacher
//
//  Created by kunlun on 17/4/12.
//  Copyright © 2017年 MLink. All rights reserved.
//

#import "NSString+Font.h"

@implementation NSString (Font)

- (CGFloat)getHeightWithMaxWidth:(CGFloat)width inFont:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attribute context:nil];
    return rect.size.height;
}


- (CGFloat)getWidthWithMaxHeight:(CGFloat)height inFont:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attribute context:nil];
    return rect.size.width;
}


+ (BOOL)isBlankString:(NSString *) objString {
    if (objString == nil || objString == NULL) {
        return YES;
    }
    if ([objString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[objString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString *)bankCardFormat:(NSString *)string
{
    NSString *result = nil;
    NSString *space = @" ";
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [mutableString appendString:string];
    NSInteger stringLength = [mutableString length];
    if (stringLength >= 4) {
        if (stringLength%5 == 0) {
            [mutableString insertString:space atIndex:stringLength-1];
        }
        result = mutableString;
    }else{
        result = mutableString;
    }
    return result;
}


+ (NSString *)bankCardBlankFormat:(NSString *)string
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [mutableString appendString:string];
    NSString *text = string ;
    NSString *newString =@"";
    while (text.length >0) {
        NSString *subString = [text substringToIndex:MIN(text.length,4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length ==4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length,4)];
    }
    return newString;
}

+(NSString *)changeformatForNumber:(NSString *)number
{
    //整数
    NSString* str11;
    //小数点之后的数字
    NSString* str22;
    if ([number containsString:@"."]) {
        
        NSArray* array = [number componentsSeparatedByString:@"."];
        str11 = array[0];
        str22 = array[1];
    }else{
        str11 = number;
    }
    if (str11.length < 4) {
        return  number ;
    }
    int count = 0;
    long long int a = str11.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:str11];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if ([number containsString:@"."]) {
        //包含小数点
        //返回的数字
        NSString* str33;
        if (str22.length>0) {
            //小数点后面有数字
            str33 = [NSString stringWithFormat:@"%@.%@",newstring,str22];
        }else{
            //没有数字
            str33 = [NSString stringWithFormat:@"%@",newstring];
        }
        return str33;
    }else{
        //不包含小数点
        return newstring;
    }
}

+ (void)changeUILablePartColor:(UILabel *)theLab changeString:(NSString *)changeStr andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFont:(UIFont *)markFont{
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:changeStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:markFont range:markRange];
    theLab.attributedText = strAtt;
}

+ (void)changeUILablePartColor:(UILabel *)theLab changeString:(NSString *)changeStr andAllColor:(UIColor *)allColor markStrIndex:(NSInteger)index andMarkColor:(UIColor *)markColor andMarkFont:(UIFont *)markFont {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = NSMakeRange(index, changeStr.length);
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:markFont range:markRange];
    theLab.attributedText = strAtt;
}

+ (NSMutableAttributedString *)attributedStrWithStr:(NSString *)str
                                               font:(UIFont *)font
                                              color:(UIColor *)color {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:color
                             range:NSMakeRange(0, str.length)];
    return attributedString;
}


@end
