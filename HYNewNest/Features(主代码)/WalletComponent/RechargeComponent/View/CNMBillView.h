//
//  CNMBillView.h
//  HYNewNest
//
//  Created by cean on 3/17/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMBillView : CNBaseXibView
@property (weak, nonatomic) IBOutlet UILabel *billNoLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
- (void)setPromoTag:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
