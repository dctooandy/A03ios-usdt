//
//  HY403ViewController.m
//  HYGEntire
//
//  Created by zaky on 28/01/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "HY403ViewController.h"
#import "CNTwoStatusBtn.h"

@interface HY403ViewController ()

@end

@implementation HY403ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.makeTranslucent = YES;
    self.navBarTransparent = YES;
    [self setupUI];
}

- (void)setupUI{
    UIImage *img403 = [UIImage imageNamed:@"403-h5"];
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.frame = CGRectMake(0, KIsIphoneXSeries?kNavPlusStaBarHeight:0, kScreenWidth, kScreenWidth * img403.size.height / img403.size.width);
    topImageView.image = img403;
    [self.view addSubview:topImageView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"尊敬的客户";
    titleLbl.frame = CGRectMake(0, kScreenHeight * 0.5 - (KIsIphoneXSeries ? 35 : 55), kScreenWidth, 23);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontPFSB21];
    titleLbl.textColor = kHexColor(0xFFFFFF);
    [self.view addSubview:titleLbl];
    
    UILabel *subtitleLbl = [[UILabel alloc] init];
    subtitleLbl.text = @"Dear Customers";
    subtitleLbl.frame = CGRectMake(0, titleLbl.bottom+2, kScreenWidth, 23);
    subtitleLbl.textAlignment = NSTextAlignmentCenter;
    subtitleLbl.font = [UIFont fontPFSB16];
    subtitleLbl.textColor = kHexColor(0xFFFFFF);
    [self.view addSubview:subtitleLbl];
    
    UITextView *tipTextView = [[UITextView alloc] init];
    tipTextView.frame = CGRectMake(32, CGRectGetMaxY(subtitleLbl.frame)+15, kScreenWidth - 64, 250);
    tipTextView.backgroundColor = [UIColor clearColor];
    tipTextView.editable = NO;
    [self.view addSubview:tipTextView];
    
    NSString *content = @"由于IP访问太过频繁，您所尝试的网页现在无法打开。\n您可以通过以下方式联系我们的客服中心。由此给您带来的不便我们深表歉意；\nDue to the frequent IP access, your attempt to visit our website has been denied. Should you have any inquiries，We apologize for the inconvenience caused; \n\n菲律宾客服热线：+63-999-5168-188\nPlease contact our customer service center at +63-999-5168-188, Live help";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:1];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kHexColor(0x9595BF) range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontPFR14] range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kHexColor(0x32C5FF) range:[content rangeOfString:@"+63-999-5168-188"]];
    tipTextView.attributedText = attributedString;
    
    CNTwoStatusBtn *btnSure = [CNTwoStatusBtn new];
    btnSure.frame = CGRectMake((kScreenWidth-180)*0.5, kScreenHeight - 78 - kSafeAreaHeight, 180, 48);
    [btnSure setTitle:@"在线客服" forState:UIControlStateNormal];
    btnSure.titleLabel.font = [UIFont fontPFSB14];
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
