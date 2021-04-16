//
//  SuperCopartnerTbFooter.h
//  HYNewNest
//
//  Created by zaky on 12/18/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCopartnerTbConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperCopartnerTbFooter : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *lbYlq;
@property (weak, nonatomic) IBOutlet UILabel *lbReceivedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbWlq;
@property (weak, nonatomic) IBOutlet UILabel *lbNotReceivedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbMiddle;
- (void)setupFootType:(SuperCopartnerType)type;
@end

NS_ASSUME_NONNULL_END
