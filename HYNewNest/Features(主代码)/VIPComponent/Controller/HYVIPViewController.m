//
//  HYVIPViewController.m
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPViewController.h"
#import "UILabel+Gradient.h"
#import "DXRadianLayerView.h"
#import "UUMarqueeView.h"

@interface HYVIPViewController ()
// 顶部背景
@property (weak, nonatomic) IBOutlet DXRadianLayerView *topRadianView;
// 底部背景
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
// vip私享会2.0
@property (weak, nonatomic) IBOutlet UILabel *sxhTopLb;

// -------- 顶部卡片 --------
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCard;


// -------- 大奖公告 --------
@property (weak, nonatomic) IBOutlet UILabel *lblDjgg;
// TODO: 获奖轮播

// -------- 本月进度 --------
@property (weak, nonatomic) IBOutlet UIView *ByjdTopBg;
@property (weak, nonatomic) IBOutlet UILabel *lblByjd;
@property (weak, nonatomic) IBOutlet UIView *ByjdBtmBg;

// 本月流水
@property (weak, nonatomic) IBOutlet UILabel *lblThisMonthAmount;
// 下一等级流水
@property (weak, nonatomic) IBOutlet UILabel *lblNextLevelAmount;
// 流水进度条
@property (weak, nonatomic) IBOutlet UIProgressView *prgsViewAmount;

// 本月充值
@property (weak, nonatomic) IBOutlet UILabel *lblThisMonthDeposit;
// 下一等级充值
@property (weak, nonatomic) IBOutlet UILabel *lblNextLevelDeposit;
// 存款进度条
@property (weak, nonatomic) IBOutlet UIProgressView *prgsViewDeposit;

// 累计身份
@property (weak, nonatomic) IBOutlet UILabel *lbDuzunTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushenTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushengTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuwangTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDubaTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuxiaTime;

// -------- 两个按钮 --------
// 至尊转盘
@property (weak, nonatomic) IBOutlet UIView *ZzzpBg;
// 累计身份
@property (weak, nonatomic) IBOutlet UIView *LjsfBg;

@end

@implementation HYVIPViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIAttributes];
    
}


#pragma mark - Custom Func
- (void)setupUIAttributes {
    self.hideNavgation = YES;
    
    self.topRadianView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x0F2129) toColor:kHexColor(0x0C2928) withHeight:self.topRadianView.height];
    self.topRadianView.radian = 12;
    
    [self.sxhTopLb setupGradientColorFrom:kHexColor(0xFFEFCB) toColor:kHexColor(0xA28455)];
    
    self.bottomBgView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x0A1D25) toColor:kHexColor(0x070D17) withHeight:self.bottomBgView.height];
    
    [self.ByjdTopBg jk_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:4];
    self.ByjdTopBg.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0xE4D8B4) toColor:kHexColor(0xC3A370) withHeight:40];
    
    self.ByjdBtmBg.backgroundColor = self.LjsfBg.backgroundColor = self.ZzzpBg.backgroundColor = kHexColor(0x212730);
    [self.ByjdBtmBg jk_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:4];
    [self.LjsfBg jk_setRoundedCorners:UIRectCornerAllCorners radius:4];
    [self.ZzzpBg jk_setRoundedCorners:UIRectCornerAllCorners radius:4];
    
}


#pragma mark - Action
- (IBAction)didTapDashenBoard:(id)sender {
    MyLog(@"大神吧");
}

- (IBAction)didTapMoreRights:(id)sender {
    MyLog(@"更多特权");
}

- (IBAction)didTapZZZP:(id)sender {
    MyLog(@"至尊转盘");
}

- (IBAction)didTapLJSF:(id)sender {
    MyLog(@"累计身份");
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
