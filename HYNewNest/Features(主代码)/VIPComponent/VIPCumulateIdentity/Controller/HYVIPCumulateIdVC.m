//
//  HYVIPCumulateIdVC.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPCumulateIdVC.h"
#import "VIPCumulateIdCell.h"
#import "VIPCumulateIdHeader.h"
#import "HYVIPRuleAlertView.h"
#import "CNVIPRequest.h"
#import "HYVIPReceiveAlertView.h"
#import "WSLPictureBrowseView.h"

static NSString * const CUMIDCELL = @"VIPCumulateIdCell";
static NSString * const CUMIDHEADER = @"VIPCumulateIdHeader";

@interface HYVIPCumulateIdVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnRule;
// 选中身份标示
@property (nonatomic, assign) NSInteger selIdx;
/// 累计身份
@property (weak, nonatomic) IBOutlet UIStackView *stackViewLJSF;
@property (weak, nonatomic) IBOutlet UIView *viewLJSF;
@property (weak, nonatomic) IBOutlet UILabel *lblDuzunNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuGodNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuSaintNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuKingNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuBaNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuXiaNum;
@property (weak, nonatomic) IBOutlet UILabel *lblPlsLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 数据
@property (strong, nonatomic) HistoryBet *historyBet;
@property (strong, nonatomic) NSDictionary *giftListDict;
@property (strong, nonatomic) NSDictionary *rankNameLevel;
@end

@implementation HYVIPCumulateIdVC

- (NSDictionary *)rankNameLevel {
    if (!_rankNameLevel) {
        _rankNameLevel = @{@"赌尊":@7,@"赌神":@6,@"赌圣":@5,@"赌王":@4,@"赌霸":@3,@"赌侠":@2};
    }
    return _rankNameLevel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _selIdx = [self.rankNameLevel[@"赌尊"] integerValue];//默认赌尊
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([CNUserManager shareManager].isLogin) {
        _stackViewLJSF.hidden = NO;
        _btnLogin.hidden = YES;
        _lblPlsLogin.hidden = YES;
        
    } else {
        _stackViewLJSF.hidden = YES;
        _btnLogin.hidden = NO;
        _lblPlsLogin.hidden = NO;
    }
    [self vipIdentityData];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navBarTransparent = YES;
    self.makeTranslucent = YES;
    
    self.view.backgroundColor = _tableView.backgroundColor =  kHexColor(0x181514);
    
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 37) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = cornerPath.CGPath;
    layer.fillColor = [UIColor gradientColorImageFromColors:@[kHexColor(0xF5E693), kHexColor(0x6D542A)]
                                               gradientType:GradientTypeLeftToRight
                                                    imgSize:CGSizeMake(45, 37)].CGColor;
    [_btnRule.layer addSublayer:layer];
    
    _viewLJSF.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0xE1DED1) toColor:kHexColor(0x817C6D) withHeight:70];
    _viewLJSF.layer.borderColor = [UIColor jk_gradientFromColor:kHexColor(0x71572C) toColor:kHexColor(0xCCAD5D) withHeight:70].CGColor;
    _viewLJSF.layer.borderWidth = 1;
    
    [_tableView registerNib:[UINib nibWithNibName:CUMIDCELL bundle:nil] forCellReuseIdentifier:CUMIDCELL];
    [_tableView registerNib:[UINib nibWithNibName:CUMIDHEADER bundle:nil] forHeaderFooterViewReuseIdentifier:CUMIDHEADER];
}

- (void)setupUIDatas {
    _lblDuXiaNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betXiaCount];
    _lblDuBaNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betBaCount];
    _lblDuKingNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betKingCount];
    _lblDuSaintNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betSaintCount];
    _lblDuGodNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betGoldCount];
    _lblDuzunNum.text = [NSString stringWithFormat:@"%ld", (long)self.historyBet.betZunCount];
}


#pragma mark - Request
- (void)vipIdentityData {

    [CNVIPRequest vipsxhCumulateIdentityHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObj allKeys] containsObject:@"identityList"]) {
                NSDictionary *dict = responseObj[@"identityList"];
                NSMutableDictionary *newDict = @{}.mutableCopy;
                for (int i=2; i<8; i++) {
                    NSArray *models = [VIPIdentityModel cn_parse:dict[[NSString stringWithFormat:@"%d", i]]];
                    newDict[@(i)] = models;
                }
                self.giftListDict = newDict;
                [self.tableView reloadData];
            }
            
            if ([[responseObj allKeys] containsObject:@"historyBet"]) {
                self.historyBet = [HistoryBet cn_parse:responseObj[@"historyBet"]];
                [self setupUIDatas];
            }
        }
    }];
}


#pragma mark - ACTION
- (IBAction)didTapRuleBtn:(id)sender {
    [HYVIPRuleAlertView showCumulateIdentityRule];
}

- (IBAction)didTapLoginBtn:(id)sender {
    [NNPageRouter jump2Login];
}

- (IBAction)didTapReceiveRecord:(id)sender {
    MyLog(@"RECEIVE RECORD");
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.giftListDict) {
        return [self.giftListDict[@(_selIdx)] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VIPCumulateIdCell *cell = [tableView dequeueReusableCellWithIdentifier:CUMIDCELL];
    __block VIPIdentityModel *model = self.giftListDict[@(_selIdx)][indexPath.row];
    cell.model = model;
    
    WEAKSELF_DEFINE
    cell.receivedBlcok = ^{
        NSInteger count = weakSelf.historyBet.betBaCount + weakSelf.historyBet.betXiaCount + weakSelf.historyBet.betZunCount + weakSelf.historyBet.betGoldCount + weakSelf.historyBet.betKingCount + weakSelf.historyBet.betSaintCount;
        [HYVIPReceiveAlertView showReceiveAlertTimes:count gift:model comfirmHandler:^(BOOL isComfirm) {

            if (isComfirm) {
                // 领取
                [CNVIPRequest vipsxhApplyCumulateIdentityPrize:@(model.prizeId) handler:^(id responseObj, NSString *errorMsg) {
                    STRONGSELF_DEFINE
                    if (!errorMsg) {
                        [strongSelf vipIdentityData];
                    }
                }];
            }
        }];
        
    };
    
    cell.expandBlcok = ^(VIPCumulateIdCell *c ,UIImageView *imgv){
        STRONGSELF_DEFINE
        // 自己做的破转场动画
        UIImageView *animImgv = [[UIImageView alloc] initWithImage:imgv.image];
        animImgv.clipsToBounds = YES;
        animImgv.jk_origin = [self.view convertPoint:imgv.jk_origin fromView:c];
        animImgv.size = imgv.size;
        __block CGRect orgRect = animImgv.frame;
        animImgv.contentMode = UIViewContentModeScaleAspectFill;
        [strongSelf.view addSubview:animImgv];
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat imgH = kScreenWidth *  imgv.image.size.height / imgv.image.size.width;
            animImgv.frame = CGRectMake(0, (kScreenHeight-imgH)*0.5, kScreenWidth, imgH);
            
        } completion:^(BOOL finished) {
            WSLPictureBrowseView * browseView = [[WSLPictureBrowseView alloc] initWithTitle:model.title content:model.introduce urlArray:@[model.prizeUrl]];
            browseView.orgnRect = orgRect;
            browseView.viewController = self;
            [strongSelf.view addSubview:browseView];
            [strongSelf.navigationController setNavigationBarHidden:YES animated:YES];
            
            [animImgv removeFromSuperview];
        }];
        

        
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VIPCumulateIdHeader *header = (VIPCumulateIdHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CUMIDHEADER];
    header.didTapBtnBlock = ^(NSString * _Nonnull rankName) {
        self.selIdx = [self.rankNameLevel[rankName] integerValue];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
    return header;
}


@end
