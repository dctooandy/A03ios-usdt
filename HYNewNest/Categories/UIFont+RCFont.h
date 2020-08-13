//
//  UIFont+RCFont.h
//  RaidCall
//
//  Created by lichangwen on 15/12/16.
//  Copyright © 2015年 RaidCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (RCFont)

+ (UIFont *)fontOfXLLSize;//24sp
+ (UIFont *)fontOfXMLSize;//22sp
+ (UIFont *)fontOfXLSize; //18sp
+ (UIFont *)fontOfLSize;///< L字號    16sp
+ (UIFont *)fontOfMSize;///< M字號   14sp
+ (UIFont *)fontOfSSize;///< S字號   12sp
+ (UIFont *)fontOfXSSize;///< XS字號  10sp
+ (UIFont *)fontOfMAXLSize;///< XS字號  32sp



/**
 Helvetica-Bold size:24
*/
+ (UIFont *)fontHBOfXLLSize;

/**
 Helvetica-Bold size:18
 */
+ (UIFont *)fontHBOfXLSize;
+ (UIFont *)fontHBOfXMLSize;
+ (UIFont *)fontHBOfLSize;
+ (UIFont *)fontHBOfMSize;
+ (UIFont *)fontHBOfSSize;


+ (UIFont *)rc_adjustsFontSizeToFitSize:(CGSize)size maxFont:(UIFont*)maxFont text:(NSString*)text;

+ (CGFloat)RC_heightWithFontSize:(CGFloat)fontSize;


/**
 DINAlternate-Bold size:14
 */
+ (UIFont *)fontDBOfMIDSMALLSize;
+ (UIFont *)fontDBOf16Size;

+ (UIFont *)fontDBOf18Size;
+ (UIFont *)fontDBOf32Size;
+ (UIFont *)fontDBOf20Size;
/**
 DINAlternate-Bold" size:30
 */
+ (UIFont *)fontDBOfMAXSize;

/**
 DINAlternate-Bold" size:24
 */
+ (UIFont *)fontDBOfMIDSize;

+ (UIFont *)fontOf13Size;


+(UIFont *)fontPFR11;
+(UIFont *)fontPFR12;
+(UIFont *)fontPFR13;
+(UIFont *)fontPFR14;
+(UIFont *)fontPFR15;
+(UIFont *)fontPFR16;
+(UIFont *)fontPFR17;
+(UIFont *)fontPFR18;

+(UIFont *)fontPFM10;
+(UIFont *)fontPFM12;
+(UIFont *)fontPFM13;
+(UIFont *)fontPFM14;
+(UIFont *)fontPFM15;
+(UIFont *)fontPFM16;
+(UIFont *)fontPFM17;
+(UIFont *)fontPFM18;
+(UIFont *)fontPFM20;
+(UIFont *)fontPFM24;
+(UIFont *)fontPFM57;

+(UIFont *)fontPFSB12;
+(UIFont *)fontPFSB14;
+(UIFont *)fontPFSB16;
+(UIFont *)fontPFSB17;
+(UIFont *)fontPFSB18;
+(UIFont *)fontPFSB21;
+(UIFont *)fontPFSB22;

+(UIFont *)fontSFR12;
+(UIFont *)fontSFM13;
+(UIFont *)fontSFM14;
@end
