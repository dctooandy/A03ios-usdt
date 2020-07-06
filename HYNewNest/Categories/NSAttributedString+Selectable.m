//
//  NSAttributedString+Selectable.m
//  HYGEntire
//
//  Created by zaky on 11/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "NSAttributedString+Selectable.h"



@implementation NSAttributedString (Selectable)

+(NSMutableAttributedString *)attributeText:(NSString *)frontText
                             selectableText:(NSString *)selText
                            selectableColor:(UIColor *)selColor
                                isUnderline:(BOOL)isUnderline
                                     URLStr:(NSString *)urlStr {
    //普通字体的大小颜色
    NSDictionary * normalAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:AD(12)], NSForegroundColorAttributeName:[UIColor colorTabbarAd]};
   
    //可点击字体的大小颜色
    NSMutableDictionary * specAtt = @{NSFontAttributeName:[UIFont systemFontOfSize:AD(12)], NSForegroundColorAttributeName:selColor}.mutableCopy;
    
    //可点击字体加下划线否
    if (isUnderline) {
        [specAtt setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    }
    
    //生成默认的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:frontText attributes:normalAtt];
    
    //添加特殊部分在尾部
    NSMutableAttributedString * click = [[NSMutableAttributedString alloc] initWithString:selText attributes:specAtt];
    [attStr appendAttributedString:click];
    
    //设置居中
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
    
    //添加点击事件
    NSString * value = urlStr?urlStr:@"";
    [attStr addAttribute:NSLinkAttributeName value:value range:[[attStr string] rangeOfString:[click string]]];
    
    return attStr;
}

@end
