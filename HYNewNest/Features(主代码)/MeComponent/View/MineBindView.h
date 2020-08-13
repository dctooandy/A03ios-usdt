//
//  MineBindView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/10.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HYBindType) {
    HYBindTypeWechat = 0,
    HYBindTypeEMail,
};

@interface MineBindView : UIView

- (instancetype)initWithBindType:(HYBindType)bindType
                    comfirmBlock:(void(^)(NSString *text))comfirmBlock;

@end

NS_ASSUME_NONNULL_END
