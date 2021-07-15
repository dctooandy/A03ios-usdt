//
//  BYGloryHeaderTableViewCell.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/15.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryHeaderTableViewCell.h"
#import "VideoThumbnailManage.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "NSURL+HYLink.h"
#import <UIImageView+WebCache.h>

@interface BYGloryHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *videoBackground;

@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation BYGloryHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCellUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Custom Method
- (void)setupCellUI {
}
@end
