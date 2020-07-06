//
//  NSAttributedString+Selectable.h
//  HYGEntire
//
//  Created by zaky on 11/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSAttributedString (Selectable)

/// Seletable Attribute Text
/// @param frontText 前面普通文字
/// @param selText 高亮文字
/// @param urlStr 需要跳转的URL链接

+(NSMutableAttributedString *)attributeText:(NSString *)frontText
                             selectableText:(NSString *)selText
                            selectableColor:(UIColor *)selColor
                                isUnderline:(BOOL)isUnderline
                                     URLStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
