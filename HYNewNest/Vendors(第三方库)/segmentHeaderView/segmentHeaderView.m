//
//  segmentHeaderView.m
//  segmentHeaderView
//
//  Created by xujinjieMac on 2019/12/6.
//  Copyright © 2019 JennyMac. All rights reserved.
//

#import "segmentHeaderView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+HHLayout.h"

@interface segmentHeaderView()

/**标题宽度*/
@property (nonatomic, assign) CGFloat titleWidth;
/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;
/** 所有标题数组 */
@property (nonatomic, strong) NSMutableArray * titleLabels;
/** 所有标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;
/**标题滚动视图*/
@property (nonatomic, strong)UIScrollView * titleScrollView;
/**下滑线*/
@property (nonatomic, weak)UIView * underLine;
/**下滑线高度 */
@property (nonatomic, assign) CGFloat underLineH;
/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;
/** 是否是点击本视图的按钮 */
@property (nonatomic, assign) BOOL isClick;

@end

// 下划线默认高度
static CGFloat const HLUnderLineH = 2;

@implementation segmentHeaderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titles = titles;
        self.frame = frame;
        _selectIndex = 0;
       
    }
    return self;
}

- (void)calculatorWidths{
    
    // 判断是否能占据整个屏幕
    
    [self.titleWidths removeAllObjects];
    
    CGFloat totalWidth = 0;
    UIFont *font = [UIFont systemFontOfSize:13];
    
    // 计算所有标题的宽度
    for (NSString *title in self.titles) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

        CGFloat width = size.width + 15;
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    CGFloat titleMargin;
    if (self.isShowUnderLine){
      titleMargin = (self.frame.size.width - totalWidth - 22) / (self.titles.count - 1);
        
    }else{
      titleMargin = (self.frame.size.width - totalWidth) / (self.titles.count + 1);
        
    }
    
    _titleMargin = titleMargin < 15? 15: titleMargin;
    
    self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
    
}

- (void)setUpSegmentView{
    
    // 添加所有的标题
    CGFloat labelW = _titleWidth;
    CGFloat labelH = 27;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titles.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.text = self.titles[i];
        label.tag = i;
        
        // 设置按钮的文字颜色
        label.textColor = kHexColorAlpha(0x6D778B, 0.5);
        labelW = [self.titleWidths[i] floatValue];
        label.textAlignment = NSTextAlignmentCenter;
        // 设置按钮位置
        UILabel * lastLabel = [self.titleLabels lastObject];
        
        if (self.isShowUnderLine && i == 0){
            labelX = 11;
        }else{
            labelX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        }

        label.font = [UIFont systemFontOfSize:13];

        if (self.isShowUnderLine){
            label.width = labelW;
        }else{
            label.width = labelW+18;

        }

        label.frame = CGRectMake(labelX, labelY, label.width, labelH);
        label.centerY = self.height/2;
        
        
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        if (i == _selectIndex) {
            [self titleClick:tap];
        }
        // 保存到数组
        [self.titleLabels addObject:label];
        
        [self.titleScrollView addSubview:label];
        
    }
    
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.titleLabels.lastObject;
    self.titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    
}

- (void)titleClick:(UITapGestureRecognizer *)tap{
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 获取当前角标
    NSInteger i = label.tag;
    //    NSLog(@"获取当前角标%ld",i);
    // 选中label
    [self selectLabel:label];
    
    if ([self.delegate respondsToSelector:@selector(hl_didSelectWithIndex:withIsClick:)]) {
        [self.delegate hl_didSelectWithIndex:i withIsClick:YES];
    }
    
}


//  选中标题
- (void)selectLabel:(UILabel *)label
{
    for (UILabel *labelView in self.titleLabels) {

        if (label == labelView) continue;
        labelView.transform = CGAffineTransformIdentity;
        labelView.textColor = kHexColorAlpha(0x6D778B, 0.5);
//        labelView.backgroundColor = [UIColor clearColor];
        labelView.font = [UIFont systemFontOfSize:13];
    }
   
    if (self.isShowUnderLine){
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//        label.backgroundColor = [UIColor clearColor];
    }else{
        // 修改标题选中颜色
        label.layer.cornerRadius = 13.5;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor whiteColor];
    }

    // 设置标题居中
    [self setLabelTitleCenter:label];

    // 设置下标的位置
    if (self.isShowUnderLine) {
        [self setUpUnderLine:label];
    }

}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - self.frame.size.width * 0.5;

    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - self.frame.size.width + _titleMargin;

    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    if (label.right<self.frame.size.width){
        
        [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }else{
        // 滚动区域
           [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
   
    
}


// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    
    // 获取文字尺寸
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
//    CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//
//    CGFloat width = size.width;
    CGFloat width = 20;
    CGFloat underLineH = _underLineH?_underLineH:HLUnderLineH;
    
    self.underLine.y = self.height - underLineH;
    self.underLine.height = underLineH;
    
    
    // 最开始不需要动画
    if (self.underLine.x == 0) {
        
        self.underLine.width = width;
        self.underLine.centerX = label.centerX;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.underLine.width = width;
        self.underLine.centerX = label.centerX;
    }];
    
}


// 设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel{
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / self.frame.size.width;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / self.frame.size.width;
    
    self.underLine.width += underLineWidth;
    self.underLine.x += underLineTransformX;
    
}

// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:rightLabel.font} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:leftLabel.font} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}



#pragma mark -  set方法

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine
{
    _isShowUnderLine = isShowUnderLine;
    self.underLine.hidden = !isShowUnderLine;
    // 计算标题宽度
    [self calculatorWidths];
    [self setUpSegmentView];
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
    if (selectIndex<0) return;

    if (self.titleLabels.count) {
        UILabel *label = self.titleLabels[selectIndex];
        
        if (_selectIndex >= self.titleLabels.count) {
            @throw [NSException exceptionWithName:@"HL_ERROR" reason:@"选中控制器的角标越界" userInfo:nil];
        }
        
        //        [self titleClick:[label.gestureRecognizers firstObject]];
        UITapGestureRecognizer *tap = [label.gestureRecognizers firstObject];
        // 获取对应标题label
        UILabel *labelTwo = (UILabel *)tap.view;
        // 获取当前角标
        NSInteger i = labelTwo.tag;
        // 选中label
        [self selectLabel:labelTwo];
        if ([self.delegate respondsToSelector:@selector(hl_didSelectWithIndex:withIsClick:)]) {
            [self.delegate hl_didSelectWithIndex:i withIsClick:NO];
        }
    }
    
}

- (void)setUnderLineColor:(UIColor *)underLineColor{
    _underLineColor = underLineColor;
}


#pragma mark -  懒加载

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.backgroundColor = kHexColor(0x0D0D16);
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        self.titleScrollView.frame = self.bounds;
        [self addSubview:self.titleScrollView];
    }
    return _titleScrollView;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (UIView *)underLine
{
    if (_underLine == nil) {
        
        UIView *underLineView = [[UIView alloc] init];
        
        underLineView.backgroundColor = _underLineColor?_underLineColor:[UIColor clearColor];
        [self.titleScrollView addSubview:underLineView];
        _underLine = underLineView;
        
    }
    return _underLine;
}

@end
