//
//  CNElectrionHallVC.m
//  HYNewNest
//
//  Created by Cean on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNElectrionHallVC.h"
#import "CNElectionTypeSelectorView.h"
#import "CNElectrionHallCCell.h"
#define kCNElectrionHallCCellID  @"CNElectrionHallCCell"
#import "CNELSearchVC.h"
#import "GameStartPlayViewController.h"
#import "CNHomeRequest.h"
#import "SDCycleScrollView.h"
#import <MJRefresh/MJRefresh.h>

typedef enum : NSUInteger {
    CNELTypeRecommend,
    CNELTypeFilter,
    CNELTypeCollection,
} CNELType;

@interface CNElectrionHallVC () <UICollectionViewDataSource, UICollectionViewDelegate, SDCycleScrollViewDelegate>

#pragma mark - 顶部视图和按钮组
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
/// 按钮跟随的下划线 centerX 的坐标
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomLineX;
/// 分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIStackView *btnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewH;
@property (weak, nonatomic) IBOutlet UIButton *hallBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineBtn;

#pragma mark - 底部承载视图
// 承载游戏列表父视图
@property (weak, nonatomic) IBOutlet UIView *listContentView;
// 承载推荐视图的滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *listRecommendSV;

#pragma mark - 推荐内容属性
// scrollView 宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvWidth;
// banner 视图
@property (weak, nonatomic) IBOutlet UIView *bannerView;
// banner 视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;

/// 高爆奖游戏，水平方向
@property (weak, nonatomic) IBOutlet UIView *baoJiangContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baoJiangContainerH;
@property (weak, nonatomic) IBOutlet UICollectionView *baoJiangCV;
/// 高奖池游戏，水平方向
@property (weak, nonatomic) IBOutlet UIView *jiangChiContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiangChiContainerH;
@property (weak, nonatomic) IBOutlet UICollectionView *jiangChiCV;
/// 高派彩游戏，水平方向
@property (weak, nonatomic) IBOutlet UIView *paiCaiContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paiCaiContainerH;
@property (weak, nonatomic) IBOutlet UICollectionView *paiCaiCV;
/// 下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

#pragma mark - 筛选和收藏属性
/// 筛选和收藏，垂直方向
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;

#pragma mark - 业务属性
/// 当前点击的类型
@property (nonatomic, assign) CNELType currentType;
@property (nonatomic, assign) NSInteger currentPage; // 搜索页页码
@property (nonatomic, strong) NSArray<ElecGameModel *> *highGames;
@property (nonatomic, strong) NSArray<ElecGameModel *> *poolGames;
@property (nonatomic, strong) NSArray<ElecGameModel *> *payoutGames;
@property (nonatomic, strong) NSArray<ElecGameModel *> *favoGames;
@property (nonatomic, strong) NSMutableArray<ElecGameModel *> *filtedGames;
/// 轮播图
@property (nonatomic, strong) SDCycleScrollView *banner;
@property (nonatomic, strong) NSArray<AdBannerModel *> *bannModels;
// 搜索
@property (nonatomic, strong)NSArray<NSString*> *filterHalls;
@property (nonatomic, strong)NSArray<NSString*> *filterTypes;
@property (nonatomic, strong)NSArray<NSString*> *filterLines;
@end

@implementation CNElectrionHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有游戏";
    // 设置banner的宽高
    self.cvWidth.constant = kScreenWidth;
    self.bannerHeight.constant = AD(115);
    [self.bannerView addSubview:self.banner];
    self.downLoadBtn.enabled = YES;
    
    self.currentPage = 1;
    self.filtedGames = @[].mutableCopy;
    [self configCollectionView];
    // 默认选择第一个
    [self recommend:self.recommendBtn];
    
    /// 推荐数据
    [self requestBanners];
    [self requestGPCGames];
    [self requestGBJGames];
    [self requestGJCGames];
}

// 推荐没有banner时隐藏
- (void)hideBanner:(BOOL)hide {
    self.bannerView.hidden = hide;
    self.bannerHeight.constant = hide ? 0: AD(115);
}

#pragma mark - REQUEST
- (void)requestBanners {
    WEAKSELF_DEFINE
    [CNHomeRequest requestBannerWhere:BannerWhereGame Handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!KIsEmptyString(errorMsg)) {
            return;
        }
        DYAdBannerGroupModel *groupModel = [DYAdBannerGroupModel cn_parse:responseObj];
        NSMutableArray *modArr = @[].mutableCopy;
        NSMutableArray *imgUrls = @[].mutableCopy;
        for (AdBannerModel *model in groupModel.bannersModel) {
            // !!!: 这里要根据货币模式筛选banner
            if([CNUserManager shareManager].isUsdtMode) {
                if ([model.linkParam[@"mode"] isEqualToString:@"rmb"]) { // usdt模式筛掉rmb banner
                    continue;
                }
            } else {
                if ([model.linkParam[@"mode"] isEqualToString:@"usdt"]) { // rmb模式筛掉usdt banner
                    continue;
                }
            }
            NSString *fullUrl = [groupModel.domainName stringByAppendingString:model.imgUrl];
            [imgUrls addObject:fullUrl];
            [modArr addObject:model];
        }
        strongSelf.banner.imageURLStringsGroup = imgUrls;
        strongSelf.bannModels = modArr;
    }];
}

- (void)requestGBJGames {
    // 高爆奖
    [CNHomeRequest queryElecGamesOneOfThreeType:ElecGame3TypeHigh handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            QueryElecGameModel *qModel = [QueryElecGameModel cn_parse:responseObj];
            self.highGames = qModel.data;
            if (self.highGames.count) {
                [self.baoJiangCV reloadData];
            } else {
                self.baoJiangContainer.hidden = YES;
                self.baoJiangContainerH.constant = 0;
            }
        }
    }];


}

- (void)requestGJCGames {
    // 高奖池
    [CNHomeRequest queryElecGamesOneOfThreeType:ElecGame3TypePool handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            QueryElecGameModel *qModel = [QueryElecGameModel cn_parse:responseObj];
            self.poolGames = qModel.data;
            if (self.poolGames.count) {
                [self.jiangChiCV reloadData];
            } else {
                self.jiangChiContainer.hidden = YES;
                self.jiangChiContainerH.constant = 0;
            }
        }
    }];
}

- (void)requestGPCGames {
    // 高派彩
    [CNHomeRequest queryElecGamesOneOfThreeType:ElecGame3TypePayout handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            QueryElecGameModel *qModel = [QueryElecGameModel cn_parse:responseObj];
            self.payoutGames = qModel.data;
            if (self.payoutGames.count) {
                [self.paiCaiCV reloadData];
            } else {
                self.paiCaiContainer.hidden = YES;
                self.paiCaiContainerH.constant = 0;
            }
        }
    }];
}

- (void)requestFavoriteGames {
    // 收藏的游戏
    [CNHomeRequest queryFavoriteElecHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            NSArray *models = [ElecGameModel cn_parse:responseObj];
            // 神他妈的数据
            for (ElecGameModel *m in models) {
                m.isFavorite = YES;
            }
            self.favoGames = models;
            [self.filterCollectionView reloadData];
        }
    }];
}

- (void)updateFavoriteModel:(ElecGameModel *)model isSelect:(BOOL)isSelect {
    //修改收藏
    [CNHomeRequest updateFavoriteElecGameId:model.gameId
                               platformCode:model.platformCode
                                       flag:isSelect?ElecGameFavoriteFlagAdd:ElecGameFavoriteFlagDel
                                    handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            if ([self.payoutGames containsObject:model]) {
                [self requestGPCGames];
            } else if ([self.poolGames containsObject:model]) {
                [self requestGJCGames];
            } else if ([self.poolGames containsObject:model]) {
                [self requestGBJGames];
            }
            [self requestFavoriteGames];
        }
    }];
}

/// 搜索游戏
- (void)filterSearchGames {
    // 赔付线
    NSMutableArray *payLines = @[].mutableCopy; // 啥都没有是空数组
    if (self.filterLines.count > 0 && ![self.filterLines containsObject:@"全部"]) {
        for (NSString *str in self.filterLines) {
            NSArray *data = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-线"]];
            data = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
            NSDictionary *dict = @{@"high":data.lastObject,@"low":data.firstObject};
            [payLines addObject:dict];
        }
    }
    // 游戏类型
    NSMutableString *numTypes = @"".mutableCopy;
    NSDictionary *gameCategory = @{@"老虎机":@"1",@"纸牌":@"2",@"街机游戏":@"3",@"赛车":@"4",@"刮刮乐":@"5",@"视频扑克":@"6",@"桌面游戏":@"7",@"其他":@"8"};
    if (self.filterTypes.count > 0 && ![self.filterTypes containsObject:@"全部"]) {
        for (int i=0; i<self.filterTypes.count; i++) {
            NSString *tyName = self.filterTypes[i];
            [numTypes appendString: gameCategory[tyName]];
            if (i != self.filterTypes.count-1) {
                [numTypes appendString:@","];
            }
        }
    }
    // 平台
    NSArray *platforms = @[];
    if (self.filterHalls.count > 0 && ![self.filterHalls containsObject:@"全部"]) {
        platforms = self.filterHalls;
    }
    [CNHomeRequest queryElecGamesWithPageNo:self.currentPage gemeType:numTypes platformNames:platforms payLines:payLines handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            QueryElecGameModel *qModel = [QueryElecGameModel cn_parse:responseObj];
            if (self.currentPage == 1) {
                self.filtedGames = qModel.data.mutableCopy;
            } else {
                [self.filtedGames addObjectsFromArray:qModel.data];
            }
            if (qModel.totalPage <= self.currentPage) {
                self.currentPage = 1;
                [self.filterCollectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.currentPage += 1;
                [self.filterCollectionView.mj_footer endRefreshing];
            }
            [self.filterCollectionView reloadData];
        }
    }];
}

#pragma mark - ButtonAction

// 去搜索
- (IBAction)gotoSearch:(id)sender {
    [self.navigationController pushViewController:[CNELSearchVC new] animated:YES];
}

// 推荐
- (IBAction)recommend:(UIButton *)sender {
    self.currentType = CNELTypeRecommend;
    [self buttonAciton:sender];
    
    self.listRecommendSV.hidden = NO;
    self.filterCollectionView.hidden = YES;
    [self.listContentView bringSubviewToFront:self.listRecommendSV];
}

// 收藏
- (IBAction)collection:(UIButton *)sender {
    self.currentType = CNELTypeCollection;
    [self buttonAciton:sender];
    
    self.listRecommendSV.hidden = YES;
    self.filterCollectionView.hidden = NO;
    [self.listContentView bringSubviewToFront:self.filterCollectionView];
    
    if (self.favoGames.count == 0) {
        [self requestFavoriteGames];
    } else {
        [self.filterCollectionView reloadData];
    }
    [self.filterCollectionView.mj_footer endRefreshingWithNoMoreData];
}

// 筛选
- (IBAction)filter:(UIButton *)sender {
    self.currentType = CNELTypeFilter;
    [self buttonAciton:sender];
    
    self.listRecommendSV.hidden = YES;
    self.filterCollectionView.hidden = NO;
    [self.listContentView bringSubviewToFront:self.filterCollectionView];
    
    if (self.filtedGames.count == 0) {
        [self filterSearchGames];
    } else {
        [self.filterCollectionView reloadData];
    }
    [self.filterCollectionView.mj_footer resetNoMoreData];
}

- (void)buttonAciton:(UIButton *)sender {
    self.recommendBtn.selected = NO;
    self.filterBtn.selected = NO;
    self.collectionBtn.selected = NO;
    sender.selected = YES;
    
    // 隐藏展开按钮视图
    BOOL show = [sender isEqual:self.filterBtn];
    self.lineView.hidden = !show;
    self.btnView.hidden = !show;
    self.btnViewH.constant = show ? 64: 0;
    
    // 下划线
    self.btnBottomLineX.constant = kScreenWidth/3 *sender.tag;
}

// 弹出筛选列表
- (IBAction)showFilter:(UIButton *)sender {
    NSArray *hallArr = [self.hallBtn.currentTitle componentsSeparatedByString:@","];
    NSArray *typeArr = [self.typeBtn.currentTitle componentsSeparatedByString:@","];
    NSArray *lineArr = [self.lineBtn.currentTitle componentsSeparatedByString:@","];
    [CNElectionTypeSelectorView showSelectorWithDefaultHall:hallArr defaultType:typeArr defaultLine:lineArr callBack:^(NSArray * _Nonnull halls, NSArray * _Nonnull types, NSArray * _Nonnull lines) {
        MyLog(@"%@,%@,%@", halls, types, lines);
        [self.hallBtn setTitle:[halls componentsJoinedByString:@","] forState:UIControlStateNormal];
        [self.typeBtn setTitle:[types componentsJoinedByString:@","] forState:UIControlStateNormal];
        [self.lineBtn setTitle:[lines componentsJoinedByString:@","] forState:UIControlStateNormal];
        
        self.filterHalls = halls;
        self.filterLines = lines;
        self.filterTypes = types;
        self.currentPage = 1;
        [self filterSearchGames];
    }];
}

// App下载
- (IBAction)downloadApp:(UIButton *)sender {
    
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (void)configCollectionView {
    // 推荐下三个滚动式图
    [self.baoJiangCV registerNib:[UINib nibWithNibName:kCNElectrionHallCCellID bundle:nil] forCellWithReuseIdentifier:kCNElectrionHallCCellID];
    [self.jiangChiCV registerNib:[UINib nibWithNibName:kCNElectrionHallCCellID bundle:nil] forCellWithReuseIdentifier:kCNElectrionHallCCellID];
    [self.paiCaiCV registerNib:[UINib nibWithNibName:kCNElectrionHallCCellID bundle:nil] forCellWithReuseIdentifier:kCNElectrionHallCCellID];
    
    // 收藏和筛选
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreenWidth - 15*3)/2;
    flowLayout.itemSize = CGSizeMake(itemW, itemW*150/165.0);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 15, 15, 15);
    self.filterCollectionView.collectionViewLayout = flowLayout;
    [self.filterCollectionView registerNib:[UINib nibWithNibName:kCNElectrionHallCCellID bundle:nil] forCellWithReuseIdentifier:kCNElectrionHallCCellID];
    self.filterCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(filterSearchGames)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 区分五个数据源，最好是五个数组
    if ([collectionView isEqual:self.baoJiangCV]) { //高爆
        return self.highGames.count;
    } else if ([collectionView isEqual:self.jiangChiCV]) { //奖池
        return self.poolGames.count;
    } else if ([collectionView isEqual:self.paiCaiCV]) { //派彩
        return self.payoutGames.count;
    } else if (self.currentType == CNELTypeFilter) { //筛选
        return self.filtedGames.count;
    } else if (self.currentType == CNELTypeCollection) { //收藏
        return self.favoGames.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNElectrionHallCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNElectrionHallCCellID forIndexPath:indexPath];
    // 区分不同数据源即可
    if ([collectionView isEqual:self.baoJiangCV]) { //高爆
        if (self.highGames.count > 0) {
            cell.model = self.highGames[indexPath.row];
        }
    } else if ([collectionView isEqual:self.jiangChiCV]) { //奖池
        if (self.poolGames.count > 0) {
            cell.model = self.poolGames[indexPath.row];
        }
    } else if ([collectionView isEqual:self.paiCaiCV]) { //派彩
        if (self.payoutGames.count > 0) {
            cell.model = self.payoutGames[indexPath.row];
        }
    } else if (self.currentType == CNELTypeFilter) { //筛选
       if (self.filtedGames.count > 0) {
           cell.model = self.filtedGames[indexPath.row];
       }
    } else if (self.currentType == CNELTypeCollection) { //收藏
        if (self.favoGames.count > 0) {
            cell.model = self.favoGames[indexPath.row];
        }
    }
    
    WEAKSELF_DEFINE
    cell.collectionBlock = ^(UIButton * _Nonnull btn, ElecGameModel *model) {
        STRONGSELF_DEFINE
        // 需要请求接口后才修改收藏状态
        btn.selected = !btn.selected;
        [strongSelf updateFavoriteModel:model isSelect:btn.selected];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ElecGameModel *model;
    // 区分不同数据源即可，没有点击事件可忽略
    if ([collectionView isEqual:self.baoJiangCV]) { //高爆
        model = self.highGames[indexPath.row];
    } else if ([collectionView isEqual:self.jiangChiCV]) { //奖池
        model = self.poolGames[indexPath.row];
    } else if ([collectionView isEqual:self.paiCaiCV]) { //派彩
        model = self.payoutGames[indexPath.row];
    } else if (self.currentType == CNELTypeFilter) { //筛选
        model = self.filtedGames[indexPath.row];
    } else { //收藏
        model = self.favoGames[indexPath.row];
    }
    
    // ================ 跳转 ================
    if (!model) {
        return;
    }
    NSString *gameCode;
    if ([model.platformCode containsString:@"A03"]) {
        gameCode = model.platformCode;
    }else{
        gameCode = [NSString stringWithFormat:@"A03%@", model.platformCode];
    }
    
    [CNHomeRequest requestInGameUrlGameType:model.gameType gameId:model.gameId gameCode:gameCode handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSMutableString *gameUrl = gameModel.url.mutableCopy;
        if (KIsEmptyString(gameUrl)) {
           [kKeywindow jk_makeToast:@"获取游戏数据为空" duration:1.5 position:JKToastPositionCenter];
           return;
        }
        if (gameModel.postMap) {
            if (![gameUrl containsString:@"?"]) {
                [gameUrl appendString:@"?"];
            }
            [gameUrl appendFormat:@"gameID=%@&gameType=%@&username=%@&password=%@", gameModel.postMap.gameID, gameModel.postMap.gameType, gameModel.postMap.username, gameModel.postMap.password];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl.copy title:model.gameName];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];

    }];
    
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannModels.count > 0 && self.bannModels.count-1 >= index) {
        AdBannerModel *model = self.bannModels[index];
        [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"活动"];
    }
}

#pragma mark - LAZY LOAD
- (SDCycleScrollView *)banner {
    if (!_banner) {
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, AD(345), AD(115)) delegate:self placeholderImage:[UIImage imageNamed:@"bannerdefault"]];
        cycleScrollView2.layer.cornerRadius = 10;
        cycleScrollView2.layer.masksToBounds = YES;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.autoScrollTimeInterval = 4;
        cycleScrollView2.currentPageDotColor = kHexColor(0x02EED9); // 自定义分页控件小圆标颜色
        _banner = cycleScrollView2;
    }
    return _banner;
}

@end
