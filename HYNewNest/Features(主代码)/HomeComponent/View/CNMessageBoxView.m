//
//  CNMessageBoxView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/5.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMessageBoxView.h"
#import <UIImageView+WebCache.h>

@interface CNMessageBoxView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, copy) NSArray *images;
@end

@implementation CNMessageBoxView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

+ (void)showMessageBoxWithImages:(NSArray *)images {
    
    CNMessageBoxView *alert = [[CNMessageBoxView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.images = images;
    [alert configUI];
}

- (void)configUI {
    // 和父视图左右间隔22.5，宽高比 330/416
    CGFloat left = 22.5;
    CGFloat itemW = (kScreenWidth - left*2);
    CGFloat itemH = self.scrollView.bounds.size.height;
    NSInteger itemCount = self.images.count;
    CGFloat itemSpace = 10;
    self.scrollView.contentSize = CGSizeMake((itemW+itemSpace)*itemCount, itemH);
    self.scrollView.delegate = self;
    // 创建图片视图
    CGRect frame = CGRectMake(0, 0, itemW, itemH);
    for (int i = 0; i < itemCount; i++) {
        frame.origin.x = (itemW + itemSpace) * i;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        [self.scrollView addSubview:iv];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.cornerRadius = 8;
        iv.layer.masksToBounds = YES;
        
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
    self.pageC.numberOfPages = itemCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / (kScreenWidth-45);
    self.pageC.currentPage = page;
    if (page == self.images.count - 1) {
        self.closeBtn.hidden = NO;
        self.pageC.hidden = YES;
    } else {
        self.closeBtn.hidden = YES;
        self.pageC.hidden = NO;
    }
}

#pragma mark - button Action

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

@end
