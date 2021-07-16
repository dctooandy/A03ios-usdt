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
#import "BYGloryHeaderContentView.h"


@interface BYGloryHeaderTableViewCell () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoBackground;
@property (weak, nonatomic) IBOutlet JXCategoryTitleImageView *gloryTabView;
@property (weak, nonatomic) IBOutlet UIView *listBackgroundView;

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

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
    self.gloryTabView.titles = @[@"星级身分", @"私享会俱乐部", @"超级合伙", @"节日赠礼"];
    self.gloryTabView.titleColor = kHexColor(0x8F8F8F);
    self.gloryTabView.titleSelectedColor = kHexColor(0x0FB4DD);
    self.gloryTabView.imageNames = @[@"icon_star", @"icon_shareclub", @"icon_partner", @"icon_gift"];
    self.gloryTabView.selectedImageNames = @[@"icon_star_selected", @"icon_shareclub_selected", @"icon_partner_selected", @"icon_gift_selected"];
    self.gloryTabView.delegate = self;
    self.gloryTabView.defaultSelectedIndex = 0;
    self.gloryTabView.imageSize = CGSizeMake(30, 30);
    
    
    self.gloryTabView.imageTypes = @[@(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage), @(JXCategoryTitleImageType_TopImage)];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor gradientFromColor:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD) withWidth:80];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.gloryTabView.indicators = @[lineView];
    
    self.gloryTabView.listContainer = self.listContainerView;
    self.listContainerView.frame = CGRectMake(0, 0, kScreenWidth - 40, (kScreenWidth - 40) * (110.f / 335));
    [self.listBackgroundView addSubview:self.listContainerView];
    [self.gloryTabView reloadData];
    
    
}

#pragma mark -
#pragma mark
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
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"Clicked : %li", index);
}

#pragma mark -
#pragma mark JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    BYGloryHeaderContentView *view = [[BYGloryHeaderContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    return view;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 4;
}

@end
