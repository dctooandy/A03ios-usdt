//
//  VIPMonthlyAlertsVC.m
//  HYNewNest
//
//  Created by zaky on 9/3/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPMonthlyAlertsVC.h"
#import "SlideCard.h"
#import "VIPMonlyAlertCell.h"
#import "CNVIPRequest.h"

@interface VIPMonthlyAlertsVC () <V_SlideCardDataSource, V_SlideCardDelegate, VIPMonlyAlertDelegate>
@property (nonatomic, strong) V_SlideCard *slideCard;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) VIPMonthlyModel *model;
@end

@implementation VIPMonthlyAlertsVC


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHexColorAlpha(0x000000, 0.8);
    
    // 月报
    [CNVIPRequest vipsxhMonthReportHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.model = [VIPMonthlyModel cn_parse:responseObj];
            if (self.model) {
                [self.view addSubview:self.slideCard];//加入滑动组件
                [self.slideCard reloadData];
            }
        } else {
            // 失败复原记录
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:HYVipMonthReportLastimeDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self removeSelfFromFatherVC];
        }
    }];
}

/// 从父VC移除
- (void)removeSelfFromFatherVC {
    //准备移除
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    //确定移除 该方法会显示调用didMoveToParentViewController:nil
    [self removeFromParentViewController];
}


#pragma mark - VIPMonlyAlertDelegate
- (void)didTapNextOne {
    [self.slideCard animateTopCardToDirection:PanDirectionRight]; //关闭
}

- (void)didTapReceiveGift {
    // 领取礼金
    [CNVIPRequest vipsxhDrawGiftMoneyLevelStatus:self.model.clubLevel
                                         handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [CNHUB showSuccess:@"领取成功"];
            [self.slideCard animateTopCardToDirection:PanDirectionLeft];
        }
    }];
    
}

- (void)didTapMonthlyReport {
    [self.slideCard animateTopCardToDirection:PanDirectionLeft];
}


#pragma mark - V_SlideCardDataSource
- (void)loadNewDataInSlideCard:(V_SlideCard *)slideCard {
    [self removeSelfFromFatherVC];
}

- (void)slideCard:(V_SlideCard *)slideCard loadNewDataInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
    // 这里赋值
    VIPMonlyAlertCell *aCell = (VIPMonlyAlertCell *)cell;
    [aCell setupAlertType:index delegate:self dataDict:self.model];
}

- (NSInteger)numberOfItemsInSlideCard:(V_SlideCard *)slideCard {
    return self.listData.count;
}

// 代理方法
//#pragma mark - V_SlideCardDelegate
//
//- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didPanPercent:(CGFloat)percent withDirection:(PanDirection)direction atIndex:(NSInteger)index {
//
//}
//
//- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell willScrollToDirection:(PanDirection)direction atIndex:(NSInteger)index {
//
//}
//
//- (void)slideCard:(V_SlideCard *)slideCard topCell:(V_SlideCardCell *)cell didChangedStateWithDirection:(PanDirection)direction atIndex:(NSInteger)index {
//
//}
//
//- (void)slideCard:(V_SlideCard *)slideCard didResetFrameInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
//
//}
//
//- (void)slideCard:(V_SlideCard *)slideCard didSelectCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
//
//}


#pragma mark - getter

- (V_SlideCard *)slideCard {
    if (_slideCard == nil) {
        _slideCard = [[V_SlideCard alloc] initWithFrame:self.view.bounds];
        _slideCard.cellScaleSpace = 0.11; // 缩放大小
        _slideCard.cellCenterYOffset = - 50; //Y轴偏移

        _slideCard.cellSize = CGSizeMake(AD(316), AD(317));
        _slideCard.cellOffsetDirection = CellOffsetDirectionTop; // 缩小的view方向向上
        
        [_slideCard registerCellClassName:@"VIPMonlyAlertCell"];
        _slideCard.dataSource = self;
//        _slideCard.delegate = self;
    }
    return _slideCard;
}

- (NSArray *)listData {
    if (_listData == nil) {
        _listData = @[@"个人战报",@"入会情况",@"送出价值"];
    }
    return _listData;
}



@end
