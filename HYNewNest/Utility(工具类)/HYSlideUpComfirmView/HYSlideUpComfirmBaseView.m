//
//  HYSlideUpComfirmBaseView.m
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYSlideUpComfirmBaseView.h"


@interface HYSlideUpComfirmBaseView()
{
    CGFloat _contentViewHeight;
}
@end

@implementation HYSlideUpComfirmBaseView

#pragma mark - LAZY

- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgView.backgroundColor = kHexColorAlpha(0x000000, 0.3);
        bgView.alpha = 0.1;
        [self addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.superview.height, kScreenWidth, 400)];
        mainView.backgroundColor = kHexColor(0x343452);
        mainView.alpha = 0.1;
        [self addSubview:mainView];
        _contentView = mainView;
    }
    return _contentView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        UILabel *lblTit = [[UILabel alloc] init];
        lblTit.frame = CGRectMake(0, 0, kScreenWidth, AD(50));
        lblTit.text = @"默认标题";
        lblTit.textAlignment = NSTextAlignmentCenter;
        lblTit.font = [UIFont fontPFM16];
        lblTit.textColor = [UIColor whiteColor];
        [lblTit addLineDirection:LineDirectionBottom color:kHexColorAlpha(0xFFFFFF, 0.3) width:0.5];
        _titleLbl = lblTit;
    }
    return _titleLbl;;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancle setImage:[UIImage imageNamed:@"tips-close"] forState:UIControlStateNormal];
        btnCancle.frame = CGRectMake(kScreenWidth-AD(30)-25, AD(12), AD(30), AD(30));
        [btnCancle addTarget:self action:@selector(touchupCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = btnCancle;
    }
    return _cancelBtn;;
}

- (CNTwoStatusBtn *)comfirmBtn {
    if (!_comfirmBtn) {
        CNTwoStatusBtn *comBtn = [[CNTwoStatusBtn alloc] init];
        comBtn.enabled = NO;
        [comBtn setTitle:@"确认按钮" forState:UIControlStateNormal];
        comBtn.frame = CGRectMake(AD(28), self.contentView.height - 30 - kSafeAreaHeight, self.contentView.width - AD(28)*2, 48);
        [comBtn addTarget:self action:@selector(touchupComfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _comfirmBtn = comBtn;
    }
    return _comfirmBtn;
}


#pragma mark - MAIN
- (instancetype)initWithContentViewHeight:(CGFloat)height
                                    title:(NSString *)title
                           comfirmBtnText:(NSString *)btnTitle {
    self = [super init];
    
    _contentViewHeight = height;
    self.titleLbl.text = title;
    [self.comfirmBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    [self commonViewSetup];
    return self;
}

- (void)commonViewSetup {
    [[NNControllerHelper currentRootVcOfNavController].view addSubview:self]; //添加到当前控制器视图上
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.comfirmBtn];
    
    // layoutSubviews布局contentView -> 动画展示
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0, self.superview.height, kScreenWidth, _contentViewHeight + kSafeAreaHeight);
    [self.contentView jk_setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:20];
    self.comfirmBtn.frame = CGRectMake(AD(28), self.contentView.height - 48 - 30 - kSafeAreaHeight, self.contentView.width - AD(28)*2, 48);
}


#pragma mark - ACTION

/// 点击确认/提交
- (void)touchupComfirmBtn {
    if (self.submitHandler) {
        self.submitHandler(YES);
    } else if (self.submitArgsHandler) {
        self.submitArgsHandler(YES, @0, nil);
    }
    [self dismiss];
}

/// 直接关闭
- (void)touchupCloseBtn {
    if (self.submitHandler) {
        self.submitHandler(NO);
    } else if (self.submitArgsHandler) {
        self.submitArgsHandler(NO, @0, nil);
    }
    [self dismiss];
}

- (void)show {
    // 滑出
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bgView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        self.contentView.y = self.superview.height - self.contentView.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    // 滑入
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bgView.alpha = 0.1;
        self.contentView.alpha = 0.1;
        self.contentView.y = self.superview.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
