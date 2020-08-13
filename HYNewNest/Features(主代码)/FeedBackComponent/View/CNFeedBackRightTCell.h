//
//  CNFeedBackRightTCell.h
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNFeedBackRightTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *textBGView;
@end

NS_ASSUME_NONNULL_END
