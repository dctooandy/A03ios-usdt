//
//  NSData+EnternalImageContentType.m
//  HYNewNest
//
//  Created by Andy on 2022/2/23.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "NSData+EnternalImageContentType.h"
#if SD_MAC
#import <CoreServices/CoreServices.h>
#else
#import <MobileCoreServices/MobileCoreServices.h>
#endif

// Currently Image/IO does not support WebP
#define kSDUTTypeWebP ((__bridge CFStringRef)@"public.webp")
// AVFileTypeHEIC/AVFileTypeHEIF is defined in AVFoundation via iOS 11, we use this without import AVFoundation
#define kSDUTTypeHEIC ((__bridge CFStringRef)@"public.heic")
#define kSDUTTypeHEIF ((__bridge CFStringRef)@"public.heif")

@implementation NSData (EnternalImageContentType)
+ (nonnull CFStringRef)sd_UTTypeFromSDImageFormat:(SDEnternalImageFormat)format {
    CFStringRef UTType;
    switch (format) {
        case SDEnternalImageFormatJPEG:
            UTType = kUTTypeJPEG;
            break;
        case SDEnternalImageFormatPNG:
            UTType = kUTTypePNG;
            break;
        case SDEnternalImageFormatGIF:
            UTType = kUTTypeGIF;
            break;
        case SDEnternalImageFormatTIFF:
            UTType = kUTTypeTIFF;
            break;
        case SDEnternalImageFormatWebP:
            UTType = kSDUTTypeWebP;
            break;
        case SDEnternalImageFormatHEIC:
            UTType = kSDUTTypeHEIC;
            break;
        case SDEnternalImageFormatHEIF:
            UTType = kSDUTTypeHEIF;
            break;
        default:
            // default is kUTTypePNG
            UTType = kUTTypePNG;
            break;
    }
    return UTType;
}
@end
