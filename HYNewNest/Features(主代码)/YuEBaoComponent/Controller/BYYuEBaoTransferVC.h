//
//  BYYuEBaoTransferVC.h
//  HYNewNest
//
//  Created by zaky on 5/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNYuEBaoRequest.h"

NS_ASSUME_NONNULL_BEGIN


@interface BYYuEBaoTransferVC : CNBaseVC
- (instancetype)initWithType:(YEBTransferType)type configModel:(CNYuEBaoConfigModel *)model;
@end

NS_ASSUME_NONNULL_END
