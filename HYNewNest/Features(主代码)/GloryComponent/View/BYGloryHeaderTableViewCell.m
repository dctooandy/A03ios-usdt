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
#import <JXCategoryView/JXCategoryView.h>
#import "UIColor+Gradient.h"
#import "BYGloryHeaderContentItem.h"
#import "BYGloryModel.h"


@interface BYGloryHeaderTableViewCell () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoBackground;
@property (weak, nonatomic) IBOutlet JXCategoryTitleImageView *gloryTabView;
@property (weak, nonatomic) IBOutlet UIView *listBackgroundView;
@property (weak, nonatomic) UIButton *playVideoButton;

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) NSArray<GloryBannerModel *> *banners;

@end

@implementation BYGloryHeaderTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.banners = [[NSArray alloc] initWithObjects:[[GloryBannerModel alloc] initWithTitle:@"星级身分" content:@"新人大礼包｜晋级礼金｜洗码返水｜月月分红\n馀额理财|返利日大回馈｜小姐姐陪玩" imageName:@"banner_star" hideButton:false webURL:H5URL_Pub_Star]
                    , [[GloryBannerModel alloc] initWithTitle:@"私享会俱乐部" content:@"抽大金劳｜玩小明星\n奢侈品任抽｜豪华订制游" imageName:@"banner_shareclub" hideButton:false webURL:H5URL_VIP]
                    , [[GloryBannerModel alloc] initWithTitle:@"超级合伙" content:@"推荐礼金月月领\n洗码佣金无限返" imageName:@"banner_partner" hideButton:false webURL:H5URL_Share]
                    , [[GloryBannerModel alloc] initWithTitle:@"节日赠礼" content:@"订制节日礼品" imageName:@"banner_gift" hideButton:true webURL:@""], nil];
    
    [self setupCellUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Custom Method
- (void)setupCellUI {
    self.gloryTabView.titles = @[@"星级身分", @"私享会俱乐部", @"超级合伙", @"节日赠礼"];
    self.gloryTabView.titleColor = kHexColor(0x8F8F8F);
    self.gloryTabView.titleSelectedColor = kHexColor(0x0FB4DD);
    self.gloryTabView.imageNames = @[@"icon_star", @"icon_shareclub", @"icon_partner", @"icon_gift"];
    self.gloryTabView.selectedImageNames = @[@"icon_star_selected", @"icon_shareclub_selected", @"icon_partner_selected", @"icon_gift_selected"];
    self.gloryTabView.delegate = self;
    self.gloryTabView.defaultSelectedIndex = 0;
    self.gloryTabView.imageSize = CGSizeMake(20, 20);
    self.gloryTabView.titleFont = [UIFont fontPFM11];
    self.gloryTabView.cellWidth = 83 * (kScreenWidth / 375) - 5;
    self.gloryTabView.cellSpacing = 0;
    self.gloryTabView.imageTypes = @[@(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage)];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withWidth:1];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.gloryTabView.indicators = @[lineView];
    
    self.gloryTabView.listContainer = self.listContainerView;
    self.listContainerView.frame = CGRectMake(0, 0, kScreenWidth - 40, 110);// (kScreenWidth - 40) * (110.f / 335));
    [self.listBackgroundView addSubview:self.listContainerView];
    [self.gloryTabView reloadData];
    
    self.player = [SJVideoPlayer player];
    self.player.autoplayWhenSetNewAsset = NO;
    self.player.pauseWhenAppDidEnterBackground = YES;
    self.player.pausedToKeepAppearState = YES;
    self.player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    self.player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
    self.player.rotationManager.disabledAutorotation = YES;
    [self.player.defaultEdgeControlLayer.topAdapter setHidden:true];
    self.player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = true;
    self.player.muted = true;
    
    
    WEAKSELF_DEFINE
    self.player.playbackObserver.timeControlStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        STRONGSELF_DEFINE
        if (player.timeControlStatus == SJPlaybackTimeControlStatusPaused) {
           strongSelf.playVideoButton.selected = NO;
           strongSelf.playVideoButton.hidden = NO;
        }else{
            strongSelf.playVideoButton.selected = YES;
            strongSelf.playVideoButton.hidden = YES;
        }
    };
        
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://hwvod.yzbabyu.com:8443/vod-play/83e6dy/fengcai.mp4"]];
    [self.player.presentView.placeholderImageView setImage:[UIImage imageNamed:@"pic_conver"]];
    self.player.hiddenPlaceholderImageViewWhenPlayerIsReadyForDisplay = false;
    
    [self.videoBackground addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoBackground);
        make.bottom.equalTo(self.videoBackground);
        make.leading.equalTo(self.videoBackground);
        make.trailing.equalTo(self.videoBackground);
    }];
    
    UIButton *videoPlayBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.player.view  addSubview:videoPlayBtn];
    [videoPlayBtn setImage:[UIImage imageNamed:@"play_video"] forState:UIControlStateNormal];
    [videoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.player.view.mas_centerX);
        make.centerY.equalTo(self.player.view.mas_centerY);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [videoPlayBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playVideoButton = videoPlayBtn;
    
    UIButton *muteButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.player.view addSubview:muteButton];
    
    [muteButton setBackgroundImage:[UIImage imageNamed:@"icon_volume_off"] forState:UIControlStateNormal];
    [muteButton setBackgroundImage:[UIImage imageNamed:@"icon_volume_on"] forState:UIControlStateSelected];
    [muteButton addTarget:self action:@selector(muteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.player.view.mas_top).offset(15);
        make.trailing.equalTo(self.player.view.mas_trailing).offset(-15);
    }];
}

-(void)videoClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(btn.selected){
        [self.player play];
        [self.player.presentView.placeholderImageView setImage:nil];

    }
    else{
        [self.player pause];
    }
}

- (void)muteClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    self.player.muted = !btn.selected;
    [CNTOPHUB showAlert:[NSString stringWithFormat:@"声音已%@", btn.selected == true ? @"开启" : @"关闭"]];
}

#pragma mark -
#pragma mark JXCategoryListContainerViewDelegate
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _listContainerView.backgroundColor = [UIColor clearColor];
        _listContainerView.listCellBackgroundColor = [UIColor clearColor];
    }
    return _listContainerView;
}

#pragma mark -
#pragma mark JXCategoryViewDelegate
//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    NSLog(@"Clicked : %li", index);
//}

#pragma mark -
#pragma mark JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    BYGloryHeaderContentItem *view = [[BYGloryHeaderContentItem alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    [view setupGloryBanner:self.banners[index]];
    return view;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 4;
}

@end
