//
//  DSBRchrWthdrwHeader.h
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSBRecharWithdrwUsrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBRchrWthdrwHeader : UITableViewHeaderFooterView
- (void)setup123DataArr:(NSArray<DSBRecharWithdrwUsrModel *> *)arr;
@end

NS_ASSUME_NONNULL_END
