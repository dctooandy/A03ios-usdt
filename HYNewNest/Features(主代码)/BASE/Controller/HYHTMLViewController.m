//
//  HYHTMLViewController.m
//  HYGEntire
//
//  Created by zaky on 26/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "HYHTMLViewController.h"
#import "NSURL+HYLink.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "CNHomeRequest.h"

@interface HYHTMLViewController ()

@property (nonatomic, copy)NSString *webTitle;
@property (nonatomic, copy)NSString *strUrl;

@end

@implementation HYHTMLViewController

- (instancetype)initWithTitle:(NSString *)webTitle strUrl:(NSString *)strUrl{
    
    self = [super init];
    if (self) {
        self.webTitle = webTitle;
        self.strUrl = strUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = self.webTitle;
    //[self creatRightBtn:@selector(refresh)];
    [self setupView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)setupView{
    
//    self.view.backgroundColor = [UIColor colorMainThemeBackgroundColor];
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([self.webTitle isEqualToString:@"积分兑换"]) {
//        [self creatRightBtnWithTitle:@"兑换记录" action:@selector(btnExchangeClick)];
        [self addNaviRightItemWithTitle:@"兑换记录"];
    }
    
    self.topTabAgUlView = [[TopTabAGUltimateView alloc]init];
    self.topTabAgUlView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topTabAgUlView];
    [_topTabAgUlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [self.topTabAgUlView loadWebViewWithURL:[NSURL getStrUrlWithString:self.strUrl]];
}

- (void)rightItemAction {
    [self btnExchangeClick];
}

- (void)btnExchangeClick{
    
    if ([CNUserManager shareManager].isLogin) {
        WEAKSELF_DEFINE
        [CNHomeRequest requestH5TicketHandler:^(NSString * ticket, NSString *errorMsg) {
            STRONGSELF_DEFINE
            NSString *strUrl = [NSURL getH5StrUrlWithString:H5_URL_GET_VIPRECORD
                                                     ticket:KIsEmptyString(errorMsg)?ticket:@""
                                                needPubSite:NO];
            HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:@"兑换记录" strUrl:strUrl];
            vc.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        NSString *strUrl = [NSURL getH5StrUrlWithString:H5_URL_GET_VIPRECORD ticket:@"" needPubSite:NO];
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:@"兑换记录" strUrl:strUrl];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)back{
    if (self.backBlock) {
        self.backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
