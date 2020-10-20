//
//  LTSegmentedBar.m
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import "LTSegmentedBar.h"
#import "UIView+Badge.h"

#pragma mark - LTSegmentedBarConfig

@implementation LTSegmentedBarConfig

+ (instancetype)defaultConfig
{
    LTSegmentedBarConfig *config = [[LTSegmentedBarConfig alloc] init];
    
    config.segmentedBarBackgroundColor = [UIColor clearColor];
    config.itemNormalFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    config.itemSelectFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 1;
    config.indicatorExtraW = 10;
    
    return config;
}

@end

#pragma mark - LTSegmentedBar

#define kMinMargin 20

@interface LTSegmentedBar ()
{
    UIButton *_lastSelBtn;  // 上一次点击的按钮
}
/** SegmentedBar配置 */
@property (nonatomic, strong) LTSegmentedBarConfig *config;
/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
@property (nonatomic, strong) NSMutableArray <UIView *>*splitLines;
/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;
@end

#pragma mark SET UP

@implementation LTSegmentedBar

+ (LTSegmentedBar *)segmentedBarWithFrame:(CGRect)frame
{
    LTSegmentedBar *segBar = [[LTSegmentedBar alloc] initWithFrame:frame];
    return segBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.segmentedBarBackgroundColor;
    }
    return self;
}

- (void)updateWithConfig:(void (^)(LTSegmentedBarConfig *))configBlock
{
    if (configBlock) {
        configBlock(self.config);
    }
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemNormalFont;
    }
    [self setBackgroundColor:self.config.segmentedBarBackgroundColor];
    [self.indicatorView setBackgroundColor:self.config.indicatorColor];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    self.splitLines = nil;
    
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemNormalFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
        
        // UI要求的右侧分割线
        if (self.config.splitLineColor) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = self.config.splitLineColor;
//            line.frame = CGRectMake(0, 0, 1, 10);
            [self.contentView addSubview:line];
            [self.splitLines addObject:line];
        }
    }
    [self.splitLines removeLastObject];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (self.itemBtns.count == 0 || selectedIndex < 0 || selectedIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    UIButton *btn = self.itemBtns[selectedIndex];
    [self btnClick:btn];
}


#pragma mark ACTION & LAYOUT

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastSelBtn.tag];
    }

    _selectedIndex = btn.tag;
    _lastSelBtn.selected = NO;
    btn.selected = YES;
    for (UIButton *btn in self.itemBtns) {
        btn.titleLabel.font = self.config.itemNormalFont;
    }
    btn.titleLabel.font = self.config.itemSelectFont;
    if (!self.config.itemWidthFit){
        [btn sizeToFit];
    }
    btn.height = self.contentView.height;
    _lastSelBtn = btn;
    
    if (self.config.indicatorWidth) {
        self.indicatorView.width = self.config.indicatorWidth;
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorView.centerX = btn.centerX;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
            self.indicatorView.centerX = btn.centerX;
        }];
    }
    
    /// 超过宽度要滚过去
    CGFloat scrollX = btn.centerX - self.contentView.width * 0.5;
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.width) {
        scrollX = self.contentView.contentSize.width - self.contentView.width;
    }
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    if (self.itemBtns.count == 0) {
        return;
    }
    UIButton *btn = self.itemBtns[self.selectedIndex];
    
    if (self.config.itemWidthFit) {
         //手动去计算margin
        CGFloat lastX = 0;
        CGFloat btnW = self.contentView.width/self.items.count;
        for (int i=0; i<self.itemBtns.count; i++) {
            UIButton *btn = self.itemBtns[i];
            btn.x = lastX;
            btn.y = 0;
            btn.width = btnW;
            btn.height = self.contentView.height;
            lastX += btn.width;
            
            if (self.config.splitLineColor && self.splitLines.count>0 && i != self.itemBtns.count-1) {
                UIView *line = self.splitLines[i];
                line.x = btn.x + btnW;
                line.y = (self.contentView.height - 10) * 0.5;
                line.width = 1;
                line.height = 10;
            }
        }
        self.contentView.contentSize = CGSizeMake(lastX, 0);
        self.contentView.scrollEnabled = NO;
        // UI要求的图片badge
        if ([btn.titleLabel.text isEqualToString:@"OKEx"]) {
            [btn showRightTopImageName:@"promo" size:CGSizeMake(31, 16) offsetX:-43 offsetYMultiple:0.25];
        }
        
    } else {
        // 自动去计算margin
        CGFloat totalBtnWidth = 0;
        for (UIButton *btn in self.itemBtns) {
            [btn sizeToFit];
            totalBtnWidth += btn.width;
        }
        
        CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.items.count + 1);
        if (caculateMargin < kMinMargin) {
            caculateMargin = kMinMargin;
        }
        
        
        CGFloat lastX = caculateMargin;
        for (UIButton *btn in self.itemBtns) {
            // w, h
            btn.height = self.contentView.height;
            // y 0
            // x, y,
            btn.y = 0;
            btn.x = lastX;
            lastX += btn.width + caculateMargin;
        }
        
        self.contentView.contentSize = CGSizeMake(lastX, 0);
        self.contentView.scrollEnabled = YES;
    }
    
    if (self.config.indicatorWidth) {
        self.indicatorView.width = self.config.indicatorWidth;
    } else {
        self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
    }
    self.indicatorView.centerX = btn.centerX;
    self.indicatorView.height = self.config.indicatorHeight;
    self.indicatorView.y = self.height - self.indicatorView.height;
    

}


#pragma mark LAZY LOAD

- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (NSMutableArray<UIView *> *)splitLines {
    if (!_splitLines) {
        _splitLines = [NSMutableArray array];
    }
    return _splitLines;;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (LTSegmentedBarConfig *)config {
    if (!_config) {
        _config = [LTSegmentedBarConfig defaultConfig];
    }
    return _config;
}



@end
