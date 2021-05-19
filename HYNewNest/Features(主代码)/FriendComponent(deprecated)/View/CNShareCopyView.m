//
//  CNShareCopyView.m
//  HYNewNest
//
//  Created by cean.q on 2020/8/7.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNShareCopyView.h"

@interface CNShareCopyView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrOfHoverWidth;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic, assign) CNShareType shareType;
@property (nonatomic, copy) NSString *url;
@end

@implementation CNShareCopyView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

+ (void)showWithShareTpye:(CNShareType)type  url:(NSString *)url{
    
    CNShareCopyView *alert = [[CNShareCopyView alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.url = url;
    alert.shareType = type;
    [alert configUI];
}

- (void)configUI {
    switch (self.shareType) {
        case CNShareTypeWechat:
            self.descLb.text = @"由于微信限制分享,请打开微信\n直接粘贴给好友吧";
            [self.openBtn setTitle:@"打开微信" forState:UIControlStateNormal];
            [self.openBtn setImage:[UIImage imageNamed:@"share_wx_white"] forState:UIControlStateNormal];
            break;
        case CNShareTypeWechatFriend:
            self.descLb.text = @"由于微信限制分享,请打开微信\n直接到朋友圈发布吧";
            [self.openBtn setTitle:@"打开微信" forState:UIControlStateNormal];
            [self.openBtn setImage:[UIImage imageNamed:@"share_pyq_white"] forState:UIControlStateNormal];
            break;
        case CNShareTypeSina:
            self.descLb.text = @"由于新浪限制分享,请打开新浪\n直接粘贴给好友吧";
            [self.openBtn setTitle:@"打开新浪" forState:UIControlStateNormal];
            [self.openBtn setImage:[UIImage imageNamed:@"share_sina_white"] forState:UIControlStateNormal];
            break;
        case CNShareTypeQQ:
            self.descLb.text = @"由于QQ限制分享,请打开QQ\n直接粘贴给好友吧";
            [self.openBtn setTitle:@"打开QQ" forState:UIControlStateNormal];
            [self.openBtn setImage:[UIImage imageNamed:@"share_qq_white"] forState:UIControlStateNormal];
            break;
        case CNShareTypeCopy:
        case CNShareTypeSMS:
                        
            break;
    }
}


- (IBAction)defaultAction:(id)sender {
    [self removeFromSuperview];
    // 跳转各平台
    if(self.url && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        switch (self.shareType) {
            case CNShareTypeWechat:
            case CNShareTypeWechatFriend:
                [CNTOPHUB showError:@"您尚未安装微信"];
                break;
                
            case CNShareTypeSina:
                [CNTOPHUB showError:@"您尚未安装新浪微博"];
                break;
                
            case CNShareTypeQQ:
                [CNTOPHUB showError:@"您尚未安装腾讯QQ"];
                break;
            default:
                break;
        }
    }
}

@end
