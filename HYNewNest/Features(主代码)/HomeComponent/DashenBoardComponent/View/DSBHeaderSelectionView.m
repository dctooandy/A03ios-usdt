//
//  DSBHeaderSelectionView.m
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBHeaderSelectionView.h"
#import "CNTextSaleBtn.h"

@interface DSBHeaderSelectionView ()
@property (strong, nonatomic) IBOutletCollection(CNTextSaleBtn) NSArray *selectionBtns;
@property (nonatomic, strong) NSArray <NSString *>* titles;// 所有标题
@property (assign,nonatomic) NSInteger selIdx;
@property (nonatomic, strong) NSString *selTit; // 选中标题

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *leadingCons;

@end

@implementation DSBHeaderSelectionView

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"盈利榜",@"充值榜",@"提现榜",@"周总榜",@"月总榜"];
    }
    return _titles;
}

- (NSString *)fullTitle {
    if ([_selTit containsString:@"盈利"]) {
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
    
    if (kScreenWidth < 375) {
        for (NSLayoutConstraint *leading in _leadingCons) {
            leading.constant = 15;
        }
        for (CNTextSaleBtn *btn in _selectionBtns) {
            btn.selFont = [UIFont fontPFSB16];
            btn.norFont = [UIFont fontPFR12];
            btn.selColor = [UIColor whiteColor];
            btn.norColor = [UIColor whiteColor];
        }
    } else {
        for (CNTextSaleBtn *btn in _selectionBtns) {
            btn.selFont = [UIFont fontPFSB18];
            btn.norFont = [UIFont fontPFR14];
            btn.selColor = [UIColor whiteColor];
            btn.norColor = [UIColor whiteColor];
        }
    }
    
    _selIdx = 0;
    _selTit = self.titles[0];
    CNTextSaleBtn *firBtn = _selectionBtns[0];
    firBtn.selected = YES;
}


- (IBAction)didTapSwitchRankBtn:(CNTextSaleBtn *)sender {
    // 旧状态
    [_selectionBtns enumerateObjectsUsingBlock:^(CNTextSaleBtn   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        if (idx == _selIdx) {
            [obj setTitle:self.titles[idx] forState:UIControlStateNormal];
        }
    }];
    
    // 新状态
    _selIdx = sender.tag;
    _selTit = sender.titleLabel.text;
    sender.selected = YES;
    [sender setTitle:[self fullTitle] forState:UIControlStateNormal];
    
//    double xMargin = sender.left - self.titleLbl.left;
//    [UIView animateWithDuration:0.0013 * xMargin animations:^{
//
//        self.titleLbl.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(xMargin*1.4, 0),
//                                                         CGAffineTransformMakeScale(0.7, 0.7));
//        sender.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-xMargin*0.6, 0),
//                                                   CGAffineTransformMakeScale(1.6, 1.6));
//
//    } completion:^(BOOL finished) {
//
//        self.titleLbl.transform = CGAffineTransformIdentity;
//        sender.transform = CGAffineTransformIdentity;
//
//        self.titleLbl.text = [self fullTitle];
//        NSMutableArray *tmps = [self.titles mutableCopy];
//        [tmps removeObject:self.selTit];
//        [tmps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            UIButton *btn = self.selectionBtns[idx];
//            [btn setTitle:obj forState:UIControlStateNormal];
//        }];
//
//    }];
    
    if (self.didTapBtnBlock) {
        self.didTapBtnBlock(_selTit);
    }
    
}

@end
