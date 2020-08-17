//
//  CNRecordTypeSelectorView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"
#import "CreditQueryResultModel.h"
#import "CNSelectBtn.h"

NS_ASSUME_NONNULL_BEGIN
@interface CNRecordTypeSelectorView : CNBaseXibView

@property (weak, nonatomic) IBOutlet CNSelectBtn *withdrawBtn;

+ (void)showSelectorWithSelcType:(TransactionRecordType)type dayParm:(NSInteger)day callBack:(void (^)(NSString * type, NSString * day))callBack;
@end

NS_ASSUME_NONNULL_END
