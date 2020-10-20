//
//  HYWithdrawChooseWallectComView.h
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYSlideUpComfirmBaseView.h"
#import "AccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYWithdrawChooseWallectComView : HYSlideUpComfirmBaseView

+ (void)showWithAmount:(NSNumber *)amount subWalAccountsModel:(nullable NSArray<AccountModel *> *)models submitHandler:(void (^)(NSString * _Nonnull))handler ;

@end

NS_ASSUME_NONNULL_END
