//
//  NSData+ImageContentTypeTwo.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/7.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "NSData+ImageContentTypeTwo.h"
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

@implementation NSData (ImageContentTypeTwo)

+ (SDImageFormatTwo)sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return SDImageFormatUndefined2;
    }
    
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return SDImageFormatJPEG2;
        case 0x89:
            return SDImageFormatPNG2;
        case 0x47:
            return SDImageFormatGIF2;
        case 0x49:
        case 0x4D:
            return SDImageFormatTIFF2;
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return SDImageFormatWebP2;
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return SDImageFormatHEIC2;
                }
                if ([testString isEqualToString:@"ftypmif1"] || [testString isEqualToString:@"ftypmsf1"]) {
                    return SDImageFormatHEIF2;
                }
            }
            break;
        }
    }
    return SDImageFormatUndefined2;
}

+ (nonnull CFStringRef)sd_UTTypeFromSDImageFormat:(SDImageFormatTwo)format {
    CFStringRef UTType;
    switch (format) {
        case SDImageFormatJPEG2:
            UTType = kUTTypeJPEG;
            break;
        case SDImageFormatPNG2:
            UTType = kUTTypePNG;
            break;
        case SDImageFormatGIF2:
            UTType = kUTTypeGIF;
            break;
        case SDImageFormatTIFF2:
            UTType = kUTTypeTIFF;
            break;
        case SDImageFormatWebP2:
            UTType = kSDUTTypeWebP;
            break;
        case SDImageFormatHEIC2:
            UTType = kSDUTTypeHEIC;
            break;
        case SDImageFormatHEIF2:
            UTType = kSDUTTypeHEIF;
            break;
        default:
            // default is kUTTypePNG
            UTType = kUTTypePNG;
            break;
    }
    return UTType;
}

+ (SDImageFormatTwo)sd_imageFormatFromUTType:(CFStringRef)uttype {
    if (!uttype) {
        return SDImageFormatUndefined2;
    }
    SDImageFormatTwo imageFormat;
    if (CFStringCompare(uttype, kUTTypeJPEG, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatJPEG2;
    } else if (CFStringCompare(uttype, kUTTypePNG, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatPNG2;
    } else if (CFStringCompare(uttype, kUTTypeGIF, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatGIF2;
    } else if (CFStringCompare(uttype, kUTTypeTIFF, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatTIFF2;
    } else if (CFStringCompare(uttype, kSDUTTypeWebP, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatWebP2;
    } else if (CFStringCompare(uttype, kSDUTTypeHEIC, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatHEIC2;
    } else if (CFStringCompare(uttype, kSDUTTypeHEIF, 0) == kCFCompareEqualTo) {
        imageFormat = SDImageFormatHEIF2;
    } else {
        imageFormat = SDImageFormatUndefined2;
    }
    return imageFormat;
}

@end
