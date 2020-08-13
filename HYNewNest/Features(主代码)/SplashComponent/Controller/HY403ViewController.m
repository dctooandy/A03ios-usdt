//
//  HY403ViewController.m
//  HYGEntire
//
//  Created by zaky on 28/01/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "HY403ViewController.h"

@interface HY403ViewController ()

@end

@implementation HY403ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = [UIScreen mainScreen].bounds;
    bgImageView.image = [UIImage imageNamed:@"Error403Bg"];
    [self.view addSubview:bgImageView];
    
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.frame = CGRectMake(0 , kScreenHeight * 0.5 - (kScreenWidth * 0.6) - 40, kScreenWidth, kScreenHeight * 0.6);
    topImageView.image = [UIImage imageNamed:@"ErrorNew403"];
    [self.view addSubview:topImageView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"尊敬的客户\nDear Customers";
    titleLbl.frame = CGRectMake(0, kScreenHeight * 0.5 - (KIsIphoneXSeries ? 20 : 40), kScreenWidth, 50);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    titleLbl.textColor = kHexColor(0x676767);
    titleLbl.numberOfLines = 2;
    [self.view addSubview:titleLbl];
    
    UITextView *tipTextView = [[UITextView alloc] init];
    tipTextView.frame = CGRectMake(25, CGRectGetMaxY(titleLbl.frame), kScreenWidth - 50, 250);
    tipTextView.backgroundColor = [UIColor clearColor];
    tipTextView.textColor = kHexColor(0x676767);
    tipTextView.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    tipTextView.editable = NO;
    [self.view addSubview:tipTextView];
    
    NSString *content = @"由于IP访问太过频繁，您所尝试的网页现在无法打开。\n您可以通过以下方式联系我们的客服中心。由此给您带来的不便我们深表歉意；\n\nDue to the frequent IP access, your attempt to visit our website has been denied. Should you have any inquiries，We apologize for the inconvenience caused; \n\n菲律宾客服热线：+63-999-5168-188\n\nPlease contact our customer service center at +63-999-5168-188, Live help";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:1];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kHexColor(0x676767) range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[content rangeOfString:@"+63-999-5168-188"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[content rangeOfString:@"cs@ga88.com"]];
    tipTextView.attributedText = attributedString;
    
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSure.frame = CGRectMake(30, kScreenHeight - 50 - 35, kScreenWidth - 60, 50);
    [btnSure setTitle:@"在线客服" forState:UIControlStateNormal];
    btnSure.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    btnSure.layer.cornerRadius = 5;
    [btnSure addTarget:self action:@selector(btnSureClick) forControlEvents:UIControlEventTouchUpInside];
    [btnSure setBackgroundColor:kHexColor(0xCFA461)];
    [btnSure setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    [self.view addSubview:btnSure];
}

- (void)btnSureClick{
    
    [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
}


@end
