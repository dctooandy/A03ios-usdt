//
//  UIFont+RCFont.m
//  RaidCall
//
//  Created by lichangwen on 15/12/16.
//  Copyright © 2015年 RaidCall. All rights reserved.
//

#import "UIFont+RCFont.h"

@implementation UIFont (RCFont)


+ (UIFont *)fontOfXLLSize{ return [UIFont systemFontOfSize:24]; }
+ (UIFont *)fontOfXMLSize{ return [UIFont systemFontOfSize:22]; }
+ (UIFont *)fontOfXLSize{ return [UIFont systemFontOfSize:18]; }
+ (UIFont *)fontOfLSize{ return [UIFont systemFontOfSize:16]; }
+ (UIFont *)fontOfMSize{ return [UIFont systemFontOfSize:14]; }
+ (UIFont *)fontOfSSize{ return [UIFont systemFontOfSize:12]; }
+ (UIFont *)fontOf13Size{ return [UIFont systemFontOfSize:13]; }
+ (UIFont *)fontOfXSSize{ return [UIFont systemFontOfSize:10]; }

+ (UIFont *)fontHBOfXLLSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:24]; }
+ (UIFont *)fontHBOfXMLSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:22]; }
+ (UIFont *)fontHBOfXLSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:18]; }
+ (UIFont *)fontHBOfLSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:16]; }
+ (UIFont *)fontHBOfMSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:14]; }
+ (UIFont *)fontHBOfSSize{ return [UIFont fontWithName:@"Helvetica-Bold" size:12]; } //Helvetica-Bold  PingFangSC-Medium
//PingFangSC-Medium
+ (UIFont *)fontDBOfMIDSMALLSize{ return [UIFont fontWithName:@"DINAlternate-Bold" size:14]; }
+ (UIFont *)fontDBOf15Size{ return [UIFont fontWithName:@"DINAlternate-Bold" size:15]; }
+ (UIFont *)fontDBOf16Size{ return [UIFont fontWithName:@"DINAlternate-Bold" size:16]; }
+ (UIFont *)fontDBOf18Size{ return [UIFont fontWithName:@"DINAlternate-Bold" size:18]; }
+ (UIFont *)fontDBOf20Size{ return [UIFont fontWithName:@"DINAlternate-Bold" size:20]; }
+ (UIFont *)fontDBOfMAXSize{ return [UIFont fontWithName:@"DINAlternate-Bold" size:30]; }
+ (UIFont *)fontDBOf32Size{ return [UIFont fontWithName:@"DINAlternate-Bold" size:32]; }
+ (UIFont *)fontDBOfMIDSize{ return [UIFont fontWithName:@"DINAlternate-Bold" size:24]; }


+ (UIFont *)fontOfMAXLSize{ return [UIFont systemFontOfSize:32]; }

+ (UIFont *)rc_adjustsFontSizeToFitSize:(CGSize)size maxFont:(UIFont *)maxFont text:(NSString *)text{

    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight) options:0 attributes:@{NSFontAttributeName : maxFont} context:nil].size;
    CGFloat fontSize = [maxFont pointSize];
    if (textSize.width <= size.width && textSize.height <= size.height) {
        return maxFont;
    }else{
        
        do {
            fontSize -= 0.5;
            if (fontSize < 6) {
                return [UIFont systemFontOfSize:fontSize];
            }
            textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenWidth) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
        } while (!(textSize.width <= size.width && textSize.height <= size.height));
        
        return [UIFont systemFontOfSize:fontSize];
    }
}


+ (CGFloat)RC_heightWithFontSize:(CGFloat)fontSize{
    return [@"高度" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
}

+(UIFont *)fontPFThin:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
}

+(UIFont *)fontPFLight:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+(UIFont *)fontPFRegular:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+(UIFont *)fontPFR11{ return [UIFont fontWithName:@"PingFangSC-Regular" size:11]; }
+(UIFont *)fontPFR12{ return [UIFont fontWithName:@"PingFangSC-Regular" size:12]; }
+(UIFont *)fontPFR13{ return [UIFont fontWithName:@"PingFangSC-Regular" size:13]; }
+(UIFont *)fontPFR14{ return [UIFont fontWithName:@"PingFangSC-Regular" size:14]; }
+(UIFont *)fontPFR15{ return [UIFont fontWithName:@"PingFangSC-Regular" size:15]; }
+(UIFont *)fontPFR16{ return [UIFont fontWithName:@"PingFangSC-Regular" size:16]; }
+(UIFont *)fontPFR17{ return [UIFont fontWithName:@"PingFangSC-Regular" size:17]; }
+(UIFont *)fontPFR18{ return [UIFont fontWithName:@"PingFangSC-Regular" size:18]; }

+(UIFont *)fontPFM10{ return [UIFont fontWithName:@"PingFangSC-Medium" size:10]; }
+(UIFont *)fontPFM11{ return [UIFont fontWithName:@"PingFangSC-Medium" size:11]; }
+(UIFont *)fontPFM12{ return [UIFont fontWithName:@"PingFangSC-Medium" size:12]; }
+(UIFont *)fontPFM13{ return [UIFont fontWithName:@"PingFangSC-Medium" size:13]; }
+(UIFont *)fontPFM14{ return [UIFont fontWithName:@"PingFangSC-Medium" size:14]; }
+(UIFont *)fontPFM15{ return [UIFont fontWithName:@"PingFangSC-Medium" size:15]; }
+(UIFont *)fontPFM16{ return [UIFont fontWithName:@"PingFangSC-Medium" size:16]; }
+(UIFont *)fontPFM17{ return [UIFont fontWithName:@"PingFangSC-Medium" size:17]; }
+(UIFont *)fontPFM18{ return [UIFont fontWithName:@"PingFangSC-Medium" size:18]; }
+(UIFont *)fontPFM20{ return [UIFont fontWithName:@"PingFangSC-Medium" size:20]; }
+(UIFont *)fontPFM24{ return [UIFont fontWithName:@"PingFangSC-Medium" size:24]; }
+(UIFont *)fontPFM57{ return [UIFont fontWithName:@"PingFangSC-Medium" size:24]; }

+(UIFont *)fontPFSB12{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:12]; }
+(UIFont *)fontPFSB14{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:14]; }
+(UIFont *)fontPFSB16{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:16]; }
+(UIFont *)fontPFSB17{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:17]; }
+(UIFont *)fontPFSB18{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:18]; }
+(UIFont *)fontPFSB21{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:21]; }
+(UIFont *)fontPFSB22{ return [UIFont fontWithName:@"PingFangSC-Semibold" size:22]; }

+(UIFont *)fontSFR12{ return [[UIFont fontWithName:@".SFUIText-Regular" size:12] fontWithSize:12]; }
+(UIFont *)fontSFM13{ return [[UIFont fontWithName:@".SFUIText-Medium" size:13] fontWithSize:13]; }
+(UIFont *)fontSFM14{ return [[UIFont fontWithName:@".SFUIText-Medium" size:14] fontWithSize:14]; }

@end
