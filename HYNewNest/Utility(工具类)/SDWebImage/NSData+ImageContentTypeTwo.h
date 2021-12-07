//
//  NSData+ImageContentTypeTwo.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/7.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

typedef NS_ENUM(NSInteger, SDImageFormatTwo) {
    SDImageFormatUndefined2 = -1,
    SDImageFormatJPEG2 = 0,
    SDImageFormatPNG2,
    SDImageFormatGIF2,
    SDImageFormatTIFF2,
    SDImageFormatWebP2,
    SDImageFormatHEIC2,
    SDImageFormatHEIF2
};

@interface NSData (ImageContentTypeTwo)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `SDImageFormat` (enum)
 */
+ (SDImageFormatTwo)sd_imageFormatForImageData:(nullable NSData *)data;

/**
 *  Convert SDImageFormat to UTType
 *
 *  @param format Format as SDImageFormat
 *  @return The UTType as CFStringRef
 */
+ (nonnull CFStringRef)sd_UTTypeFromSDImageFormat:(SDImageFormatTwo)format;

/**
 *  Convert UTTyppe to SDImageFormat
 *
 *  @param uttype The UTType as CFStringRef
 *  @return The Format as SDImageFormat
 */
+ (SDImageFormatTwo)sd_imageFormatFromUTType:(nonnull CFStringRef)uttype;

@end
