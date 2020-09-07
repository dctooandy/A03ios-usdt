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

@interface VIPMonthlyAlertsVC () <V_SlideCardDataSource, V_SlideCardDelegate, VIPMonlyAlertDelegate>
@property (nonatomic, strong) V_SlideCard *slideCard;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation VIPMonthlyAlertsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kHexColorAlpha(0x000000, 0.8);
    
    [self.view addSubview:self.slideCard];//加入滑动组件
    [self.slideCard reloadData];
}

#pragma mark - event response

- (void)buttonClickAction:(UIButton *)sender {
     // 按钮点击缩放效果
     CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     pulse.duration = 0.08;
     pulse.repeatCount= 1;
     pulse.autoreverses= YES;
     pulse.fromValue= [NSNumber numberWithFloat:0.9];
     pulse.toValue= [NSNumber numberWithFloat:1.1];
     [sender.layer addAnimation:pulse forKey:nil];
     
    if (sender.tag == 520) {
        [self.slideCard animateTopCardToDirection:PanDirectionRight];
    } else {
        [self.slideCard animateTopCardToDirection:PanDirectionLeft];
    }
}


#pragma mark - VIPMonlyAlertDelegate
- (void)didTapNextOne {
    [self.slideCard animateTopCardToDirection:PanDirectionRight];
}

- (void)didTapReceiveGift {
    //TODO: 领取之后跳过
    [self.slideCard animateTopCardToDirection:PanDirectionRight];
}

- (void)didTapMonthlyReport {
    //TODO: 弹出月报
}

#pragma mark - V_SlideCardDataSource
- (void)loadNewDataInSlideCard:(V_SlideCard *)slideCard {
    //准备移除
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    //确定移除 该方法会显示调用didMoveToParentViewController:nil
    [self removeFromParentViewController];
}

- (void)slideCard:(V_SlideCard *)slideCard loadNewDataInCell:(V_SlideCardCell *)cell atIndex:(NSInteger)index {
    //TODO: 这里赋值
    VIPMonlyAlertCell *aCell = (VIPMonlyAlertCell *)cell;
    [aCell setupAlertType:index delegate:self dataDict:@{}];
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
        _listData = @[@1,@2,@3];
    }
    return _listData;
}



@end
