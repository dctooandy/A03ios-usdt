//
//  HYRefreshHeader.m
//  HyEntireGame
//
//  Created by bux on 2018/11/6.
//  Copyright © 2018 kunlun. All rights reserved.
//

#import "HYRefreshHeader.h"
//#import "UILabel+Extension.h"

@interface HYRefreshHeader()

@property (strong,nonatomic) UILabel *loadingLabel;

@end

@implementation HYRefreshHeader

- (void)prepare{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i=0; i<50; i++) {
        
        NSString *name = [NSString stringWithFormat:@"loading%lu", (unsigned long)i+1];
        UIImage *image = [UIImage imageNamed:name];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%lu", (unsigned long)i]];

        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
    
//    UILabel *loadingLabel = [UILabel labelWithTitleColor:COLOR_WITH_HEX(0x999999) font:[UIFont fontPFM12]];
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.font = [UIFont fontPFM12];
    loadingLabel.textColor = [UIColor jk_colorWithHex:0x999999];
    loadingLabel.text = @"刷新中...";
    [self addSubview:loadingLabel];
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(0);
    }];
    self.loadingLabel = loadingLabel;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    self.gifView.frame = CGRectMake(0, 30, self.bounds.size.width, 40);
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)endRefreshing{
    

    //所有下拉刷新结束动画 统一延迟 1.7秒结束
    dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^{
        [super endRefreshing];
    });
    
}

@end
