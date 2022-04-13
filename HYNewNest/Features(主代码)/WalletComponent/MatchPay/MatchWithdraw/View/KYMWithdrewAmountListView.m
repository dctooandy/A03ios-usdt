//
//  KYMWithdrewAmountListView.m
//  HYNewNest
//
//  Created by Key.L on 2022/2/26.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "KYMWithdrewAmountListView.h"
#import "KYMWithdrewAmountListCell.h"
@interface KYMWithdrewAmountListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@implementation KYMWithdrewAmountListView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"KYMWithdrewAmountListCell" bundle:nil] forCellWithReuseIdentifier:@"KYMWithdrewAmountListCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.amountArray && self.amountArray.count > 0) {
        return self.amountArray.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.amountArray && self.amountArray.count > indexPath.row) {
        KYMWithdrewAmountModel *model = self.amountArray[indexPath.row];
        KYMWithdrewAmountListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYMWithdrewAmountListCell" forIndexPath:indexPath];
        cell.amount = model.amount;
        if (model.isRecommend) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
        }

        return  cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.frame) - 15) / 3.0 ;
    return CGSizeMake(width, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7.5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(8, 0, 8, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate matchWithdrewAmountCellDidSelected:self indexPath:indexPath];
}
- (NSIndexPath *)selectedIndexPath
{
    if (self.collectionView.indexPathsForSelectedItems.count > 0) {
        return self.collectionView.indexPathsForSelectedItems.firstObject;
    }
    return nil;
}
- (void)setCurrentAmount:(NSString *)amount
{
    if (self.selectedIndexPath) {
        [self.collectionView deselectItemAtIndexPath:self.selectedIndexPath animated:NO];
    }
    [self.collectionView reloadData];
    for (int i = 0; i < self.amountArray.count; i++) {
        NSString *a = self.amountArray[i].amount;
        if ([a isEqualToString:amount]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            return;
        }
    }
}
@end
