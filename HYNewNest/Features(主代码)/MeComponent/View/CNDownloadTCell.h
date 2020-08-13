//
//  CNDownloadTCell.h
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNDownloadTCell : UITableViewCell
/// App图片
@property (weak, nonatomic) IBOutlet UIImageView *appImageV;
/// App名称
@property (weak, nonatomic) IBOutlet UILabel *appNameLb;
/// App描述
@property (weak, nonatomic) IBOutlet UILabel *appDescLb;
/// 下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (nonatomic, copy) dispatch_block_t downloadAction;
@end

NS_ASSUME_NONNULL_END
