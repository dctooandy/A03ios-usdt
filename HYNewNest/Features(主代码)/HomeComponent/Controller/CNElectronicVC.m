//
//  CNElectronicVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/22.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNElectronicVC.h"
#import "CNElResentPlayCCell.h"
#import <UIImageView+WebCache.h>
#import "CNElectrionHallVC.h"

#import "CNHomeRequest.h"

#define kCNElResentPlayCCell  @"CNElResentPlayCCell"

@interface CNElectronicVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *recentPlayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recentPlayViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSArray<ElecLogGameModel *> *dataSource;
@end

@implementation CNElectronicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    
    [self reloadCollectionViewData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 已登录 获取最近玩过的游戏
    if ([CNUserManager shareManager].isLogin) {
        [self queryRecentGames];
    }
}

- (void)queryRecentGames {
    WEAKSELF_DEFINE
    [CNHomeRequest queryElecGamePlayLogHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (errorMsg) {
            return;
        }
        NSMutableArray *logElecArr = @[].mutableCopy;
        NSArray<ElecLogGameModel *> *logArr = [ElecLogGameModel cn_parse:responseObj];
        for (ElecLogGameModel *model in logArr) {
            
            if ([model.gameParam.gameType isEqualToString:@"1"]) { //筛选出电游类型
                [logElecArr addObject:model];
            }
        }
        strongSelf.dataSource = logElecArr;
        [strongSelf reloadCollectionViewData];
    }];
}

- (IBAction)entryAGBuYu:(id)sender {
    [NNPageRouter jump2GameName:@"捕鱼王" gameType:@"6" gameId:@"" gameCode:@"A03026"];
}

//进入电游大厅
- (IBAction)entranceElectHall:(id)sender {
    [self.navigationController pushViewController:[CNElectrionHallVC new] animated:YES];
}


- (CGFloat)totalHeight {
    // AG|16|捕鱼|16|猴子|16|按钮|32|最近常玩
    CGFloat AGHeight = (kScreenWidth - 15*2) * 115/345.0;
//    CGFloat monkeyH = (kScreenWidth - 15*3)/2.0 * 142/165.0;
//    return (AGHeight+16)*2 + (monkeyH+16) + (48+32) + self.recentPlayViewHeight.constant;
    return AGHeight + (30+48+32) + self.recentPlayViewHeight.constant;
}

- (void)configCollectionView {
    // cell的高度
    CGFloat itemW = (kScreenWidth - 15*3)/2.0;
    self.cellHeight = itemW*142/165.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.itemSize = CGSizeMake(itemW, self.cellHeight);
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:kCNElResentPlayCCell bundle:nil] forCellWithReuseIdentifier:kCNElResentPlayCCell];
}

/// CollectionView 刷新调用这个
- (void)reloadCollectionViewData {
    // 根据collectionView 数据计算collectionView 高度
    if (self.dataSource.count == 0) {
        // 没有数据不显示
        self.recentPlayView.hidden = YES;
        self.recentPlayViewHeight.constant = 0;
    } else {
        // 计算行数
        CGFloat row = ceilf(self.dataSource.count/2.0);
        // cell 头部 40，间隔 15
        self.recentPlayViewHeight.constant = (row*self.cellHeight) + (row-1)*15 + 40;
        self.recentPlayView.hidden = NO;
    }
    [self.collectionView reloadData];
}

#pragma - mark UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ElecLogGameModel *model = self.dataSource[indexPath.row];
    
    CNElResentPlayCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNElResentPlayCCell forIndexPath:indexPath];
    cell.titleLb.text = model.gameName;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.gameImg] placeholderImage:[UIImage imageNamed:@"gamepic-1"]];
    cell.typeLb.text = model.platformDisplayName;
//    cell.playCountLb.text = [NSString stringWithFormat:@"%@人正在游戏", model.gameParam.playLine];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ElecLogGameModel *model = self.dataSource[indexPath.row];
    
    [NNPageRouter jump2GameName:model.gameName
                       gameType:model.gameParam.gameType
                         gameId:model.gameParam.gameId
                       gameCode:model.gameParam.gameCode];
}

@end
