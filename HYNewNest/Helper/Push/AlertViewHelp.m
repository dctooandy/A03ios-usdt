//
//  AlertViewHelp.m
//  HyEntireGame
//
//  Created by kunlun on 2018/10/8.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "AlertViewHelp.h"
/** 警告视图的标志 */
#define HELP_ALERTVIEW_TAG   20000

static AlertViewHelp *shareInstance = nil;

@interface AlertViewHelp ()

@property (copy, nonatomic) void((^finishBlock)(AlertMessageButtonType buttonIndex));

@end

@implementation AlertViewHelp

// 此方法创建全局对象，消失，会把他局对象释放掉，并非单例
+ (instancetype)sharedAlertViewHelp {
    if (!shareInstance) {
        shareInstance = [[super allocWithZone:NULL] init];
    }
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedAlertViewHelp];
}

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
                       finish:(void(^)(AlertMessageButtonType buttonIndex))finish {
    
    self.finishBlock = finish;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:okTitle otherButtonTitles:nil, nil];
    alertView.tag = HELP_ALERTVIEW_TAG;
    [alertView show];
}

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
                       finish:(void(^)(AlertMessageButtonType buttonIndex))finish {
    
    self.finishBlock = finish;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alertView.tag = HELP_ALERTVIEW_TAG;
    [alertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == HELP_ALERTVIEW_TAG && self.finishBlock) {
        self.finishBlock(buttonIndex);
        [self destoryShareInstance];
    }
}

- (void)destoryShareInstance {
    if (self.finishBlock) {
        [self setFinishBlock:nil];
    }
    if (shareInstance) {
        shareInstance = nil;
    }
}
@end
