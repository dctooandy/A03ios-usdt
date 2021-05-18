//
//  CNAddressInfoTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddressDownloadTCell.h"
#import "SGQRCodeGenerateManager.h"
#import "HYDownloadLinkView.h"
#import "CNAddAddressVC.h"

@interface CNAddressDownloadTCell ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (nonatomic, strong) HYDownloadLinkView *linkView;
@end

@implementation CNAddressDownloadTCell

- (HYDownloadLinkView *)linkView {
    if (!_linkView) {
        HYDownloadLinkView *view = [[HYDownloadLinkView alloc] initWithFrame:CGRectMake(AD(117), AD(110), AD(140), AD(25)) normalText:@"已有小金库？" tapableText:@"立即添加" tapColor:kHexColor(0x10B4DD) urlValue:nil];
        view.tapBlock = ^{
            CNAddAddressVC *vc = [CNAddAddressVC new];
            vc.addrType = HYAddressTypeDCBOX;
            [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
        };
        _linkView = view;
    }
    return _linkView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *qrCode = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:kDownload_XJK_Address imageViewWidth:80];
    _imageV.image = qrCode;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.mainView addSubview:self.linkView];
}

- (IBAction)didTapMore:(id)sender {
    NSURL *url = [NSURL URLWithString:kDownload_XJK_Address];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
        }];
    }
}

// 在view中重写以下方法，其中self.xxx就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
    // 转换坐标系
    CGPoint newPoint = [self.linkView convertPoint:point fromView:self];
    // 判断触摸点是否在button上
    if (CGRectContainsPoint(self.linkView.lblDown.bounds, newPoint)) {
        self.linkView.tapBlock();
        return self.linkView;
    }
    
    CGPoint newPoint2 = [self.downloadBtn convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.downloadBtn.bounds, newPoint2)) {
        return self.downloadBtn;
    }
    
    return nil;
}

@end
