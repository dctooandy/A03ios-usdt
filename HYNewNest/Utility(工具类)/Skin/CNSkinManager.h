//
//  CNSkinManager.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/7.
//  Copyright © 2020 james. All rights reserved.

/** 换肤文件管理
 1、设置当前肤色, “setSkinTpye:”，默认是 SKinTypeNormal
 2、填写对应颜色值到 SkinMapValue.plist 中，normal 颜色值为key ，black 颜色值为value，注意大写；UIColor分类API
 3、图片命名，black 需要在normal 前加上 “black_”, 例如 normal图片是 “banner”，black图片就是 “black_banner”；UIImage分类API
 4、图片和颜色加载时机最好在 "viewWillAppear:" 中，这样切换肤色后，页面会重新刷新，避免发通知
 5、无法在 "viewWillAppear:" 中实现的，可以监听通知 “CNSkinChangeNotification”，切换皮肤内部会发出通知
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 换肤通知名称
FOUNDATION_EXPORT NSString * const CNSkinChangeNotification;

typedef NS_ENUM(NSUInteger, SKinType) {
    SKinTypeNormal, // 默认色
    SKinTypeBlack,  // 暗黑色
};

@interface CNSkinManager : NSObject

/// 切换当前皮肤类型
/// @param type  SKinType 类型
+ (void)setSkinTpye:(SKinType)type;

@end


@interface UIColor (Skin)

/// 换肤专用颜色API，内部已做好不同肤色颜色映射，不同肤色也是传默认颜色key值
/// @param hexColor  默认颜色 SKinTypeNormal 16进制颜色值，如 "7F4CEE" 不限大小写
+ (UIColor *)skin_colorWithHex:(NSString *)hexColor;
@end

@interface UIImage (Skin)

/// 换肤专用图片API，内部已做好不同肤色图片切换，只需传 normal 图片名称
/// @param name   SKinTypeNormal 下的图片名称
+ (UIImage *)skin_imageNamed:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
