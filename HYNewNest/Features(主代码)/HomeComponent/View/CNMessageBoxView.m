//
//  CNMessageBoxView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/5.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMessageBoxView.h"
#import <UIImageView+WebCache.h>

#import "VIPNewVersionView.h"
#import "CNVIPRequest.h"

@interface CNMessageBoxView () <UIScrollViewDelegate>
{
    NSInteger _itemCount;
    CGFloat _lastContentOffset;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) void(^tapBlock)(int idx);
@property (nonatomic, copy) void(^ tapClose)(void);
@property (nonatomic, strong) VIPGuideModel *model;
@end

@implementation CNMessageBoxView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}


#pragma mark - 弹窗盒子

+ (void)showMessageBoxWithImages:(NSArray *)images onView:(UIView *)onView tapBlock:(void(^)(int idx))tapBlock tapClose:(void (^)(void))tapClose{
    
    CNMessageBoxView *alert = [[CNMessageBoxView alloc] init];
    alert.frame = onView.bounds;
    [onView addSubview:alert];
    
    alert.images = images;
    alert.tapBlock = tapBlock;
    alert.tapClose = tapClose;
    [alert configUI];
    
    if ([[NNControllerHelper currentRootVcOfNavController] isKindOfClass:NSClassFromString(@"CNHomeVC")]) {
        [NNControllerHelper currentTabBarController].tabBar.hidden = YES;
    }
    
}

- (void)configUI {
    // 和父视图左右间隔22.5，宽高比 330/416
    CGFloat itemW = (kScreenWidth - 22*2);
    CGFloat itemH = self.scrollView.bounds.size.height;
    _itemCount = self.images.count;
    CGFloat itemSpace = 12;
    self.scrollView.contentSize = CGSizeMake( (itemW + itemSpace) * _itemCount, 0);
    self.scrollView.delegate = self;
    if (_itemCount == 1) {
        self.closeBtn.hidden = NO;
        self.pageC.hidden = YES;
    }
    // 创建图片视图
    CGRect frame = CGRectMake(0, 0, itemW, itemH);
    for (int i = 0; i < _itemCount; i++) {
        frame.origin.x = itemSpace*0.5 + (itemW + itemSpace) * i;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        [self.scrollView addSubview:iv];
//        iv.contentMode = UIViewContentModeCenter;
        iv.contentMode = UIViewContentModeScaleAspectFit;
//        iv.backgroundColor = kHexColor(0x212137);
//        iv.layer.cornerRadius = 8;
//        iv.layer.masksToBounds = YES;
        iv.userInteractionEnabled = YES;
        iv.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImg:)];
        [iv addGestureRecognizer:tap];
        
        // 加载图片
        id image = self.images[i];
        if ([image isKindOfClass:[NSString class]]) {
            NSString *name = (NSString *)image;
            if ([name hasPrefix:@"http"]) {
                [iv sd_setImageWithURL:[NSURL URLWithString:name]];
//                [iv sd_setImageWithURL:[NSURL URLWithString:name] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//                }];
            } else {
                iv.image = [UIImage imageNamed:name];
            }
        } else if ([image isKindOfClass:[UIImage class]]) {
            iv.image = image;
        } else {
            NSLog(@"图片格式不对");
        }
    }
    
    // pagaC
    self.pageC.numberOfPages = _itemCount;
}

- (void)didTapImg:(UITapGestureRecognizer *)gesture {
    if (self.tapBlock) {
        self.tapBlock((int)gesture.view.tag);
    }
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
    [NNControllerHelper currentTabBarController].tabBar.hidden = NO;
    if (self.tapClose) {
        self.tapClose();
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / (kScreenWidth-45);
    self.pageC.currentPage = page;
    if (page == _itemCount - 1) {
        self.closeBtn.hidden = NO;
        self.pageC.hidden = YES;
    } else {
        self.closeBtn.hidden = YES;
        self.pageC.hidden = NO;
    }
    
    // VIP私享会间距效果
    if (self.images.count == 0) {
        //判断滚动方向
        if (_lastContentOffset > scrollView.contentOffset.x && page-1 >= 0) {
            // 向左滚动
            UIView *view = scrollView.subviews[page-1];
            view.transform = CGAffineTransformMakeTranslation(-20, 0);
            
        } else if (_lastContentOffset < scrollView.contentOffset.x && page+1 <= _itemCount-1) {
            // 向右滚动
            UIView *view = scrollView.subviews[page+1];
            view.transform = CGAffineTransformMakeTranslation(20, 0);
        }
        _lastContentOffset = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // VIP私享会间距复原
    NSArray *views = scrollView.subviews;
    for (UIView *view in views) {
        view.transform = CGAffineTransformIdentity;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // VIP私享会间距复原
    NSArray *views = scrollView.subviews;
    for (UIView *view in views) {
        view.transform = CGAffineTransformIdentity;
    }
}


#pragma mark - VIP 私享会

+ (void)showVIPSXHMessageBoxOnView:(UIView *)onView{
    // 等接口返回
    [CNVIPRequest vipsxhGuideHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HYVIPIsAlreadyShowV2Alert];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            VIPGuideModel *model = [[VIPGuideModel cn_parse:responseObj] firstObject];
            
            CNMessageBoxView *alert = [[CNMessageBoxView alloc] init];
            alert.model = model;
            alert.frame = onView.bounds;
            [onView addSubview:alert];
            
            [alert configVIPUI];
            
            [NNControllerHelper currentTabBarController].tabBar.hidden = YES;
        }
    }];
}

- (void)configVIPUI {
    [self.closeBtn setImage:[UIImage imageNamed:@"vip_close"] forState:UIControlStateNormal];
    self.pageC.currentPageIndicatorTintColor = kHexColor(0xF8EEAC);
    
    CGFloat itemW = (kScreenWidth - 16*2);
    CGFloat itemH = AD(271);
    self.scrollViewHCons.constant = AD(271);
    _itemCount = 4;
    self.scrollView.contentSize = CGSizeMake(itemW * _itemCount, 0);
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = YES;//和弹窗盒子不同 这里直接裁掉
    for (int i=0; i<_itemCount; i++) {
        VIPNewVersionView *view = [VIPNewVersionView new];
        view.frame = CGRectMake(itemW * i, 0, itemW, itemH);
        WEAKSELF_DEFINE
        view.model = weakSelf.model;
        view.idx = i;
        view.tapBlock = ^(NSInteger curIdx) {
            STRONGSELF_DEFINE
            [strongSelf didTapBtn:curIdx];
        };
        [self.scrollView addSubview:view];
        
    }
    self.pageC.numberOfPages = _itemCount;
    
}

- (void)didTapBtn:(NSInteger)btnIdx {
    if (btnIdx == 3) {
        [self removeFromSuperview];
        [NNControllerHelper currentTabBarController].tabBar.hidden = NO;
        
    } else {
        //翻页
        CGFloat itemW = (kScreenWidth - 16*2);
        [self.scrollView setContentOffset:CGPointMake(itemW*(btnIdx+1), 0) animated:YES];
    }
}

@end
