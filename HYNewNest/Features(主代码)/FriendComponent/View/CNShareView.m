//
//  CNShareView.m
//  HYNewNest
//
//  Created by Cean on 2020/8/7.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNShareView.h"
#import <MessageUI/MessageUI.h>

@interface CNShareView ()<MFMessageComposeViewControllerDelegate>
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
            
        case CNShareTypeSMS: {
            AdBannerModel *model = self.shareModel.bannersModel.firstObject;
            NSString *shareLink = [NSString stringWithFormat:@"%@%@", model.linkUrl, [CNUserManager shareManager].userInfo.customerId];
            
            [self showMessageView:nil title:@"" body:[NSString stringWithFormat:@"铁子，来币游国际一起领USDT，点击链接参与游戏赢大奖：%@", shareLink]];
            
            break;
        }
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

// 发送短信
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        // --phones发短信的手机号码的数组，数组中是一个即单发,多个即群发。
        controller.recipients = phones;
        // --短信界面 BarButtonItem (取消按钮) 颜色
        controller.navigationBar.tintColor = [UIColor redColor];
        // --短信内容
        controller.body = body;
        controller.messageComposeDelegate = self;
        [[NNControllerHelper currentRootVcOfNavController] presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"该设备不支持短信功能"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        
        [[NNControllerHelper currentRootVcOfNavController] presentViewController:alertController animated:YES completion:nil];
        
    }
}

#pragma mark delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    [controller dismissViewControllerAnimated:YES completion:nil];

    switch (result) {
        case MessageComposeResultCancelled:
            MyLog(@"取消发送");
            break;
            
        case MessageComposeResultSent:
            MyLog(@"已发送");
            break;
            
        case MessageComposeResultFailed:
            MyLog(@"发送失败");
            break;
            
        default:
            break;
    }
}

@end
