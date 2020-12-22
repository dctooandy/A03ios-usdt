//
//  DSBHeaderSelectionView.m
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBHeaderSelectionView.h"

@interface DSBHeaderSelectionView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectionBtns;
@property (nonatomic, strong) NSArray <NSString *>* titles;// 所有标题
@property (nonatomic, strong) NSString *selTit; // 选中标题
@end

@implementation DSBHeaderSelectionView

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"大神榜",@"充值榜",@"提现榜",@"周总榜",@"月总榜"];
    }
    return _titles;
}

- (NSString *)fullTitle {
    if ([_selTit containsString:@"大神"]) {
        return @"大神盈利榜";
    } else if ([_selTit containsString:@"充值"]) {
        return @"充值土豪榜";
    } else if ([_selTit containsString:@"提现"]) {
        return @"提现锦鲤榜";
    } else if ([_selTit containsString:@"周总"]) {
        return @"周冠军总榜";
    } else {
        return @"月冠军总榜";
    }
}

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.backgroundColor = [UIColor clearColor];
    _selTit = self.titles[0];
}


- (IBAction)didTapSwitchRankBtn:(UIButton *)sender {
    _selTit = sender.titleLabel.text;
        
    double xMargin = sender.left - self.titleLbl.left;
    [UIView animateWithDuration:0.0013 * xMargin animations:^{
        
        self.titleLbl.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(xMargin*1.4, 0),
                                                         CGAffineTransformMakeScale(0.7, 0.7));
        sender.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-xMargin*0.6, 0),
                                                   CGAffineTransformMakeScale(1.6, 1.6));
        
    } completion:^(BOOL finished) {
        
        self.titleLbl.transform = CGAffineTransformIdentity;
        sender.transform = CGAffineTransformIdentity;
        
        self.titleLbl.text = [self fullTitle];
        NSMutableArray *tmps = [self.titles mutableCopy];
        [tmps removeObject:self.selTit];
        [tmps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = self.selectionBtns[idx];
            [btn setTitle:obj forState:UIControlStateNormal];
        }];
        
    }];
    
    if (self.didTapBtnBlock) {
        self.didTapBtnBlock(_selTit);
    }
    
}

@end
