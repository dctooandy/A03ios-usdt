//
//  CNRecordTypeSelectorView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"
typedef NS_ENUM(NSInteger, VIPReceiveRecordType) {
    VIPReceiveRecordTypeZZZP = 0,
    VIPReceiveRecordTypeLJSF
};

NS_ASSUME_NONNULL_BEGIN
@interface VIPRecordSelectorView : CNBaseXibView

+ (void)showSelectorWithSelcType:(VIPReceiveRecordType)type
                         dayParm:(NSInteger)day
                        callBack:(void (^)(VIPReceiveRecordType type, NSInteger day))callBack;
@end

NS_ASSUME_NONNULL_END
