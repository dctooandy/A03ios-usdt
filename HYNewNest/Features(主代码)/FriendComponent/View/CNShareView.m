//
//  CNShareView.m
//  HYNewNest
//
//  Created by Cean on 2020/8/7.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNShareView.h"

@interface CNShareView ()
@property (nonatomic, strong) FriendShareGroupModel *shareModel;
#pragma mark - 回拨弹框属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@end

@implementation CNShareView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

+ (void)showShareViewWithModel:(FriendShareGroupModel *)model {
    
    CNShareView *alert = [[CNShareView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    alert.shareModel = model;
    [alert configUI];
}

- (void)configUI {
    self.bottom.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - button Action

- (IBAction)plaformAction:(UIButton *)sender {
    self.shareType = (CNShareType)sender.tag;
    
    switch (self.shareType) {
        case CNShareTypeCopy:
            [CNHUB showSuccess:@"已复制到剪切板！"];
            break;
        default:{
            NSArray *models = self.shareModel.bannersModel;
            NSString *url;
            for (AdBannerModel *m in models) {
                if ([m.imgCode containsString:@"微信"] && _shareType == CNShareTypeWechat) {
                    url = m.imgExUrl;
                    break;
                }
                if ([m.imgCode containsString:@"QQ"] && _shareType == CNShareTypeQQ) {
                    url = m.imgExUrl;
                    break;
                }
                if ([m.imgCode containsString:@"新浪"] && _shareType == CNShareTypeSina) {
                    url = m.imgExUrl;
                    break;
                }
                if ([m.imgCode containsString:@"朋友圈"] && _shareType == CNShareTypeWechatFriend) {
                    url = m.imgExUrl;
                    break;
                }
            }
            [CNShareCopyView showWithShareTpye:self.shareType url:url];
            break;
        }
    }
    [self removeFromSuperview];
}



// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

@end
