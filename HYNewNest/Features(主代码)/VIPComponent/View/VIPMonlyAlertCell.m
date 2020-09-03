//
//  VIPMonlyAlertCell.m
//  HYNewNest
//
//  Created by zaky on 9/3/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPMonlyAlertCell.h"

@interface VIPMonlyAlertCell ()
@property (assign, nonatomic) VIPMonlyAlertType alertType;
@property (nonatomic, strong) UILabel *topSubLb;
@property (nonatomic, strong) UIImageView *rankImgv;
@end

@implementation VIPMonlyAlertCell

- (void)initUI {
    [super initUI];
    
    //TODO: 设置通用UI
    self.contentView.backgroundColor = kHexColor(0xF2EDEA);
    
    UIImage *img = [UIImage imageNamed:@"编组 21"];
    UIImageView *topTitleBg = [[UIImageView alloc] initWithImage:img];
    topTitleBg.frame = CGRectMake((self.contentView.width-img.size.width)*0.5, AD(22), img.size.width,img.size.height);
    [self.contentView addSubview:topTitleBg];
    
    UILabel *topTitleLb = [[UILabel alloc] init];
    topTitleLb.text = [NSString stringWithFormat:@"私享会%lu月报", (unsigned long)[NSDate jk_month:[NSDate date]]];
    topTitleLb.textColor = kHexColor(0xB27F48);
    topTitleLb.font = [UIFont fontPFSB16];
    topTitleLb.textAlignment = NSTextAlignmentCenter;
    topTitleLb.frame = CGRectMake(0, AD(14), self.contentView.width, AD(22));
    [self.contentView addSubview:topTitleLb];
    
    UILabel *topSubLb = [[UILabel alloc] init];
    topSubLb.text = @"( 5月累计入会500名,祝贺他们! ) ";//examp
    topSubLb.font = [UIFont fontPFR12];
    topSubLb.textAlignment = NSTextAlignmentCenter;
    topSubLb.frame = CGRectMake(0, topTitleLb.bottom+AD(2), self.contentView.width, AD(17));
    topSubLb.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:topSubLb];
    self.topSubLb = topSubLb;
    
    UIImage *rankImg = [UIImage imageNamed:@"位图"];//examp
    UIImageView *centerRankImgv = [[UIImageView alloc] initWithImage:rankImg];
    centerRankImgv.frame = CGRectMake(AD(96), topSubLb.bottom + AD(2), AD(123), AD(123));
    [self.contentView addSubview:centerRankImgv];
    self.rankImgv = centerRankImgv;
    
}

- (void)setupAlertType:(VIPMonlyAlertType)type AndDataDict:(NSDictionary *)dict {
    _alertType = type;
    
    switch (type) {
        case VIPMonlyAlertTypeCondition:
            
            break;
            
        case VIPMonlyAlertTypeValue:
            
            break;
            
        case VIPMonlyAlertTypePersonal:{
            
            self.topSubLb.text = @"( 您的战绩：流水120,000usdt-充值345,467usdt )";
            
            UILabel *btmColorLb = [[UILabel alloc] init];
            btmColorLb.font = [UIFont fontPFM14];
            btmColorLb.textColor = kHexColor(0x8F1C34);
            btmColorLb.numberOfLines = 2;
            btmColorLb.textAlignment = NSTextAlignmentCenter;
            btmColorLb.frame = CGRectMake(0, self.rankImgv.bottom, self.contentView.width, AD(40));
            btmColorLb.text = @"恭喜您荣膺赌尊\n小游送你入会礼金9,888usdt";//exam
            [self.contentView addSubview:btmColorLb];
            break;
        }
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
