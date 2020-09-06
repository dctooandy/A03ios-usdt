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

@interface CNMessageBoxView () <UIScrollViewDelegate>
{
    NSInteger _itemCount;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) void(^tapBlock)(int idx);
@end

@implementation CNMessageBoxView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

+ (void)showMessageBoxWithImages:(NSArray *)images onView:(UIView *)onView tapBlock:(void(^)(int idx))tapBlock {
    
    CNMessageBoxView *alert = [[CNMessageBoxView alloc] init];
    alert.frame = onView.bounds;
    [onView addSubview:alert];
    
    alert.images = images;
    alert.tapBlock = tapBlock;
    [alert configUI];
}

- (void)configUI {
    // 和父视图左右间隔22.5，宽高比 330/416
    CGFloat itemW = (kScreenWidth - 22*2);
    CGFloat itemH = self.scrollView.bounds.size.height;
    _itemCount = self.images.count;
    CGFloat itemSpace = 12;
    self.scrollView.contentSize = CGSizeMake( (itemW + itemSpace) * _itemCount, 0);
    self.scrollView.delegate = self;
    // 创建图片视图
    CGRect frame = CGRectMake(0, 0, itemW, itemH);
    for (int i = 0; i < _itemCount; i++) {
        frame.origin.x = itemSpace*0.5 + (itemW + itemSpace) * i;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        
        [self.scrollView addSubview:iv];
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
    
    if (self.images.count == 0) { // VIPde
        NSArray *subViews = scrollView.subviews;
        if (page - 1 > 0) {
            UIView *view = subViews[page - 1];
            view.transform = CGAffineTransformMakeTranslation(-20, 0);
        }
        else if (page + 1 <= _itemCount - 1) {
            UIView *view = subViews[page+1];
            view.transform = CGAffineTransformMakeTranslation(20, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / (kScreenWidth-45);
    UIView *view = scrollView.subviews[page];
    view.transform = CGAffineTransformIdentity;
}

#pragma mark - button Action

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}


#pragma mark - VIP 私享会
+ (void)showVIPSXHMessageBoxOnView:(UIView *)onView tapBlock:(void (^)(int))tapBlock {
    CNMessageBoxView *alert = [[CNMessageBoxView alloc] init];
    alert.frame = onView.bounds;
    [onView addSubview:alert];

    alert.tapBlock = tapBlock;
    [alert configVIPUI];
}

- (void)configVIPUI {
    CGFloat itemW = (kScreenWidth - 16*2);
    CGFloat itemH = AD(271);
    self.scrollViewHCons.constant = AD(271);
    _itemCount = 4;
//    CGFloat itemSpace = 16;
    self.scrollView.contentSize = CGSizeMake(itemW * _itemCount, 0);
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = YES;//和弹窗盒子不同 这里直接裁掉
    for (int i=0; i<_itemCount; i++) {
        VIPNewVersionView *view = [VIPNewVersionView new];
        view.frame = CGRectMake(itemW * i, 0, itemW, itemH);
        view.idx = i;
        [self.scrollView addSubview:view];
    }
    self.pageC.numberOfPages = _itemCount;
}

@end
