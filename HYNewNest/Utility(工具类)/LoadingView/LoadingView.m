//
//  LoadingView.m
//  INTEDSGame
//
//  Created by Robert on 13/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import "LoadingView.h"
#import <UIImage+GIF.h>

@interface LoadingView()
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *loadingImageView;
@property (nonatomic, strong) UIImageView *successImageView;

@end

@implementation LoadingView

+ (void)show {
    [self showLoadingViewWithToView:kKeywindow needMask:NO];
}

+ (void)showSuccess {
    LoadingView *loadingView;
    for (UIView *view in kKeywindow.subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            loadingView = (LoadingView *)view;
            break;
        }
    }
    if (!loadingView) {
        return;
    }
    [loadingView.loadingImageView stopAnimating];
    [UIView animateWithDuration:0.15 animations:^{
        loadingView.loadingImageView.alpha = 0;
        loadingView.successImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self hideLoadingViewForView:kKeywindow];
    }];
}

+ (void)hide {
    [self hideLoadingViewForView:kKeywindow];
}

+ (void)showLoadingViewWithToView:(nullable UIView *)toView needMask:(BOOL)needMask {
    if (!toView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        toView = window;
    }
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:toView.bounds needMask:needMask];
    [toView addSubview:loadingView];
    [toView bringSubviewToFront:loadingView];
    [loadingView showup];
}

+ (void)hideLoadingViewForView:(nullable UIView *)view {
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
- (id)initWithFrame:(CGRect)frame needMask:(BOOL)needMask{
    self = [super initWithFrame:frame];
    if (self) {
        if (needMask) {
            [self addSubview:self.maskView];
            [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self);
            }];
        }
        [self addSubview:self.contentView];
        [self addSubview:self.loadingImageView];
        [self addSubview:self.successImageView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(90);
        }];
        [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.width.mas_equalTo(90);
        }];
        [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(60);
        }];
    }
    return self;
}

- (void)showup {
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.alpha = 1.0;
        self.loadingImageView.alpha = 1.0;
        [self.loadingImageView startAnimating];
    }];
}

- (void)removeLoadingSubViews {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.loadingImageView.alpha = 0;
        self.successImageView.alpha = 0;
        [self.loadingImageView stopAnimating];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark GET SET
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = kHexColorAlpha(0x000000, 0.8);
        _maskView.userInteractionEnabled = YES;
        
    }
    return _maskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.layer.masksToBounds = YES;
        [_contentView addCornerAndShadow];
        _contentView.backgroundColor = kHexColor(0x343452);
        _contentView.alpha = 0.1;
    }
    return _contentView;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _loadingImageView.alpha = 0.1;

        // gif
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"A03loading" ofType:@"gif"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *image = [UIImage sd_animatedGIFWithData:data];
//        _loadingImageView.image = image;
        
        // 帧动画
        _loadingImageView.image = [UIImage imageNamed:@"loading_0"];
        _loadingImageView.contentMode = UIViewContentModeCenter;
        _loadingImageView.userInteractionEnabled = YES;
        NSMutableArray *imageArray = [[NSMutableArray array] init];
        for (NSInteger i = 0 ; i < 26; i ++ ) {
            NSString *imageName = [NSString stringWithFormat:@"loading_%ld",i];
            [imageArray addObject:[UIImage imageNamed:imageName]];
        }
        _loadingImageView.animationImages = imageArray;
    }
    return _loadingImageView;
}

- (UIImageView *)successImageView {
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _successImageView.alpha = 0;
        _successImageView.image = [UIImage imageNamed:@"l_loading OK"];
    }
    return _successImageView;
}

@end
