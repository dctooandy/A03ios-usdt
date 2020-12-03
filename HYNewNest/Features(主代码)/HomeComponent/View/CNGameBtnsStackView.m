//
//  CNGameBtnsStackView.m
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNGameBtnsStackView.h"

@interface CNGameBtnsStackView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *switchBtnArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gameTypeLbArr;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *gameImageVArr;
@end

@implementation CNGameBtnsStackView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self configUI];
    
    [self selectGif:0]; //默认第一个
}

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 切换按钮边框颜色
    for (int i = 0; i < self.gameTypeLbArr.count; i++) {
        UIButton *btn = self.switchBtnArr[i];
        UILabel *lb = self.gameTypeLbArr[i];
        btn.layer.borderColor = lb.textColor.CGColor;
    }
    
    // 加载动图和图片
    [self loadGif];
}

- (void)loadGif {
    // 动图名称
    NSArray *imageNames = @[@"合成 1_000", @"数字7_000", @"足球_000", @"彩票_000", @"棋牌_000"];

    // 按钮高亮动图
    for (int i = 0; i < self.gameImageVArr.count; i++) {
        UIImageView *iv = self.gameImageVArr[i];
        UIImage *gifImage = [UIImage animatedImageNamed:imageNames[i] duration:3];
        iv.highlightedImage = gifImage;
        iv.image = [UIImage imageNamed:imageNames[i]];
        iv.highlighted = NO;
    }
}


#pragma mark - 按钮切换

// 选择加载gif图
- (void)selectGif:(NSInteger)index {
    if (index >= self.gameImageVArr.count) {
        return;
    }
    // 按钮高亮动图
    for (int i = 0; i < self.gameImageVArr.count; i++) {
        UIImageView *iv = self.gameImageVArr[i];
        iv.highlighted = (i == index);
    }
}


#pragma mark - 游戏切换业务

- (IBAction)switchGame:(UIButton *)sender {
    // 过滤重复点击
    if (sender.selected) {
        return;
    }
    // 还原UI
    for (UIButton *btn in self.switchBtnArr) {
        btn.selected = NO;
        btn.layer.borderWidth = 0;
    }
    sender.selected = YES;
    sender.layer.borderWidth = 1;
    [self selectGif:sender.tag];

    // 点击按钮下标
    NSInteger index = [self.switchBtnArr indexOfObject:sender];
    if (self.delegate) {
        [self.delegate didTapGameBtnsIndex:index];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
