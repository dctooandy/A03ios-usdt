//
//  DSBRchrWthdrwHeader.m
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRchrWthdrwHeader.h"
#import "DXRadianLayerView.h"
#import "UILabel+Gradient.h"
#import "BYDashenBoardConst.h"
#import "VIPRankGradientTxtLabel.h"
#import <UIImageView+WebCache.h>

@interface DSBRchrWthdrwHeader()

@property (weak, nonatomic) IBOutlet DXRadianLayerView *radianBgView;
@property (weak, nonatomic) IBOutlet UIImageView *championImv;
@property (weak, nonatomic) IBOutlet UILabel *championUsrLb;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *championRankLb;
@property (weak, nonatomic) IBOutlet UILabel *championAmoLb;
@property (weak, nonatomic) IBOutlet UILabel *championTimeLb;

@property (weak, nonatomic) IBOutlet UIImageView *silverImv;
@property (weak, nonatomic) IBOutlet UILabel *silverUsrLb;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *silverRankLb;
@property (weak, nonatomic) IBOutlet UILabel *silverAmoLb;
@property (weak, nonatomic) IBOutlet UILabel *silverTimeLb;

@property (weak, nonatomic) IBOutlet UIImageView *copperImv;
@property (weak, nonatomic) IBOutlet UILabel *copperUsrLb;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *copperRankLb;
@property (weak, nonatomic) IBOutlet UILabel *copperAmoLb;
@property (weak, nonatomic) IBOutlet UILabel *copperTimeLb;


@end

@implementation DSBRchrWthdrwHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = kHexColor(0x1C1B34);
        bg;
    });
    
    // 圆边背景
    self.radianBgView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x1B2240) toColor:kHexColor(0x1A2840) withHeight:208];//kHexColor(0x1A2540)
    self.radianBgView.radian = 40;
    
    // 渐变金额
    [self.championAmoLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kVIPColor1 toColor:kVIPColor2];
    [self.silverAmoLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kVIPColor1 toColor:kVIPColor2];
    [self.copperAmoLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kVIPColor1 toColor:kVIPColor2];
    
}


- (void)setup123DataArr:(NSArray<DSBRecharWithdrwUsrModel *> *)arr {
    if (arr.count < 3) {
        return;
    }
    DSBRecharWithdrwUsrModel *firstmodel = arr[0];
    [_championImv sd_setImageWithURL:[NSURL URLWithString:firstmodel.headshot] placeholderImage:[UIImage imageNamed:@"icon"]];
    _championAmoLb.text = [firstmodel.totalAmount jk_toDisplayNumberWithDigit:0];
    _championUsrLb.text = firstmodel.loginName;
    _championRankLb.text = firstmodel.writtenLevel;
    _championTimeLb.text = firstmodel.writtenTime;
    
    DSBRecharWithdrwUsrModel *secondmodel = arr[1];
    [_silverImv sd_setImageWithURL:[NSURL URLWithString:secondmodel.headshot] placeholderImage:[UIImage imageNamed:@"icon"]];
    _silverAmoLb.text = [secondmodel.totalAmount jk_toDisplayNumberWithDigit:0];
    _silverUsrLb.text = secondmodel.loginName;
    _silverRankLb.text = secondmodel.writtenLevel;
    _silverTimeLb.text = secondmodel.writtenTime;
    
    DSBRecharWithdrwUsrModel *thirdmodel = arr[2];
    [_copperImv sd_setImageWithURL:[NSURL URLWithString:thirdmodel.headshot] placeholderImage:[UIImage imageNamed:@"icon"]];
    _copperAmoLb.text = [thirdmodel.totalAmount jk_toDisplayNumberWithDigit:0];
    _copperUsrLb.text = thirdmodel.loginName;
    _copperRankLb.text = thirdmodel.writtenLevel;
    _copperTimeLb.text = thirdmodel.writtenTime;
    
    
}



@end
