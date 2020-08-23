//
//  AlertViewHelp.h
//  HyEntireGame
//
//  Created by kunlun on 2018/10/8.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, AlertMessageButtonType){
    /** 取消 */
    HelpCancelButtonTag = 0,
    
    /* 确定 */
    HelpOKButtonTag = 1
};

@interface AlertViewHelp : NSObject

// 此方法创建全局对象，消失，会把他局对象释放掉，并非单例
+ (instancetype)sharedAlertViewHelp;

/**
 * 弹出警告消息
 *
 *  @param title   标题
 *  @param message 提示信息
 *  @param okTitle 确定按钮标题
 *  @param finish  完成block
 */
- (void)alertMessageWithTitle:(NSString *)title
                      message:(NSString *)message
                      okTitle:(NSString *)okTitle
                       finish:(void(^)(AlertMessageButtonType buttonIndex))finish;

/**
 *  弹出警告消息
 *
 *  @param title       标题
 *  @param message     提示信息
 *  @param cancelTitle 取消按钮标题
 *  @param okTitle     确定按钮标题
 *  @param finish      完成block
 */
- (void)alertMessageWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                      okTitle:(NSString *)okTitle
                       finish:(void(^)(AlertMessageButtonType buttonIndex))finish;
@end

