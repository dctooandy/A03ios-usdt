//
//  NSString+Font.h
//  MLinkTeacher
//
//  Created by kunlun on 17/4/12.
//  Copyright © 2017年 MLink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Font)


- (CGFloat)getHeightWithMaxWidth:(CGFloat)width inFont:(UIFont *)font;

- (CGFloat)getWidthWithMaxHeight:(CGFloat)height inFont:(UIFont *)font;

+ (BOOL) isBlankString:(NSString *) objString;

+ (NSString *)bankCardFormat:(NSString *)string;

+ (NSString *)bankCardBlankFormat:(NSString *)string;

+(NSString *)changeformatForNumber:(NSString *)number;

+ (void)changeUILablePartColor:(UILabel *)theLab changeString:(NSString *)changeStr andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFont:(UIFont *)markFont;

+ (void)changeUILablePartColor:(UILabel *)theLab changeString:(NSString *)changeStr andAllColor:(UIColor *)allColor markStrIndex:(NSInteger)index andMarkColor:(UIColor *)markColor andMarkFont:(UIFont *)markFont;

+ (NSMutableAttributedString *)attributedStrWithStr:(NSString *)str
                                               font:(UIFont *)font
                                              color:(UIColor *)color ;


@end
