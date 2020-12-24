//
//  BYSuperCopartnerVC.m
//  HYNewNest
//
//  Created by zaky on 12/9/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYSuperCopartnerVC.h"
#import "UIView+DottedLine.h"
#import "CNTextSaleBtn.h"
#import "HYOneBtnAlertView.h"
#import "CNShareView.h"
#import "HYVIPRuleAlertView.h"
#import "HYSuperCopartnerReciveAlertView.h"
#import "HYSuperCopartnerSlideUpView.h"

#import "SuperCopartnerTbDataSource.h"
#import "SGQRCodeGenerateManager.h"
#import "CNHomeRequest.h"
#import "CNSuperCopartnerRequest.h"

@interface BYSuperCopartnerVC () <SuperCopartnerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthCons;

/// 我的奖金
@property (weak, nonatomic) IBOutlet UIView *myAllkindsBonusBoard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bonusBoardHeightCons;
@property (weak, nonatomic) IBOutlet UIView *topBtnsBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideLineCenterCons;
//@property (weak, nonatomic) IBOutlet UIView *slideLine;
@property (weak, nonatomic) IBOutlet UITableView *makTableView;
@property (strong, nonatomic) IBOutletCollection(CNTextSaleBtn) NSArray *myAllKindBonusBtns;
@property (nonatomic, assign) NSInteger selTag;
@property (strong,nonatomic) SuperCopartnerTbDataSource *firstTablesDataSource;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreBtn;

/// 本月累投排行榜
@property (weak, nonatomic) IBOutlet UIView *monthCumulateBetBoard;
@property (weak, nonatomic) IBOutlet UITableView *mcbTableView;
@property (strong,nonatomic) SuperCopartnerTbDataSource *cumulateBetDataSource;
@property (weak, nonatomic) IBOutlet UILabel *cumulateBetAmountLb;

// 推荐流程
@property (weak, nonatomic) IBOutlet UILabel *linkLb;
@property (weak, nonatomic) IBOutlet UIImageView *linkImv;
@property (nonatomic, strong) FriendShareGroupModel *shareModel;
@end

@implementation BYSuperCopartnerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.hideNavgation = YES;
    
    self.title = @"超级合伙人";
    self.selTag = 0;
    [self setupUIViews];

    
//    [HYSuperCopartnerReciveAlertView showReceiveAlert];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_monthCumulateBetBoard drawDottedLineBeginPoint:CGPointMake(0, _monthCumulateBetBoard.height-45) endPoint:CGPointMake(kScreenWidth-25, _monthCumulateBetBoard.height-45) lineWidth:0.5 lineColor:kHexColor(0x6020DB)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self queryShareLinks];
}


#pragma mark - UI

- (void)setupUIViews {
    self.scrollViewWidthCons.constant = kScreenWidth;
    self.view.backgroundColor = kHexColor(0x190A39);
    _topBtnsBgView.backgroundColor = [UIColor gradientFromColor:kHexColor(0x8241FF) toColor:kHexColor(0x6020DB) withWidth:kScreenWidth-25];
    
    // 第一部分tableview
    _firstTablesDataSource = [[SuperCopartnerTbDataSource alloc] initWithTableView:_makTableView type:SuperCopartnerTypeMyBonus isHomePage:YES];
    
    // 第二部分tableView
    _cumulateBetDataSource = [[SuperCopartnerTbDataSource alloc] initWithTableView:_mcbTableView type:SuperCopartnerTypeCumuBetRank isHomePage:YES];
    _cumulateBetDataSource.delegate = self;
    
    [_myAllKindBonusBtns enumerateObjectsUsingBlock:^(CNTextSaleBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selFont = [UIFont fontPFSB16];
        obj.norFont = [UIFont fontPFR14];
        obj.selColor = [UIColor whiteColor];
        obj.norColor = [UIColor whiteColor];
    }];

}

- (void)updateShare {
    // 链接和二维码
    AdBannerModel *model = self.shareModel.bannersModel.firstObject;
    NSString *shareLink = [NSString stringWithFormat:@"%@%@", model.linkUrl, [CNUserManager shareManager].userInfo.customerId];
    self.linkLb.text = shareLink;
    
    UIImage *img = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:shareLink imageViewWidth:101];
    self.linkImv.image = img;
}

- (void)didReceiveCumulateBetAmount:(NSNumber *)betAmount {
    _cumulateBetAmountLb.text = [NSString stringWithFormat:@"%@ USDT", [betAmount jk_toDisplayNumberWithDigit:0]];
}


#pragma mark - Action

- (IBAction)didTapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapRuleBtn:(id)sender {
    [HYVIPRuleAlertView showFriendShareV2Rule];
}

- (IBAction)didSelectedTag:(CNTextSaleBtn *)sender {
    NSInteger lastTag = self.selTag;
    [_myAllKindBonusBtns enumerateObjectsUsingBlock:^(CNTextSaleBtn *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
    }];
    sender.selected = YES;
    self.selTag = sender.tag;
    
    CGFloat spacex = (_selTag - lastTag) * sender.width;
    self.slideLineCenterCons.constant += spacex;
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.topBtnsBgView setNeedsLayout];
//    }];
    
}

- (IBAction)didTapShareBtn:(id)sender {
    [UIPasteboard generalPasteboard].string = self.linkLb.text;
    [CNHUB showSuccess:@"已复制到剪贴板"];
}

- (IBAction)didTapSaveImg:(id)sender {
    [self saveQrCodeImg];
}

- (IBAction)didTapRecomonBtn:(id)sender {
    [CNShareView showShareViewWithModel:self.shareModel];
    [UIPasteboard generalPasteboard].string = self.linkLb.text;
    [CNHUB showSuccess:@"已复制到剪贴板"];
}

- (IBAction)didTapSeeMoreBtn:(id)sender {
    switch (_selTag) {
        case SuperCopartnerTypeMyBonus:
        case SuperCopartnerTypeMyRecommen:
            //弹窗
            [HYSuperCopartnerSlideUpView showSlideupViewType:_selTag];
            break;
        case SuperCopartnerTypeSXHBonus:
            [kCurNavVC popToRootViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NNControllerHelper currentTabBarController].selectedIndex = 1;
            });
            break;
        case SuperCopartnerTypeStarGifts:
            [NNPageRouter jump2HTMLWithStrURL:@"/starall" title:@"星特权新体验" needPubSite:YES];
            break;
        default:
            break;
    }
}

- (IBAction)didTapCustomerServerBtn:(id)sender {
    [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
}

//- (IBAction)didTapMyGiftBtn:(id)sender {
//    //TODO: 弹窗
//    [HYSuperCopartnerSlideUpView showSlideupViewType:SuperCopartnerTypeMyGifts];
//}

#pragma mark - SAVE IMG

- (void)saveQrCodeImg {
    kPreventRepeatTime(2);
    [HYOneBtnAlertView showWithTitle:@"保存您的分享链接二维码到相册" content:@"若第一次保存请允许访问权限弹窗，否则小游无法为您保存图片哦~" comfirmText:@"好的" comfirmHandler:^{
        UIImageWriteToSavedPhotosAlbum(self.linkImv.image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {

    if(error) {
        [CNHUB showError:[NSString stringWithFormat:@"保存失败: %@",error.localizedDescription]];
    }else{
        [CNHUB showSuccess:@"保存成功 请打开相册查看"];
    }
    
}


#pragma mark - Request

/// 分享链接
- (void)queryShareLinks {
    if ([CNUserManager shareManager].isLogin) {
        [CNHomeRequest requestBannerWhere:BannerWhereFriend Handler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                self.shareModel = [FriendShareGroupModel cn_parse:responseObj];
                [self updateShare];
            }
        }];
    }
}


#pragma mark - Setter

// 改变数据源
- (void)setSelTag:(NSInteger)selTag {
    _selTag = selTag;
    [self.firstTablesDataSource changeType:selTag];
    switch (selTag) {
        case SuperCopartnerTypeMyBonus:
        case SuperCopartnerTypeMyRecommen:
            _bonusBoardHeightCons.constant = 245;
            [_seeMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
            break;
        case SuperCopartnerTypeSXHBonus:
            _bonusBoardHeightCons.constant = 271;
            [_seeMoreBtn setTitle:@"了解私享会" forState:UIControlStateNormal];
            break;
        case SuperCopartnerTypeStarGifts:
            _bonusBoardHeightCons.constant = 349;
            [_seeMoreBtn setTitle:@"了解更多星级" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
