//
//  StrengthVideoTableViewCell.h
//  HyEntireGame
//
//  Created by bux on 2018/10/4.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticalModel.h"

@interface StrengthVideoTableViewCell : UITableViewCell

@property (nonatomic, strong)NSString *type;

@property(nonatomic,weak) NSIndexPath *indexPath;
@property (strong,nonatomic) UILabel *newsTitleLabel; //!<标题
//@property (strong,nonatomic) UIImageView *videoImgView; //!<视频图片
@property (strong,nonatomic) UIButton *videoPlayBtn ;
@property (strong,nonatomic) UILabel *dateLabel; //!<日期
@property (strong,nonatomic) UIButton *checkDetailBtn; //置顶
@property (copy,nonatomic) void(^videoClick)(BOOL isStart); //YES 播放  NO 暂停

-(void)setDataModel:(ArticalModel*)articleModel;

@end
