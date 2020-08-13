//
//  HYXiMaTopView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYXiMaTopView : CNBaseXibView
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, copy) dispatch_block_t clickBlock;
@end

NS_ASSUME_NONNULL_END
