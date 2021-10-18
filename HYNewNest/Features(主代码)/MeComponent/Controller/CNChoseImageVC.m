//
//  CNChoseImageVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNChoseImageVC.h"
#import "segmentHeaderView.h"
#import "CNChoseImageHeader.h"
#import "CNUserCenterRequest.h"
#define kCNChoseImageHeaderID  @"CNChoseImageHeader"
#import "CNChoseImageCCell.h"
#define kCNChoseImageCCellID  @"CNChoseImageCCell"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

#import "JJCollectionViewRoundFlowLayout.h"

@interface CNChoseImageVC () <segmentHeaderViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) segmentHeaderView *menuView;
@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, strong) ChooseAvatarsModel *avModel;
@property (nonatomic, strong) NSIndexPath *selcIdxPath;
@end

@implementation CNChoseImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"头像";
    self.topView.backgroundColor = self.collectionView.backgroundColor = self.view.backgroundColor;
    
    [self configCollectionView];
    [self addNaviRightItemWithTitle:@"提交"];
    
    // 数据
    NSString *imgUrl = [CNUserManager shareManager].userDetail.avatar;
    __block NSString *imgName = [imgUrl componentsSeparatedByString:@"/"].lastObject;

    [CNUserCenterRequest getAllAvatarsHanlder:^(id responseObj, NSString *errorMsg) {
        ChooseAvatarsModel *avModel = [ChooseAvatarsModel cn_parse:responseObj];
        [avModel formatGroups];
        self.avModel = avModel;
        
        //一开始选中的头像
        for (int i=0; i<avModel.groups.count; i++) {
            AvatarGroupModel *groupModel = avModel.groups[i];
            for (int j=0; j<groupModel.imgs.count; j++) {
                NSString *imgN = groupModel.imgs[j];
                if ([imgN isEqualToString:imgName]) {
                    self.selcIdxPath = [NSIndexPath indexPathForItem:j inSection:i];
                }
            }
        }
        
        self.titleList = self.avModel.groupTitles;
        [self initHeaderView];
        [self.collectionView reloadData];
    }];
}

// 提交
- (void)rightItemAction {
    AvatarGroupModel *groupModel = self.avModel.groups[self.selcIdxPath.section];
    NSString *imgNmae = groupModel.imgs[self.selcIdxPath.row];
    
    [CNUserCenterRequest modifyUserRealName:nil gender:nil birth:nil avatar:imgNmae onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [CNTOPHUB showSuccess:@"头像修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)initHeaderView {
    self.menuView = [[segmentHeaderView alloc] initWithFrame:self.topView.bounds titles:self.titleList];
    self.menuView.underLineColor = [UIColor whiteColor];
    self.menuView.isShowUnderLine = YES;
    self.menuView.delegate = self;
    [self.topView addSubview:self.menuView];
}

#pragma - mark segmentHeaderViewDelegate

- (void)hl_didSelectWithIndex:(NSInteger)index withIsClick:(BOOL)isClick {
    //isclick是为了区分当前操作是滑动还是点击
    if (isClick == YES) {
        NSLog(@"点击%@",self.titleList[index]);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
}

#pragma - mark CollectionView

- (void)configCollectionView {
    JJCollectionViewRoundFlowLayout *flowLayout = [[JJCollectionViewRoundFlowLayout alloc] init];
    flowLayout.isCalculateHeader = YES;
    CGFloat w = kScreenWidth/4.0;
    flowLayout.itemSize = CGSizeMake(w, 80);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:kCNChoseImageCCellID bundle:nil] forCellWithReuseIdentifier:kCNChoseImageCCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:kCNChoseImageHeaderID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCNChoseImageHeaderID];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.avModel.groups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AvatarGroupModel *groupModel = self.avModel.groups[section];
    return groupModel.imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNChoseImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNChoseImageCCellID forIndexPath:indexPath];
    AvatarGroupModel *groupModel = self.avModel.groups[indexPath.section];
    NSString *imgUrl = groupModel.imgs[indexPath.row];
//    NSString *fullURL = [self.avModel.baseUrl stringByAppendingString:imgUrl];
//    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:fullURL]];
    [cell.imageV sd_setImageWithURL:[NSURL getProfileIconWithString:imgUrl]];
    if ([self.selcIdxPath isEqual:indexPath]) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIdxPath = self.selcIdxPath;
    //oldInxPath 为空会崩溃
    if (oldIdxPath == nil) {
        oldIdxPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    self.selcIdxPath = indexPath;
    [collectionView reloadItemsAtIndexPaths:@[oldIdxPath, self.selcIdxPath]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    AvatarGroupModel *groupModel = self.avModel.groups[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CNChoseImageHeader *view = (CNChoseImageHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCNChoseImageHeaderID forIndexPath:indexPath];
        view.label.text = groupModel.groupName;
        reusableView = view;
    }
    return reusableView;
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 65);
}

#pragma mark - JJCollectionViewDelegateRoundFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout borderEdgeInsertsForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 0, 0, 0);
}

- (JJCollectionViewRoundConfigModel *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout configModelForSectionAtIndex:(NSInteger)section {
    JJCollectionViewRoundConfigModel *model = [[JJCollectionViewRoundConfigModel alloc] init];
    model.backgroundColor = kHexColor(0x212137);
    model.cornerRadius = 8;
    return model;
}

@end
