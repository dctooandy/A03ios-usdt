//
//  UIImage+TKUtilities.h
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <ImageIO/ImageIO.h>

@interface UIImage (ESUtilities)
- (UIImage*)thumbnailImage:(CGSize)targetSize;

//压缩图片
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (CGFloat)imageCompressWithWidth:(UIImage*)image;
+ (CGFloat)imageCompressWithWidth:(CGFloat)width  withImage:(UIImage*)image;
+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                          backGroundColor:(UIColor*)bgColor
                          bounds:(CGRect)bounds;
+ (UIImage*)createImageWithRadius:(CGFloat)radius Color:(UIColor *)color bounds:(CGRect)rect;
- (UIImage*)getGrayImage;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
@end
