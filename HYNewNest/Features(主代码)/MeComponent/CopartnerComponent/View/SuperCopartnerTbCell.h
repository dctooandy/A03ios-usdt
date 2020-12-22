//
//  SuperCopartnerTbCell.h
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCopartnerTbConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperCopartnerTbCell : UITableViewCell
@property (assign, nonatomic) SuperCopartnerType scType;

- (void)setupType:(SuperCopartnerType)type strArr:(NSArray<NSString *> *)strArr;
@end

NS_ASSUME_NONNULL_END
