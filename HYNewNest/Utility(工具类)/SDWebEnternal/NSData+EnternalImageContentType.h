//
//  NSData+EnternalImageContentType.h
//  HYNewNest
//
//  Created by Andy on 2022/2/23.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
typedef NS_ENUM(NSInteger, SDEnternalImageFormat) {
    SDEnternalImageFormatUndefined = -1,
    SDEnternalImageFormatJPEG = 0,
    SDEnternalImageFormatPNG,
    SDEnternalImageFormatGIF,
    SDEnternalImageFormatTIFF,
    SDEnternalImageFormatWebP,
    SDEnternalImageFormatHEIC,
    SDEnternalImageFormatHEIF
};
@interface NSData (EnternalImageContentType)
/**
 *  Convert SDImageFormat to UTType
 *
 *  @param format Format as SDImageFormat
 *  @return The UTType as CFStringRef
 */
+ (nonnull CFStringRef)sd_UTTypeFromSDImageFormat:(SDEnternalImageFormat)format;
@end


