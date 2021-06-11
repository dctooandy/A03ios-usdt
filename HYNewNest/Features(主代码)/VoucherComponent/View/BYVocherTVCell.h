//
//  BYVocherTVCell.h
//  HYNewNest
//
//  Created by zaky on 3/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BYVocherModel;
@interface BYVocherTVCell : UITableViewCell
@property (assign,nonatomic) BOOL isExpand;
@property (strong,nonatomic) BYVocherModel *model;
@property (copy,nonatomic) void(^changeCellHeightBlock)(BOOL isExpand) ;
@end

NS_ASSUME_NONNULL_END
