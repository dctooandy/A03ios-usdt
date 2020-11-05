//
//  HYBuyECoinGuideVC.m
//  HYNewNest
//
//  Created by zaky on 10/15/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBuyECoinGuideVC.h"
#import "CNBaseNetworking.h"
#import "CNTwoStatusBtn.h"
#import "BuyECoinModel.h"
#import "LTSegmentedBar.h"
#import "CNRechargeRequest.h"
#import <SDWebImageDownloader.h>
#import "HYRechargeHelper.h"
#import "ChargeManualMessgeView.h"
#import "HYBuyECoinComfirmView.h"
#import "CNTradeRecodeVC.h"
#import "HYBuyECoinCheckboxTag.h"

@interface HYBuyECoinGuideVC ()<LTSegmentedBarDelegate, UIScrollViewDelegate>
{
    CGFloat _topTagsContainerHeight;
}
@property (nonatomic, assign) NSInteger curIdx;
@property (weak, nonatomic) IBOutlet UIView *topBtnsBgView;
@property (nonatomic, strong) LTSegmentedBar *segmentedBar;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *btnRecharge;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *btnRegister;

@property (weak, nonatomic) IBOutlet UIView *topTagsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTagsContainHeightCons;

@property (nonatomic, strong) NSMutableArray *downloadTokens;
@property (strong,nonatomic) NSArray<BuyECoinModel*> *datas;
@property (strong,nonatomic) NSMutableDictionary *groupImgsDict;

@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (nonatomic, assign, readwrite) NSInteger selcPayWayIdx;

@property(nonatomic,strong) UIProgressView *progressView;
@end

@implementation HYBuyECoinGuideVC

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = kHexColor(0x02EED9);
        _progressView.frame = CGRectMake(0, 0, _contentScrollView.width, 2);
    }
    return _progressView;
}

- (LTSegmentedBar *)segmentedBar {
    if (!_segmentedBar) {
        LTSegmentedBar *segmentBar = [LTSegmentedBar segmentedBarWithFrame:CGRectZero];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor clearColor];
        segmentBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _topBtnsBgView.height);
        // Setup SegmentedBar Configuration here
        [segmentBar updateWithConfig:^(LTSegmentedBarConfig *config) {
            config.itemNormalColor = kHexColor(0x6D778B);
            config.itemSelectColor = [UIColor whiteColor];
            config.itemNormalFont = [UIFont fontPFR14];
            config.itemSelectFont = [UIFont fontPFSB16];
            config.indicatorHeight = 0;
//            config.indicatorWidth = 20;
//            config.indicatorColor = [UIColor whiteColor];
            config.splitLineColor = kHexColor(0x6D778B);
            config.itemWidthFit = YES;
        }];
        
        [_topBtnsBgView addSubview:segmentBar];
        _segmentedBar = segmentBar;
        
    }
    return _segmentedBar;
}


#pragma mark - VIEW LIFE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"买币指南";
    [self addNaviRightItemWithImageName:@"service"];
    [self setupAttributes];
    _curIdx = 0;
    self.downloadTokens = @[].mutableCopy;
    self.groupImgsDict = @{}.mutableCopy;
    
    [self getDynamicData];
    [self queryDepositBankPayWays];
}

- (void)rightItemAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}


#pragma mark - SETUP

- (void)setupAttributes {
    _topBtnsBgView.backgroundColor = _topTagsContainer.backgroundColor = self.view.backgroundColor = kHexColor(0x212137);
    _btnRecharge.enabled = YES;
    _btnRegister.enabled = YES;
    _contentScrollView.backgroundColor = kHexColor(0x161627);
}

- (void)setupViewDatas {
    if (!self.datas.count) {
        return;
    }
    // 头部
    NSMutableArray *names = @[].mutableCopy;
    NSInteger recIdx = 0;
    for (int i=0; i<self.datas.count; i++) {
        BuyECoinModel *model = self.datas[i];
        [names addObject:model.name];
        if ([model.recommend containsString:@"1"]) {
            recIdx = i; //推荐标签
        }
    }
    self.segmentedBar.recomendIndex = recIdx + 1;
    [self.segmentedBar setItems:names];
    self.segmentedBar.selectedIndex = 0;
    // 标签
    [self setupTags];
    // 内容
    [self setupContent];
}

- (void)setupTags {
    for (UIView *subView in _topTagsContainer.subviews) {
        [subView removeFromSuperview];
    }
    BuyECoinModel *model = self.datas[_curIdx];
    NSArray *tags = [model.label componentsSeparatedByString:@";"];
    
    CGFloat leftSpace = AD(12);
    CGFloat btnSpace = AD(10);
    CGFloat maxX = leftSpace;
    CGFloat maxY = AD(5);
    for (NSString *tag in tags) {
        HYBuyECoinCheckboxTag *tagBtn = [HYBuyECoinCheckboxTag buttonWithType:UIButtonTypeCustom];
        [tagBtn setTitle:tag forState:UIControlStateNormal];
        [tagBtn sizeToFit];
        //tagBtn.width + 30 -- 按钮宽
        if (maxX + tagBtn.width + 30 > (kScreenWidth - AD(12))) {
            maxX = leftSpace;
            maxY = maxY + 30 + btnSpace;
        }
        tagBtn.frame = CGRectMake(maxX, maxY, tagBtn.width + 30, 30);
        maxX = CGRectGetMaxX(tagBtn.frame) + btnSpace;
        [_topTagsContainer addSubview:tagBtn];
    }
    _topTagsContainerHeight = maxY + 30 + 15;
    _topTagsContainHeightCons.constant = _topTagsContainerHeight;
}

- (void)setupContent {
    for (UIView *subView in _contentScrollView.subviews) {
        [subView removeFromSuperview];
    }
    [_contentScrollView addSubview:self.progressView];
    
    BuyECoinModel *model = self.datas[_curIdx];
    [self.btnRegister setTitle:model.registerText forState:UIControlStateNormal];
    // 取缓存
    NSMutableArray *imgs = @[].mutableCopy;
    if ([self.groupImgsDict[@(_curIdx)] count] > 0) {
        imgs = self.groupImgsDict[@(_curIdx)];
        CGFloat maxY = AD(20);
        for (int i=0; i<imgs.count; i++) {
            UIImage *img = [UIImage imageWithData:imgs[i]];
            UIImageView *imgv = [UIImageView new];
            imgv.frame = CGRectMake(0, maxY, kScreenWidth-20, img.size.height*(kScreenWidth-20)/img.size.width);
            imgv.image = img;
            maxY = CGRectGetMaxY(imgv.frame) + AD(20);
            [self.contentScrollView addSubview:imgv];
            
        }
        self.contentScrollView.contentSize = CGSizeMake(0, maxY);
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSArray *imgURLs = [model.imgList componentsSeparatedByString:@";"];
    NSMutableArray *imgFullURLs = @[].mutableCopy;
    for (NSString *imgPath in imgURLs) {
        NSString *imgFullPath = [model.imgRootPath_h5 stringByAppendingPathComponent:imgPath];
//        NSString *encodePath = [imgFullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodePath = [imgFullPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        [imgFullURLs addObject:encodePath];
    }
    
    [self downloadImage:imgFullURLs arrayImages:imgs currentIndex:0 success:^(NSArray<NSData *> *resultImages) {
        
        if (imgs.count > 0) {
            [self.groupImgsDict setObject:imgs forKey:@(self.curIdx)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            CGFloat maxY = AD(20);
            for (int i=0; i<resultImages.count; i++) {
                UIImage *img = [UIImage imageWithData:resultImages[i]];
                UIImageView *imgv = [UIImageView new];
                imgv.frame = CGRectMake(0, maxY, kScreenWidth-20, img.size.height*(kScreenWidth-20)/img.size.width);
                imgv.image = img;
                maxY = CGRectGetMaxY(imgv.frame) + AD(20);
                [self.contentScrollView addSubview:imgv];
                
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.contentScrollView.contentSize = CGSizeMake(0, maxY);
        });
        
        
    } failure:^{
        [CNHUB showError:@"下载指南失败 获取图片出错"];
    }];

}

//递归按序下载图片
- (void)downloadImage:(NSArray <NSString *> *)arrayURLs arrayImages:(NSMutableArray<NSData *> *)arrayImages currentIndex:(NSUInteger)index success:(void (^)(NSArray <NSData *> *resultImages))success failure:(void (^)(void))failure {
   
    __block NSUInteger currentIndex = index;
   
    //这里使用 weakself, 在控制器销毁的时候, 当前下载任务完成后,就不会继续下一个任务, 如果使用 self, 那么当控制器销毁的时候, SD 会继续下载直到所有任务完成
    __weak typeof(self) weakSelf = self;
   
    NSString *stringurl = arrayURLs[currentIndex];
   
    NSURL *url = [NSURL URLWithString:stringurl];
        
    SDWebImageDownloadToken *token = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
       
        float p = receivedSize / (expectedSize * 1.0);
        NSLog(@"当前索引 %lu, 当前进度: %f", (unsigned long)currentIndex, p);
       
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        currentIndex++;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.hidden = NO;
            self.progressView.progress = currentIndex / (arrayURLs.count * 1.0);
        });
       
        if (finished && !error && data) {  //下载结束并且没有出错
            [arrayImages addObject:data];
        }
       
        if (currentIndex == arrayURLs.count) { //停止递归下载
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
            if(arrayImages.count > 0){  //当数组有元素存在,认为是成功, 也可以只写一个回调block, 不区分成功与失败
                if(success){
                    success(arrayImages);
                }
            }else{
                if(failure){
                    failure();
                }
            }
            return;
        } else {
            //继续递归下载
            [weakSelf downloadImage:arrayURLs arrayImages:arrayImages currentIndex:currentIndex success:success failure:failure];
        }
    }];
    if (token) [self.downloadTokens addObject:token];
}


#pragma mark - setter
- (void)setCurIdx:(NSInteger)curIdx {
    if (_curIdx != curIdx) {
        _curIdx = curIdx;
        [self setupTags];
        for (SDWebImageDownloadToken *token in self.downloadTokens) {
            [token cancel];
        }
        [self.downloadTokens removeAllObjects];
        [self setupContent];
    }
}


#pragma mark - Action
- (IBAction)didTapRechargeECoin:(id)sender {
    HYBuyECoinComfirmView *view = [[HYBuyECoinComfirmView alloc] initWithDepositModels:self.depositModels switchHandler:^(NSInteger idx) {
        self.selcPayWayIdx = idx;
        [self queryOnlineBankAmount];
    } submitHandler:^(NSString *amount) {
        [self submitUSDTRequest:amount];
    }];
    [self.view addSubview:view];
    [view show];
    
}

- (IBAction)didTapRegisterBtn:(id)sender {
    BuyECoinModel *model = self.datas[_curIdx];
    // bitbase + 去注册 == 就走外部跳转
    if ([model.name caseInsensitiveCompare:@"bitbase"] == NSOrderedSame && [model.registerText isEqualToString:@"去注册"]) {
        [CNHUB showSuccess:@"请在外部浏览器查看"];
        [NNPageRouter openExchangeElecCurrencyPage];
    } else {
        NSURL *url = [NSURL URLWithString:model.registerUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                [CNHUB showSuccess:@"请在外部浏览器查看"];
            }];
        }
    }
}


#pragma mark - LTSegmentedBarDelegate

- (void)segmentBar:(LTSegmentedBar *)segmentedBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    [self.contentScrollView setContentOffset:CGPointZero animated:YES];
    [self handleTopTagsContainerStatusHide:NO];
    self.curIdx = toIndex;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.jk_ScrollDirection == JKScrollDirectionUp) {
        MyLog(@"UP UP UP");
        if (scrollView.contentOffset.y < 300) {
            [self handleTopTagsContainerStatusHide:NO];
        }
    } else {
        MyLog(@"DOWN DOWN");
        [self handleTopTagsContainerStatusHide:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 300) {
        [self handleTopTagsContainerStatusHide:NO];
    } else {
        [self handleTopTagsContainerStatusHide:YES];
    }
    
}

- (void)handleTopTagsContainerStatusHide:(BOOL)isHide {
    if (isHide) {
        self.topTagsContainHeightCons.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.topTagsContainer.hidden = YES;
        }];
    } else {
        self.topTagsContainHeightCons.constant = _topTagsContainerHeight;
        self.topTagsContainer.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Request

- (void)getDynamicData {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"MAIBI_GUIDE" forKey:@"bizCode"];
    [CNBaseNetworking POST:kGatewayPath(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *data = [responseObj objectForKey:@"data"];
            
            if (self.needNotShowBitbase) {
                NSMutableArray *rawDatas = [BuyECoinModel cn_parse:data];
                for (BuyECoinModel *model in rawDatas.reverseObjectEnumerator) {
                    if ([model.name caseInsensitiveCompare:@"Bitbase"] == NSOrderedSame) {
                        [rawDatas removeObject:model];
                    }
                }
                self.datas = rawDatas.copy;
            } else {
                self.datas = [BuyECoinModel cn_parse:data];
            }
            
            [self setupViewDatas];
        }
    }];
    
}

/**
USDT支付渠道
*/
- (void)queryDepositBankPayWays {
    [CNRechargeRequest queryUSDTPayWalletsHandler:^(id responseObj, NSString *errorMsg) {
        NSArray *depositModels = [DepositsBankModel cn_parse:responseObj];
        NSMutableArray *models = @[].mutableCopy;
        for (DepositsBankModel *bank in depositModels) {
            if (([bank.bankname isEqualToString:@"dcbox"] || [HYRechargeHelper isUSDTOtherBankModel:bank])) {
                [models addObject:bank];
            }
        }
        self.depositModels = models;
        self.selcPayWayIdx = 0;

    }];
}

/**
在线类支付 需要
*/
- (void)queryOnlineBankAmount {
    DepositsBankModel *model = self.depositModels[_selcPayWayIdx];
    [CNRechargeRequest queryOnlineBanksPayType:model.payType
                                  usdtProtocol:@"ERC20"
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
        }
    }];
}

- (void)submitUSDTRequest:(NSString *)amount {
    DepositsBankModel *model = self.depositModels[_selcPayWayIdx];
    
    if ([HYRechargeHelper isUSDTOtherBankModel:model]) {
        [CNRechargeRequest submitOnlinePayOrderV2Amount:amount
                                               currency:model.currency
                                           usdtProtocol:@"ERC20"
                                                payType:model.payType
                                                handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] retelling:nil type:ChargeMsgTypeOTHERS];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
        
    } else {
        [CNRechargeRequest submitOnlinePayOrderAmount:amount
                                             currency:model.currency
                                         usdtProtocol:@"ERC20"
                                              payType:model.payType
                                                payid:self.curOnliBankModel.payid
                                           showQRCode:1
                                              handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"payUrl"] retelling:nil type:[HYRechargeHelper isUSDTOtherBankModel:model]?ChargeMsgTypeOTHERS:ChargeMsgTypeDCBOX];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
    }
}


@end
