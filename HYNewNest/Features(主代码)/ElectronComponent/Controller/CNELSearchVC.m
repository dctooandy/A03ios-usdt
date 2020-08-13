//
//  CNELSearchVC.m
//  HYNewNest
//
//  Created by Cean on 2020/8/4.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNELSearchVC.h"
#import "CNElectrionHallCCell.h"
#define kCNElectrionHallCCellID  @"CNElectrionHallCCell"
#import "CNHomeRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "GameStartPlayViewController.h"

@interface CNELSearchVC () <UICollectionViewDataSource, UICollectionViewDelegate>
/// 搜索框
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UICollectionView *resultCV;
@property (nonatomic, strong)NSMutableArray<ElecGameModel *> *games;
@property (nonatomic, assign)NSInteger currentPage;
@end

@implementation CNELSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.currentPage = 1;
    [self configCollectionView];
}

// 搜索
- (IBAction)search:(UIButton *)sender {
    NSString *keyword = self.searchTF.text;
    if (keyword.length == 0) {
        [CNHUB showError:self.searchTF.placeholder];
        return;
    }
    
    [CNHomeRequest searchElecGameName:keyword pageNo:self.currentPage handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            QueryElecGameModel *model = [QueryElecGameModel cn_parse:responseObj];
            NSArray *games = model.data;
            if (self.currentPage == 1) {
                self.games = games.copy;
            } else {
                [self.games addObjectsFromArray:games];
            }
            if (model.totalPage == self.currentPage) {
                [self.resultCV.mj_footer endRefreshingWithNoMoreData];
                self.currentPage = 1;
            } else {
                [self.resultCV.mj_footer endRefreshing];
                self.currentPage ++;
            }
            [self.resultCV reloadData];
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
            [self.resultCV reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (void)configCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreenWidth - 15*3)/2;
    flowLayout.itemSize = CGSizeMake(itemW, itemW*150/165.0);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.resultCV.collectionViewLayout = flowLayout;
    [self.resultCV registerNib:[UINib nibWithNibName:@"CNElectrionHallCCell" bundle:nil] forCellWithReuseIdentifier:kCNElectrionHallCCellID];
    self.resultCV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(search:)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.games.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ElecGameModel *model = self.games[indexPath.row];
    CNElectrionHallCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNElectrionHallCCellID forIndexPath:indexPath];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    cell.collectionBlock = ^(UIButton * _Nonnull btn, ElecGameModel *model) {
        btn.selected = !btn.selected;
        model.isFavorite = btn.selected;
        [weakSelf updateFavoriteModel:model isSelect:btn.selected];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ElecGameModel *model = self.games[indexPath.row];
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

@end
