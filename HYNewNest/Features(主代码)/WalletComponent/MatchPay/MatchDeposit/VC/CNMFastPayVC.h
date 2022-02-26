//
//  CNMFastPayVC.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/16/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMDepositBaseVC.h"
#import "CNWAmountListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMFastPayVC : CNMDepositBaseVC
@property (nonatomic, strong) CNWFastPayModel *fastModel;
@end

NS_ASSUME_NONNULL_END
