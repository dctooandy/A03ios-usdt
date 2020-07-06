//
//  LoadingView.m
//  INTEDSGame
//
//  Created by Robert on 13/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *rmbImageView;

@end

@implementation LoadingView

+ (void)showLoadingViewWithToView:(UIView *)toView {
    [self hideLoadingViewForView:toView];
    if (toView) {
        LoadingView *loadingView = [[LoadingView alloc] initWithFrame:toView.bounds];
        [toView addSubview:loadingView];
    }
    else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        LoadingView *loadingView = [[LoadingView alloc] initWithFrame:window.bounds];
        [window addSubview:loadingView];
    }
}

+ (void)hideLoadingViewForView:(UIView *)view {
    if (view) {
        for (UIView *subView in [view subviews] ) {
            if ([subView isKindOfClass:[LoadingView class]]) {
                LoadingView *loadingView = (LoadingView*)subView;
                [loadingView removeLoadingSubViews];
            }
        }
    }
    else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        for (UIView *subView in [window subviews] ) {
            if ([subView isKindOfClass:[LoadingView class]]) {
                LoadingView *loadingView = (LoadingView*)subView;
                [loadingView removeLoadingSubViews];
            }
        }
    }
}
#pragma mark 内部方法
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.contentView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        [self.contentView addSubview:self.rmbImageView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-88/2.0);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(88);
        }];
        [self.rmbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(48);
        }];
        [self startImageAnimation];
    }
    return self;
}

- (void)startImageAnimation {
    self.rmbImageView .animationDuration = 1.7;
    self.rmbImageView .animationRepeatCount = 0;
    [self.rmbImageView startAnimating];
}

- (void)removeLoadingSubViews {
    [self.rmbImageView stopAnimating];
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

#pragma mark GET SET
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
       // _maskView.backgroundColor = UIColorFromRGB(0x000000);
        _maskView.backgroundColor = [UIColor clearColor];
        //_maskView.alpha = 0.2;
    }
    return _maskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
//        _contentView.backgroundColor = COLOR_WITH_HEX(0xf5f5f5);
//        _contentView.backgroundColor = [UIColor colorMainThemeBackgroundColor];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UIImageView *)rmbImageView {
    if (!_rmbImageView) {
        _rmbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rmbImageView.image = [UIImage imageNamed:@"loading1"];
        _rmbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rmbImageView.userInteractionEnabled = YES;
        NSMutableArray *imageArray = [[NSMutableArray array] init];
        for (NSInteger i = 0 ; i < 50; i ++ ) {
            NSString *imageName = [NSString stringWithFormat:@"loading%ld",i+1];
            [imageArray addObject:[UIImage imageNamed:imageName]];
        }
        _rmbImageView.animationImages = imageArray;
    }
    return _rmbImageView;
}
@end
