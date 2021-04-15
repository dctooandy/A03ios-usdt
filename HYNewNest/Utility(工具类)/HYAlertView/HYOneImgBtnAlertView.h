//
//  HYOneImgBtnAlertView.h
//  HYNewNest
//
//  Created by zaky on 4/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYOneImgBtnAlertView : HYBaseAlertView

// 负信用提现弹窗 （右上角关闭按钮 中间图片 说明文字 底部按钮）
+ (void)showWithImgName:(NSString *)img
          contentString:(NSString *)content
                btnText:(NSString *)text
                handler:(void (^)(BOOL isComfirm))handler;

@end

NS_ASSUME_NONNULL_END
