//
//  DSBRchrWthdrwHeader.m
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRchrWthdrwHeader.h"
#import "DXRadianLayerView.h"

@interface DSBRchrWthdrwHeader()

@property (weak, nonatomic) IBOutlet DXRadianLayerView *radianBgView;
@property (weak, nonatomic) IBOutlet UIImageView *championImv;
@property (weak, nonatomic) IBOutlet UILabel *championUsrLb;
@property (weak, nonatomic) IBOutlet UILabel *championRankLb;
@property (weak, nonatomic) IBOutlet UILabel *championAmoLb;
@property (weak, nonatomic) IBOutlet UILabel *championTimeLb;

@property (weak, nonatomic) IBOutlet UIImageView *silverImv;
@property (weak, nonatomic) IBOutlet UILabel *silverUsrLb;
@property (weak, nonatomic) IBOutlet UILabel *silverRankLb;
@property (weak, nonatomic) IBOutlet UILabel *silverAmoLb;
@property (weak, nonatomic) IBOutlet UILabel *silverTimeLb;

@property (weak, nonatomic) IBOutlet UIImageView *copperImv;
@property (weak, nonatomic) IBOutlet UILabel *copperUsrLb;
@property (weak, nonatomic) IBOutlet UILabel *copperRankLb;
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
    
    self.radianBgView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x1B2240) toColor:kHexColor(0x1A2840) withHeight:208];//kHexColor(0x1A2540)
    self.radianBgView.radian = 40;
    
}




@end
