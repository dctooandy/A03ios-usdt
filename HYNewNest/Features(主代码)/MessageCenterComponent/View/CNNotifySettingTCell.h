//
//  CNNotifySettingTCell.h
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNNotifySettingTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, copy) void(^btnClick)(BOOL selected);
@end

NS_ASSUME_NONNULL_END
