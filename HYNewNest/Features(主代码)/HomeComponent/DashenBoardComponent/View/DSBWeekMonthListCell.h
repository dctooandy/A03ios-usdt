//
//  DSBWeekMonthListCell.h
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSBWeekMonthListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *btmLine;

- (void)setupDataArr:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
