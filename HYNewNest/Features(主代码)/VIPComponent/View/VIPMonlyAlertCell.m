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
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *topSubLb;
@property (nonatomic, strong) UIImageView *rankImgv;
@property (nonatomic, strong) UIButton *btmButton;
@property (nonatomic, strong) UILabel *btmColorLb;
@property (nonatomic, weak) id<VIPMonlyAlertDelegate> delegate;
@end

@implementation VIPMonlyAlertCell

- (void)initUI {
    [super initUI];
    
    //设置通用UI
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kHexColor(0xF2EDEA);
    [bgView addCornerAndShadow];
    bgView.frame = self.contentView.bounds;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UIImage *img = [UIImage imageNamed:@"编组 21"];
    UIImageView *topTitleBg = [[UIImageView alloc] initWithImage:img];
    topTitleBg.frame = CGRectMake((self.contentView.width-img.size.width)*0.5, AD(22), img.size.width,img.size.height);
    [self.bgView addSubview:topTitleBg];
    
    UILabel *topTitleLb = [[UILabel alloc] init];
    topTitleLb.text = [NSString stringWithFormat:@"私享会%lu月报", (unsigned long)[NSDate jk_month:[NSDate date]]];
    topTitleLb.textColor = kHexColor(0xB27F48);
    topTitleLb.font = [UIFont fontPFSB16];
    topTitleLb.textAlignment = NSTextAlignmentCenter;
    topTitleLb.frame = CGRectMake(0, AD(14), self.contentView.width, AD(22));
    [self.bgView addSubview:topTitleLb];
    
    UILabel *topSubLb = [[UILabel alloc] init];
    topSubLb.text = @"( 5月累计入会500名,祝贺他们! ) ";
    topSubLb.font = [UIFont fontPFR12];
    topSubLb.textAlignment = NSTextAlignmentCenter;
    topSubLb.frame = CGRectMake(0, topTitleLb.bottom+AD(2), self.contentView.width, AD(17));
    topSubLb.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:topSubLb];
    self.topSubLb = topSubLb;
    
    UIImage *rankImg = [UIImage imageNamed:@"位图"];
    UIImageView *centerRankImgv = [[UIImageView alloc] initWithImage:rankImg];
    centerRankImgv.contentMode = UIViewContentModeScaleAspectFit;
    centerRankImgv.frame = CGRectMake(0, topSubLb.bottom+AD(10), self.bgView.width, AD(81));
    [self.bgView addSubview:centerRankImgv];
    self.rankImgv = centerRankImgv;
    
    UILabel *btmColorLb = [[UILabel alloc] init];
    btmColorLb.font = [UIFont fontPFM14];
    btmColorLb.textColor = kHexColor(0x8F1C34);
    btmColorLb.numberOfLines = 2;
    btmColorLb.textAlignment = NSTextAlignmentCenter;
    btmColorLb.frame = CGRectMake(0, self.rankImgv.bottom+AD(6), self.contentView.width, AD(40));
    btmColorLb.text = @"齐齐哈尔王会员荣膺“赌尊”\n(流水120,340usdt-充值120,540usdt)";
    [self.contentView addSubview:btmColorLb];
    self.btmColorLb = btmColorLb;
    
    UIButton *btmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    btmBtn.titleLabel.font = [UIFont fontPFSB16];
    [btmBtn setTitle:@"get" forState:UIControlStateNormal];
    [btmBtn addTarget:self action:@selector(didTapBtmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btmBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
    btmBtn.layer.cornerRadius = AD(5);
    btmBtn.layer.masksToBounds = YES;
    btmBtn.y = self.bgView.bottom + AD(10);
    btmBtn.x = (self.contentView.width - AD(137)) * 0.5;
    btmBtn.size = CGSizeMake(AD(137), AD(40));
    [btmBtn setBackgroundColor:kHexColor(0xCFA461)];
    [self.contentView addSubview:btmBtn];
    self.btmButton = btmBtn;
}

- (void)setupAlertType:(VIPMonlyAlertType)type delegate:(id)delegate dataDict:(NSDictionary *)dict {
    _alertType = type;
    self.delegate = delegate;
    
    switch (type) {
        case VIPMonlyAlertTypeCondition: {
            self.bgView.height = AD(284);
            self.btmButton.hidden = YES;
            
            self.topSubLb.text = @"( 5月累计入会500名,祝贺他们! ) ";//exp
            self.rankImgv.hidden = NO;
            self.btmColorLb.text = @"齐齐哈尔王会员荣膺“赌尊”\n(流水120,340usdt-充值120,540usdt)";//exp
            
            UIView *framk = [UIView new];
            framk.backgroundColor = [UIColor clearColor];
            framk.frame = CGRectMake(AD(21), self.btmColorLb.bottom+AD(20), AD(273), AD(57));
            framk.layer.borderColor = kHexColor(0xA36B27).CGColor;
            framk.layer.borderWidth = 1;
            [self.contentView addSubview:framk];
            
            // 入会情况
            CGFloat cLeft = AD(18);
            CGFloat cMargin = AD(30);
            CGFloat cWidth = AD(24);
            NSArray *numArr = @[@2, @24, @3, @15, @6];//exp
            for (int i=0; i<5; i++) {
                UILabel *rank = [UILabel new];
                rank.font = [UIFont fontPFR12];
                rank.textAlignment = NSTextAlignmentCenter;
                rank.textColor = kHexColor(0x884C0C);
                rank.frame = CGRectMake(cLeft + (cMargin+cWidth)*i, AD(31.5), cWidth, AD(12));
                [framk addSubview:rank];
                switch (i) {
                    case 0: rank.text = @"赌神"; break;
                    case 1: rank.text = @"赌圣"; break;
                    case 2: rank.text = @"赌王"; break;
                    case 3: rank.text = @"赌霸"; break;
                    case 4: rank.text = @"赌侠"; break;
                    default: break;
                }
                UILabel *num = [UILabel new];
                num.text = [numArr[i] stringValue];
                num.textAlignment = NSTextAlignmentCenter;
                num.font = [UIFont fontDBOfMIDSMALLSize];
                num.textColor = kHexColor(0x884C0C);
                [num sizeToFit];
                num.x = rank.x;
                num.width = rank.width;
                num.bottom = rank.top - AD(4);
                [framk addSubview:num];
                if (i != 4) {
                    UIView *line = [UIView new];
                    line.frame = CGRectMake(rank.right + AD(14), AD(24), 1, AD(12));
                    line.backgroundColor = kHexColor(0x935717);
                    line.alpha = 0.25;
                    [framk addSubview:line];
                }
            }
            
            break;
        }
            
        case VIPMonlyAlertTypeValue: {
            self.bgView.height = AD(267);
            self.btmButton.hidden = NO;
            self.btmButton.y = self.bgView.bottom + AD(10);
            [self.btmButton setTitle:@"关闭" forState:UIControlStateNormal];
            
            self.topSubLb.text = @"";
            self.rankImgv.hidden = YES;
            self.btmColorLb.hidden = YES;
            
            // 绘制表格
            NSArray *leftText = @[@"入会礼金",@"月度分红",@"至尊转盘",@"累计身份",@"累计送出"];
            NSArray *rightNum = @[@"5,588usdt",@"308usdt",@"15次",@"123,123,120usdt",@"123,123,120usdt"]; //exp
            // 线的路径 横线
            for (int i=0; i<6; i++) {
                UIBezierPath *linePath = [UIBezierPath bezierPath];
                [linePath moveToPoint:CGPointMake(AD(21), AD(47)+AD(36)*i)];
                [linePath addLineToPoint:CGPointMake(self.bgView.width-AD(21), AD(47)+AD(36)*i)];
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.lineWidth = 1;
                lineLayer.strokeColor = kHexColor(0xA36B27).CGColor;
                lineLayer.path = linePath.CGPath;
                lineLayer.fillColor = nil; // 默认为blackColor
                [self.bgView.layer addSublayer:lineLayer];
            }
            // 线的路径 竖线
            for (int i=0; i<3; i++) {
                UIBezierPath *linePath = [UIBezierPath bezierPath];
                [linePath moveToPoint:CGPointMake(AD(21)+i*AD(137), AD(47))];
                [linePath addLineToPoint:CGPointMake(AD(21)+i*AD(137), AD(47)+AD(36)*5)];
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.lineWidth = 1;
                lineLayer.strokeColor = kHexColor(0xA36B27).CGColor;
                lineLayer.path = linePath.CGPath;
                lineLayer.fillColor = nil; // 默认为blackColor
                [self.bgView.layer addSublayer:lineLayer];
            }
            // 文字
            for (int i=0; i<5; i++) { //hang
                for (int j=0; j<2; j++) { //lie
                    UILabel *lb = [UILabel new];
                    lb.frame = CGRectMake(AD(21) + j*AD(137), AD(47) + i*AD(35+1), AD(137), AD(35));
                    lb.textAlignment = NSTextAlignmentCenter;
                    lb.textColor = kHexColor(0x884C0C);
                    lb.font = [UIFont fontPFR13];
                    lb.text = j==0 ? (leftText[i]) : (rightNum[i]);
                    [self.bgView addSubview:lb];
                }
            }
            
            UILabel *btmLb = [[UILabel alloc] init];
            btmLb.font = [UIFont fontPFR14];
            btmLb.textColor = kHexColor(0x884C0C);
            btmLb.textAlignment = NSTextAlignmentCenter;
            btmLb.text = @"播报结束,小游祝您月月赢大钱,次次中大奖";
            [btmLb sizeToFit];
            btmLb.x = 0;
            btmLb.bottom = self.bgView.height - AD(11);
            btmLb.width = self.bgView.width;
            [self.bgView addSubview:btmLb];
            
            break;
        }
    
        case VIPMonlyAlertTypePersonal: {
            self.bgView.height = AD(237);
            self.btmButton.hidden = NO;
            self.btmButton.y = self.bgView.bottom + AD(10);
            
            self.topSubLb.text = @"( 您的战绩：流水120,000usdt-充值345,467usdt )";//exp
            
            self.rankImgv.hidden = NO;
            self.rankImgv.contentMode = UIViewContentModeCenter;
            self.rankImgv.y = self.topSubLb.bottom + 5;
            self.rankImgv.height = 123;
            
            self.btmColorLb.hidden = NO;
            
            BOOL isCanRank = NO; //exp
            if (isCanRank) {
                self.rankImgv.image = [UIImage imageNamed:@"编组 7备份 2"];//exp
                self.btmColorLb.text = @"恭喜您荣膺赌尊\n小游送你入会礼金9,888usdt";//exp
                [self.btmButton setTitle:@"领取" forState:UIControlStateNormal];
            } else {
                self.rankImgv.image = [UIImage imageNamed:@"yuebaonone"];
                self.btmColorLb.text = @"您还未达到入会等级\n请再接再励哦~";
                [self.btmButton setTitle:@"看看月报" forState:UIControlStateNormal];
            }
            self.btmColorLb.y = self.rankImgv.bottom + 5;
            
            break;
        }
        default:
            break;
    }
}



#pragma mark - ACTION
- (void)didTapBtmBtn:(UIButton *)btn {
    switch (self.alertType) {
            
        case VIPMonlyAlertTypeValue:
            MyLog(@"关闭");
            if(self.delegate && [self.delegate respondsToSelector:@selector(didTapNextOne)]) {
                [self.delegate didTapNextOne];
            }
            break;
            
        case VIPMonlyAlertTypePersonal:
            if ([btn.titleLabel.text isEqualToString:@"看看月报"]) {
                MyLog(@"kk yuebao");
                if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMonthlyReport)]) {
                    [self.delegate didTapMonthlyReport];
                }
            } else if ([btn.titleLabel.text isEqualToString:@"领取"]) {
                MyLog(@"ling qu");
                if(self.delegate && [self.delegate respondsToSelector:@selector(didTapReceiveGift)]) {
                    [self.delegate didTapReceiveGift];
                }
            }
            break;
            
        default:
            break;
    }
}

@end
