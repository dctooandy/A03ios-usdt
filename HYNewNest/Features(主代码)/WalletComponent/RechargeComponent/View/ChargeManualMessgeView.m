//
//  ChargeManualMessgeView.m
//  HYGEntire
//
//  Created by zaky on 17/06/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "ChargeManualMessgeView.h"
#import "SGQRCodeGenerateManager.h"
#import "HYDownloadLinkView.h"
#import "HYRechargeHelper.h"
#import "CNTwoStatusBtn.h"
#import "HYOneBtnAlertView.h"
#import "HYTextAlertView.h"

@interface ChargeManualMessgeView ()
@property (copy,nonatomic) NSString *addressText;
@property (copy,nonatomic) NSString *retellingText;
@property (strong,nonatomic) UIImageView *qrCodeImgv;
@end

@implementation ChargeManualMessgeView


- (instancetype)initWithAddress:(NSString *)address amount:(NSString *)amount retelling:(nullable NSString *)retelling type:(ChargeMsgType)chargeType{
    
    self = [super init];
    if (self) {
        
      self.frame = [UIScreen mainScreen].bounds;
        
        self.addressText = address;
        self.retellingText = retelling;
        
        // 半透明背景
      UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
      bgView.backgroundColor = kHexColorAlpha(0x000000, 0.4);
      [self addSubview:bgView];
        
        // 主背景
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, AD(682))];
      mainView.tag = 150;
      mainView.backgroundColor = kHexColor(0x212137);
        [mainView jk_setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:20];
      [self addSubview:mainView];
        
        // 标题
      UILabel *lblSex = [[UILabel alloc] init];
      lblSex.frame = CGRectMake(0, 0, kScreenWidth, AD(50));
      lblSex.text = @"地址详情";
        lblSex.textAlignment = NSTextAlignmentCenter;
      lblSex.font = [UIFont fontPFSB16];
      lblSex.textColor = [UIColor whiteColor];
      [mainView addSubview:lblSex];
        [lblSex addLineDirection:LineDirectionBottom color:kHexColorAlpha(0xFFFFFF, 0.3) width:0.5];
      
        // 关闭按钮
      UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
      [btnCancle setImage:[UIImage imageNamed:@"tips-close"] forState:UIControlStateNormal];
      btnCancle.frame = CGRectMake(CGRectGetWidth(bgView.frame)-AD(30)-25, AD(12), AD(30), AD(30));
      [btnCancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
      [mainView addSubview:btnCancle];
        
        CGFloat maxY = 50;
        if (chargeType == ChargeMsgTypeDCBOX) {
            // 小金库下载
            UIButton *btnBanner = [UIButton buttonWithType:UIButtonTypeSystem];
            [mainView addSubview:btnBanner];
            btnBanner.frame = CGRectMake(AD(15), lblSex.bottom + AD(13), AD(345), AD(115));
            [btnBanner jk_setRoundedCorners:UIRectCornerAllCorners radius:10];
            btnBanner.layer.masksToBounds = YES;
            [btnBanner setBackgroundImage:[UIImage imageNamed:@"banner-3"] forState:UIControlStateNormal];
            btnBanner.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downLoadXJKJump)];
            [btnBanner addGestureRecognizer:tap];
            maxY = CGRectGetMaxY(btnBanner.frame) + AD(38);
            //细节
            UILabel *lbXjk = [[UILabel alloc] init];
            lbXjk.text = @"小金库";
            lbXjk.textColor = kHexColor(0xFFFFFF);
            lbXjk.font = [UIFont fontPFSB21];
            lbXjk.frame = CGRectMake(AD(152), AD(14), AD(70), AD(29));
            [btnBanner addSubview:lbXjk];
            UILabel *lbBxk = [[UILabel alloc] init];
            lbBxk.text = @"USDT 线上保险箱";
            lbBxk.textColor = kHexColor(0xFFFFFF);
            lbBxk.font = [UIFont fontPFM13];
            lbBxk.frame = CGRectMake(AD(152), lbXjk.bottom, AD(150), AD(18));
            [btnBanner addSubview:lbBxk];
            UIButton *ulessBtn = [[UIButton alloc] init];
            ulessBtn.userInteractionEnabled = NO;
            ulessBtn.frame = CGRectMake(AD(152), lbBxk.bottom+AD(10), AD(112), AD(30));
            [ulessBtn setTitle:@" 立即下载" forState:UIControlStateNormal];
            [ulessBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            ulessBtn.titleLabel.font = [UIFont fontPFM13];
            [ulessBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
            [ulessBtn jk_cornerRadius:AD(15) strokeSize:1 color:kHexColor(0xFFFFFF)];
            [btnBanner addSubview:ulessBtn];
            
            maxY = btnBanner.bottom + AD(38);
        } else {
            // 地址 点击复制
            UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(30, maxY+AD(30), kScreenWidth-30*2-70, AD(44))];
            lbl2.text = [NSString stringWithFormat:@"  %@", address];
            lbl2.font = [UIFont fontPFR14];
            lbl2.textColor = kHexColor(0xFFFFFF);
            lbl2.backgroundColor = [UIColor clearColor];
            [lbl2 jk_cornerRadius:10 strokeSize:0.5 color:kHexColorAlpha(0xFFFFFF, 0.14)];
            [mainView addSubview:lbl2];
            
            UIButton *copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl2.frame)-6, maxY+AD(30), 76, AD(44))];
            [mainView addSubview:copyBtn];
            [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
            [copyBtn.titleLabel setFont:[UIFont fontPFM16]];
            [copyBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
            copyBtn.backgroundColor = kHexColor(0x2B2B45);
            [copyBtn jk_setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:10];
//            copyBtn.layer.cornerRadius = 5;
            copyBtn.layer.masksToBounds = YES;
            [copyBtn addTarget:self action:@selector(copyCllick) forControlEvents:UIControlEventTouchUpInside];

            UILabel *lblGrey = [[UILabel alloc] init];
            lblGrey.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            lblGrey.frame = CGRectMake(30, CGRectGetMaxY(copyBtn.frame) + 11, mainView.width - 30, AD(14));
            lblGrey.text = @"使用任意数字货币钱包转帐到该地址";
            lblGrey.textAlignment = NSTextAlignmentCenter;
            lblGrey.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
            [mainView addSubview:lblGrey];
            
            maxY = lblGrey.bottom + AD(60);
        }
        
        UILabel *amountLb = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - AD(176))*0.5, maxY, AD(176), AD(30))];
        NSString *txt = [amount stringByAppendingString:@"USDT"];
        amountLb.textAlignment = NSTextAlignmentCenter;
        amountLb.backgroundColor = [UIColor whiteColor];
        NSMutableAttributedString *attrTxt = [[NSMutableAttributedString alloc] initWithString:txt attributes:@{NSForegroundColorAttributeName:kHexColor(0x11B5DD), NSFontAttributeName: [UIFont fontDBOf32Size]}];
        NSRange rang = [txt rangeOfString:@"USDT"];
        [attrTxt addAttribute:NSFontAttributeName value:[UIFont fontPFR18] range:rang];
        amountLb.attributedText = attrTxt;
        [mainView addSubview:amountLb];
//        [amountLb jk_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10];
        maxY = CGRectGetMaxY(amountLb.frame);
        
        // 二维码处理
        UIImageView *qrCodeImgv = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - AD(176))*0.5, maxY, AD(176), AD(176))];
        qrCodeImgv.backgroundColor = [UIColor redColor];
        [mainView addSubview:qrCodeImgv];
        qrCodeImgv.userInteractionEnabled = YES;
//        [qrCodeImgv jk_setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:10];
//        qrCodeImgv.layer.masksToBounds = YES;
        self.qrCodeImgv = qrCodeImgv;
        maxY = CGRectGetMaxY(qrCodeImgv.frame);
        
        NSString *url = address;
        if (url && chargeType == ChargeMsgTypeDCBOX) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                    [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                }];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HYTextAlertView showWithTitle:@"温馨提示" content:@"您还未安装小金库APP" comfirmText:@"立即安装" cancelText:nil comfirmHandler:^(BOOL isComfirm){
                        if (isComfirm) {
                            [self downLoadXJKJump];
                        }
                    }];
                });
            }
        }
        qrCodeImgv.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:url imageViewWidth:AD(176)];
        
        UILongPressGestureRecognizer *longPGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveQrCodeImg)];
        [qrCodeImgv addGestureRecognizer:longPGes];
        
        
        UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY+AD(13), kScreenWidth, 20)];
        lblTip.text = chargeType==ChargeMsgTypeDCBOX?@"长按保存二维码，请使用小金库扫码支付":@"或使用任意数字货币钱包扫码支付";
        lblTip.textColor = kHexColorAlpha(0xFFFFFF, 0.6);
        lblTip.font = [UIFont fontPFR14];
        lblTip.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:lblTip];
        if (chargeType == ChargeMsgTypeDCBOX) {
            UIImageView *hand = [UIImageView new];
            hand.frame = CGRectMake(AD(51), lblTip.top, 14, 16);
            [hand setImage:[UIImage imageNamed:@"modal-lonepress"]];
            [mainView addSubview:hand];
        }
        
        maxY = CGRectGetMaxY(lblTip.frame);
        
        // 附言
        if (!KIsEmptyString(retelling)) {
            UILabel *attrLb = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY+5, kScreenWidth, 22)];
            [mainView addSubview:attrLb];
            
            NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
            style.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"*" attributes:@{NSFontAttributeName:[UIFont fontPFR15], NSForegroundColorAttributeName:[UIColor redColor], NSParagraphStyleAttributeName: style}];
            NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:@" 转账附言: " attributes:@{NSFontAttributeName:[UIFont fontPFR15], NSForegroundColorAttributeName:kHexColor(0xA0A0A0)}];
            [attrStr appendAttributedString:attr2];
            NSAttributedString *attr3 = [[NSAttributedString alloc] initWithString:retelling attributes:@{NSFontAttributeName:[UIFont fontDBOf16Size], NSForegroundColorAttributeName:kHexColor(0x02EED9)}];
            [attrStr appendAttributedString:attr3];
            
            attrLb.attributedText = attrStr;
            
            maxY = CGRectGetMaxY(attrLb.frame);
        }
        
        // 俩按钮 非手动充值都需要
        if (chargeType != ChargeMsgTypeManual) {
            
            CNTwoStatusBtn *topBtn = [[CNTwoStatusBtn alloc] initWithFrame:CGRectMake(AD(30), maxY+AD(30), kScreenWidth-AD(30)*2, AD(48))];
        
            [topBtn setTitle:@"我已支付,查询订单" forState:UIControlStateNormal];
            topBtn.layer.cornerRadius = AD(24);
            topBtn.layer.masksToBounds = YES;
            topBtn.titleLabel.font = [UIFont fontPFM16];
            topBtn.tag = 1;
            [topBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            topBtn.enabled = YES;
            [mainView addSubview:topBtn];
            
            UIButton *botoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [botoomBtn setTitle:(chargeType == ChargeMsgTypeDCBOX)?@"唤醒APP异常，前往H5支付":@"遇到问题？联系客服" forState:UIControlStateNormal];
            [botoomBtn.titleLabel setFont: [UIFont fontPFM16]];
            UIColor *gColor = [UIColor jk_gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withHeight:AD(48)];
            [botoomBtn setTitleColor:gColor forState:UIControlStateNormal];
            botoomBtn.layer.cornerRadius = AD(24);
            botoomBtn.layer.borderWidth = 1;
            botoomBtn.layer.borderColor = gColor.CGColor;
            botoomBtn.frame = CGRectMake(topBtn.x, topBtn.bottom+AD(26), topBtn.width, topBtn.height);
            botoomBtn.tag = 0;
            if (chargeType == ChargeMsgTypeDCBOX) {
                [botoomBtn addTarget:self action:@selector(jump2H5Pay) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [botoomBtn addTarget:self action:@selector(jump2Kefu) forControlEvents:UIControlEventTouchUpInside];
            }
            [mainView addSubview:botoomBtn];
            
            maxY = CGRectGetMaxY(botoomBtn.frame);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            mainView.y = kScreenHeight - AD(652);
        }];
    }
    return self;
}


#pragma mark - ACTION

- (void)topBtnAction:(UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock(YES);
    }
    [self removeView];
}

- (void)jump2H5Pay {
    NSString *urlStr = self.addressText;
    //replace to https://app.dcusdt.com/pay
    if ([urlStr hasPrefix:@"dcbox://pay"]) {
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"dcbox://pay" withString:@"https://app.dcusdt.com/pay"];
    } else if ([urlStr hasPrefix:@"dcusdt://pay"]) {
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"dcusdt://pay" withString:@"https://app.dcusdt.com/pay"];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
        }];
    } else {
        [CNTOPHUB showError:@"小金库PayURL错误 请联系客服"];
    }
}

- (void)jump2Kefu {
    [NNPageRouter presentOCSS_VC];
    [self removeView];
}

- (void)copyCllick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressText;
    [CNTOPHUB showSuccess:@"复制成功"];
}

- (void)downLoadXJKJump {
    NSURL *URLdown = [NSURL URLWithString:kDownload_XJK_Address];
    if ([[UIApplication sharedApplication] canOpenURL:URLdown]) {
        [[UIApplication sharedApplication] openURL:URLdown options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"正在为您跳转币付宝下载页.."];
        }];
    }
}


#pragma mark - SAVE IMG

- (void)saveQrCodeImg {
    kPreventRepeatTime(2);
    [HYOneBtnAlertView showWithTitle:@"保存支付二维码到相册" content:@"若第一次保存请允许访问权限弹窗，否则小游无法为您保存图片哦~" comfirmText:@"好的" comfirmHandler:^{
        UIImageWriteToSavedPhotosAlbum(self.qrCodeImgv.image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        // 私有api
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"photos-redirect://"] options:@{} completionHandler:nil];
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {

    if(error) {
        [CNTOPHUB showError:[NSString stringWithFormat:@"保存失败: %@",error.localizedDescription]];
    }else{
        [CNTOPHUB showSuccess:@"保存成功 请打开相册查看"];
    }
    
}


#pragma mark - REMOVE

- (void)cancleClick{
    
    [self removeView];
}

- (void)removeView{
    UIView *mainView = [self viewWithTag:150];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = kScreenHeight;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}


@end
