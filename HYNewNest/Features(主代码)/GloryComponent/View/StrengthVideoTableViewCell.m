//
//  StrengthVideoTableViewCell.m
//  HyEntireGame
//
//  Created by bux on 2018/10/4.
//  Copyright © 2018年 kunlun. All rights reserved.
//

#import "StrengthVideoTableViewCell.h"
#import "VideoThumbnailManage.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "NSURL+HYLink.h"
#import <UIImageView+WebCache.h>

@interface StrengthVideoTableViewCell()

@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation StrengthVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = KColorRGBA(16, 16, 28, 1);

        _newsTitleLabel = [[UILabel alloc]init];
        _newsTitleLabel.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
        _newsTitleLabel.font = [UIFont fontPFM16];
        _newsTitleLabel.numberOfLines = 0;
        _newsTitleLabel.text = @"币游签约了100多个女优，全新豪华游艇啪。";
        [self.contentView addSubview:_newsTitleLabel];
//        [_newsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(15);
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        _newsTitleLabel.frame = CGRectMake(15, 15, self.width - 30, 20);

        _player = [SJVideoPlayer player];
        _player.defaultEdgeControlLayer.showResidentBackButton = NO;
        _player.autoplayWhenSetNewAsset = NO;
        _player.pauseWhenAppDidEnterBackground = YES;
        _player.pausedToKeepAppearState = YES;
        _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
        // 是否在竖屏显示返回
        _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
        // 是否在loadingView上显示网速
//        _player.defaultEdgeControlLayer.showNetworkSpeedToLoadingView = YES;
        _player.rotationManager.disabledAutorotation = YES;
        
        WEAKSELF_DEFINE
        _player.playbackObserver.timeControlStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
            
            STRONGSELF_DEFINE
            if (player.timeControlStatus == SJPlaybackTimeControlStatusPaused) {
               strongSelf.videoPlayBtn.selected = NO;
               strongSelf.videoPlayBtn.hidden = NO;
            }else{
                strongSelf.videoPlayBtn.selected = YES;
                strongSelf.videoPlayBtn.hidden = YES;
                
            }
        };

        [self.contentView addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.newsTitleLabel.mas_bottom).offset(30);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo((kScreenWidth-30)*160/345.0);
        }];
            
        __weak typeof(self) _self = self;
        _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
                __strong typeof(_self) self = _self;
                if ( !self ) return ;
        #ifdef DEBUG
                NSLog(@"%d \t %s", (int)__LINE__, __func__);
        #endif
            };

        UIButton *videoPlayBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_player.view  addSubview:videoPlayBtn];
        [videoPlayBtn setImage:[UIImage imageNamed:@"btn_video_play"] forState:UIControlStateNormal];
        [videoPlayBtn setImage:[UIImage imageNamed:@"btn_video_stop"] forState:UIControlStateSelected];
        [videoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.player.view.mas_centerX);
            make.centerY.equalTo(self.player.view.mas_centerY);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(38);
        }];
        [videoPlayBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        self.videoPlayBtn = videoPlayBtn;

        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = kHexColorAlpha(0xFFFFFF, 0.3);
        _dateLabel.font = [UIFont fontPFR13];
        _dateLabel.text = @"币游动态      1年前";
        _dateLabel.numberOfLines = 0;
        [self.contentView addSubview:_dateLabel];
//        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_player.view.mas_bottom).offset(10);
//            make.left.equalTo(self.contentView).offset(15);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.bottom.equalTo(self.contentView).offset(-11);
//        }];
        _dateLabel.frame = CGRectMake(15, CGRectGetMaxY(_newsTitleLabel.frame)+5, self.width-30, 17);

//        UIButton *checkDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [checkDetailBtn setTitleColor:kHexColorAlpha(0xFFFFFF, 0.5) forState:UIControlStateNormal];
//        [checkDetailBtn setTitle:@"置顶" forState:UIControlStateNormal];
//        [checkDetailBtn setBackgroundImage:[UIImage imageNamed:@"mine_tipbg_0"] forState:UIControlStateNormal];
//        checkDetailBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
//        [self.contentView addSubview:checkDetailBtn];

//        [checkDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-15);
//            make.bottom.equalTo(self.contentView).offset(-5);
//            make.width.mas_equalTo(50);
//            make.height.mas_equalTo(27);
//        }];
//        self.checkDetailBtn = checkDetailBtn;

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kHexColorAlpha(0x6D778B, 0.3);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.3);
        }];

    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [_newsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(15);
//        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.contentView).offset(-15);
//    }];
//    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.newsTitleLabel.mas_bottom).offset(30);
//        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.contentView).offset(-15);
//        make.height.mas_equalTo((kScreenWidth-30)*160/345.0);
//    }];
//    [_videoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.player.view.mas_centerX);
//        make.centerY.equalTo(self.player.view.mas_centerY);
//        make.width.mas_equalTo(38);
//        make.height.mas_equalTo(38);
//    }];
//    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_player.view.mas_bottom).offset(10);
//        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.contentView).offset(-15);
//        make.bottom.equalTo(self.contentView).offset(-11);
//    }];
//    [_checkDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-15);
//        make.bottom.equalTo(self.contentView).offset(-5);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(27);
//    }];
//
//}

-(void)setDataModel:(ArticalModel*)articleModel{
    _newsTitleLabel.text = articleModel.titleName;
    if (articleModel.publishDate.length > 1) {
//        NSString *foramt = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *date =  [NSDate dateFromString:articleModel.publishDate withFormat:foramt];
//        NSString *dateStr = [NSDate stringFromDate:date withFormat:@"yyyy年MM月dd日"];
//        NSString *detailStr = [NSString stringWithFormat:@"%@   %@",self.type,dateStr];
        _dateLabel.text = articleModel.publishDate;
    }
    self.checkDetailBtn.hidden = YES;
   
    NSString *bannerUrl = [NSURL getStrUrlWithString:articleModel.bannerUrl];
    [_player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:nil];
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:articleModel.linkUrl]];
}

-(void)videoClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if(btn.selected){
        [_player play];
    }else{
        [_player pause];
    }
    
    /*
    if (self.videoClick) {
        self.videoClick(btn.selected);
    }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
