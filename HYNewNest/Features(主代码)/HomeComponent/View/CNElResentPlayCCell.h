//
//  CNElResentPlayCCell.h
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNElResentPlayCCell : UICollectionViewCell
/// 游戏图
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/// 游戏名称
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
/// 游戏类型
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
/// 游戏人数
//@property (weak, nonatomic) IBOutlet UILabel *playCountLb;
@end

NS_ASSUME_NONNULL_END
