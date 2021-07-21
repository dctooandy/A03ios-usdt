//
//  BYGloryVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/15.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryVC.h"
#import "BYGloryRequest.h"
#import "BYGloryHeaderTableViewCell.h"
#import "BYGloryTimelineTableViewCell.h"
#import "BYGloryModel.h"
#import <MJRefresh.h>

@interface BYGloryVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *gloryTableView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray<BYGloryModel *> *gloryModels;
@end

@implementation BYGloryVC

static NSString *const kBYGloryHeaderCell = @"BYGloryHeaderCell";
static NSString *const kBYGloryTimelineCell = @"BYGloryTimelineCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.gloryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYGloryHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:kBYGloryHeaderCell];
    [self.gloryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYGloryTimelineTableViewCell class]) bundle:nil] forCellReuseIdentifier:kBYGloryTimelineCell];
    self.gloryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTable)];
    [self refreshTable];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark Custom Method
- (CGFloat)triggerFadeinY {
    BYGloryTimelineTableViewCell *firstCell = [self.gloryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    return CGRectGetMinY(firstCell.frame) - CGRectGetHeight(firstCell.frame);
}

- (void)refreshTable {
    WEAKSELF_DEFINE
    [BYGloryRequest getAgDynamic:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        [strongSelf.gloryTableView.mj_header endRefreshing];
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *models = responseObj[@"objs"];
            strongSelf.gloryModels = [[NSMutableArray alloc] init];
            for (BYGloryModel *model in models) {
                [strongSelf.gloryModels addObject:[BYGloryModel cn_parse:model]];
            }
            
            [weakSelf.gloryTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffSetY = scrollView.contentOffset.y;
    NSArray *indexPaths = [self.gloryTableView indexPathsForVisibleRows];

    if (indexPaths.count == 1) {
        return;
    }
        
    /*
     渐变效果设定(取得 Cell Height后 计算Alpha)
     CGFloat cellHeight = CGRectGetHeight(cell.frame);
     CGFloat alphaValue = (CGFloat)((int)contentOffSetY % (int)cellHeight);
     [cell setMaskAlpha:alphaValue / cellHeight];
     */
    
    //滑动方向
    if (self.lastContentOffset >= scrollView.contentOffset.y) {
        if ([indexPaths.firstObject section] == 0 && indexPaths.count >= 3) {
            BYGloryTimelineTableViewCell *cell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[1]];
            [cell setMaskAlpha:0];

            cell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[2]];
            [cell setToDefault];

        }
        else if ([indexPaths.firstObject section] == 1 && contentOffSetY + kScreenHeight * 0.95 < scrollView.contentSize.height) {
            for (NSIndexPath *indexPath in indexPaths) {
                BYGloryTimelineTableViewCell *cell = [self.gloryTableView cellForRowAtIndexPath:indexPath];
                if (indexPath == indexPaths[1]) {
                    [cell setMaskAlpha:0];
                }
                else {
                    [cell setToDefault];
                }
            }
        }
    }
    else {
            if ([indexPaths.firstObject section] == 0) {
                BYGloryTimelineTableViewCell *cell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[1]];
                [cell setMaskAlpha:0];
            }
            else if (contentOffSetY  + kScreenHeight * 0.8 >= scrollView.contentSize.height && indexPaths.count >= 3){
                BYGloryTimelineTableViewCell *fadeoutCell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[1]];
                [fadeoutCell setToDefault];

                BYGloryTimelineTableViewCell *fadeinCell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[2]];
                [fadeinCell setMaskAlpha:0];
            }
            else {
                BYGloryTimelineTableViewCell *fadeoutCell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[0]];
                [fadeoutCell setToDefault];

                BYGloryTimelineTableViewCell *fadeinCell = [self.gloryTableView cellForRowAtIndexPath:indexPaths[1]];
                [fadeinCell setMaskAlpha:0];
            }
    }
    self.lastContentOffset = contentOffSetY;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ){
        return 1;
    }
    
    return self.gloryModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BYGloryHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBYGloryHeaderCell];
        return cell;
    }
    else {
        BYGloryTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBYGloryTimelineCell];
        [cell setupCell:self.gloryModels[indexPath.row]];
        
        if (indexPath.row == [tableView numberOfRowsInSection:1] - 1 ) {
            [cell hideDottedline:true];
        }
        
        return cell;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"BYGloryTimelineHeader" owner:self options:nil] objectAtIndex:0];
        view.frame = CGRectMake(0, 0, kScreenWidth, 72);
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 72;
    }
    return 0;
}


@end
