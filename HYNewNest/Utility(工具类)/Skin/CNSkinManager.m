//
//  CNSkinManager.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/7.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNSkinManager.h"

NSString * const CNSkinChangeNotification = @"CNSkinChangeNotification";
static NSString * const currentSkinKey = @"CNCurrentSkinKey";

NSDictionary *SkinDictionary() {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SkinMapValue" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    return dic;
}

@interface CNSkinManager ()

@property (nonatomic, assign) SKinType currentSkin;
@end

@implementation CNSkinManager

+ (instancetype)defaultManager {
    static CNSkinManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CNSkinManager new];
        instance.currentSkin = (SKinType)[[NSUserDefaults standardUserDefaults] integerForKey:currentSkinKey];
    });
    return instance;
}

#pragma - mark 切换肤色

+ (void)setSkinTpye:(SKinType)type {
    [CNSkinManager defaultManager].currentSkin = type;
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)type forKey:currentSkinKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 切换发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CNSkinChangeNotification object:nil userInfo:nil];
}

+ (SKinType)currSkinType {
    return (SKinType)[[NSUserDefaults standardUserDefaults] integerForKey:currentSkinKey];
}


#pragma - mark 换肤-颜色

+ (UIColor *)skin_colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    
    if (hexColor.length < 6) {
        return nil;
    }
    
    // 读取 plist 中的对应颜色换肤色值
    NSString *hex = hexColor.uppercaseString;
    switch ([CNSkinManager defaultManager].currentSkin) {
        case SKinTypeLight:
            hex = [SkinDictionary() objectForKey:hex];
            break;
            
        default:
            break;
    }
    
    // 映射值错误或没有就使用传入值
    if (hex.length < 6) {
        hex = hexColor;
    }
    return [CNSkinManager colorWithHex:hex alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alpha {
    if (hexValue.length < 6) {
        return nil;
    }
    unsigned int red,green,blue;

    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexValue substringWithRange:range]] scanHexInt:&blue];

    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


#pragma - mark 换肤-图片

+ (UIImage *)skin_imageNamed:(NSString *)name {
    
    if (![name isKindOfClass:[NSString class]] || name.length == 0) {
        return nil;
    }
    
    NSString *newName = name;
    switch ([CNSkinManager defaultManager].currentSkin) {
        case SKinTypeLight:
            newName = [NSString stringWithFormat:@"light_%@", name];
            break;
            
        default:
            break;
    }
    
    return [UIImage imageNamed:newName];
}

@end





@implementation UIColor (Skin)

+ (UIColor *)skin_colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    return [CNSkinManager skin_colorWithHex:hexColor alpha:alpha];
}

+ (UIColor *)skin_colorWithHex:(NSString *)hexColor {
    return [CNSkinManager skin_colorWithHex:hexColor alpha:1.0];
}

@end



@implementation UIImage (Skin)

+ (UIImage *)skin_imageNamed:(NSString *)name {
    return [CNSkinManager skin_imageNamed:name];
}

@end
