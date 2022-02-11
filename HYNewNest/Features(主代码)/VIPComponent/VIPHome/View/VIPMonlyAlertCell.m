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
@property (nonatomic, strong) UILabel *btmColorTopLb;
@property (nonatomic, strong) UILabel *btmColorLb;
@property (nonatomic, weak) id<VIPMonlyAlertDelegate> actionDelegate;
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
    topTitleLb.text = [NSString stringWithFormat:@"私享会%lu月报", (unsigned long)[NSDate jk_month:[NSDate date]]-1];
    topTitleLb.textColor = kHexColor(0xB27F48);
    topTitleLb.font = [UIFont fontPFSB16];
    topTitleLb.textAlignment = NSTextAlignmentCenter;
    topTitleLb.frame = CGRectMake(0, AD(14), self.contentView.width, AD(22));
    [self.bgView addSubview:topTitleLb];
    
    UILabel *topSubLb = [[UILabel alloc] init];
    topSubLb.text = @"( 上月累计入会0名,祝贺他们! ) ";
    topSubLb.textColor = kHexColor(0x000000);
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
    
    UILabel *btmColorTopLb = [[UILabel alloc] init];
    btmColorTopLb.font = [UIFont fontPFM16];
    btmColorTopLb.textColor = [UIColor redColor];
    btmColorTopLb.numberOfLines = 1;
    btmColorTopLb.textAlignment = NSTextAlignmentCenter;
    btmColorTopLb.frame = CGRectMake(0, self.rankImgv.bottom+AD(6), self.contentView.width, AD(20));
    btmColorTopLb.text = @"恭喜您荣膺";
    [btmColorTopLb setHidden:YES];
    [self.contentView addSubview:btmColorTopLb];
    self.btmColorTopLb = btmColorTopLb;
    [self.btmColorTopLb setHidden:YES];
    
    UILabel *btmColorLb = [[UILabel alloc] init];
    btmColorLb.font = [UIFont fontPFM14];
    btmColorLb.textColor = kHexColor(0x8F1C34);
    btmColorLb.numberOfLines = 2;
    btmColorLb.textAlignment = NSTextAlignmentCenter;
    btmColorLb.frame = CGRectMake(0, self.rankImgv.bottom+AD(6), self.contentView.width, AD(40));
    btmColorLb.text = @"齐齐哈尔王会员荣膺“赌尊”\n(流水120,340CNY-充值120,540CNY)";
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

- (void)setupAlertType:(VIPMonlyAlertType)type delegate:(id)delegate dataDict:(VIPMonthlyModel *)model {
    _alertType = type;
    self.actionDelegate = delegate;
    
    switch (type) {
        case VIPMonlyAlertTypeCondition: {
            self.bgView.height = AD(284);
            self.btmButton.hidden = YES;
            
            if (model.vipRhqk) {
                self.topSubLb.text = [NSString stringWithFormat:@"( %ld月累计入会%ld名,祝贺他们! ) ",(long)model.lastMonth , model.vipRhqk.betCount];
                self.rankImgv.hidden = NO;
                // 疑问
                // vipRhqk.betAmount 流水
                // vipRhqk.depositAmount 充值
                // 不确定API回吐的是CNY还是USDT
                [self.btmColorTopLb setHidden:YES];
                self.btmColorLb.text = [NSString stringWithFormat:@"%@ 会员荣膺“赌尊”\n(流水%@CNY-充值%@CNY)",
                                        model.vipRhqk.betZunName,
                                        [model.vipRhqk.betCNYAmount jk_toDisplayNumberWithDigit:0],
                                        [model.vipRhqk.depositCNYAmount jk_toDisplayNumberWithDigit:0]];
            }
            
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
            NSArray *numArr;
            if (model.vipRhqk && model.vipRhqk.betGoldCount) {
                numArr = @[model.vipRhqk.betGoldCount, model.vipRhqk.betSaintCount, model.vipRhqk.betKingCount, model.vipRhqk.betBaCount, model.vipRhqk.betXiaCount];
            } else {
                numArr = @[@0,@0,@0,@0,@0];
            }
             
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
                num.centerX = rank.centerX;
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
            [self.btmColorTopLb setHidden:YES];
            // 绘制表格
            NSArray *leftText = @[@"入会礼金",@"月度分红",@"至尊转盘",@"累计身份",@"累计送出"];
            NSArray *rightNum;
            if (model.vipScjz) {
                // 疑问
                // vipScjz.rhlj 入会礼金
                // vipScjz.ydfh 月度分红
                // vipScjz.ljsf 累计身份
                // vipScjz.ljsc 累计送出
                // 不确定API回吐的是CNY还是USDT
                rightNum = @[[[model.vipScjz.rhljCNY jk_toDisplayNumberWithDigit:0] stringByAppendingString:@" CNY"],
                             [[model.vipScjz.ydfhCNY jk_toDisplayNumberWithDigit:0] stringByAppendingString:@" CNY"],
                             [[model.vipScjz.zzzp jk_toDisplayNumberWithDigit:0] stringByAppendingString:@" 次"],
                             [[model.vipScjz.ljsfCNY jk_toDisplayNumberWithDigit:0] stringByAppendingString:@" CNY"],
                             [[model.vipScjz.ljscCNY jk_toDisplayNumberWithDigit:0] stringByAppendingString:@" CNY"]];
            } else {
                rightNum = @[@"0 CNY",@"0 CNY",@"0 CNY",@"0 CNY",@"0 CNY"];
            }
            
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
            btmLb.text = @"播报结束, 小游祝您月月赢大钱, 次次中大奖";
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
            // 疑问
            // totalBetAmount 流水
            // totalDepositAmount 充值
            // 不确定API回吐的是CNY还是USDT
            self.topSubLb.text = [NSString stringWithFormat:@"( 您的战绩：流水%@CNY-充值%@CNY )", [model.totalBetCNYAmount jk_toDisplayNumberWithDigit:0], [model.totalDepositCNYAmount jk_toDisplayNumberWithDigit:0]];
            
            self.rankImgv.hidden = NO;
            self.rankImgv.contentMode = UIViewContentModeCenter;
            self.rankImgv.y = self.topSubLb.bottom + 5;
            self.rankImgv.height = 123;
            
            self.btmColorLb.hidden = NO;
            
            BOOL isCanRank = model.clubLevel && [@[@2,@3,@4,@5,@6,@7] containsObject:model.clubLevel];
            // 私享会测试用
//            BOOL isDev = YES;
//            if (isDev == YES)
//            {
//                isCanRank = YES;
//                model.betName = @"食神";
//                model.preRequest = @{@"amount":@"9888"};
//                model.clubLevel = @2;
//            }
            if (isCanRank) {
                [self.btmColorTopLb setHidden:NO];
                self.rankImgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@", model.clubLevel]];
                self.btmColorTopLb.text = [NSString stringWithFormat:@"恭喜您荣膺%@\n",
                                           model.betName];
                NSString *preRequestAmountCNYString = @"";
                NSString *preRequestAmountUSDTString = @"";
                if (model.preRequest)
                {
                    preRequestAmountUSDTString = model.preRequest[@"amount"];
                    preRequestAmountCNYString = [NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:([model.preRequest[@"amount"] floatValue] * 7)] jk_toDisplayNumberWithDigit:0]];
                }
                self.btmColorLb.text = [NSString stringWithFormat:@"小游送你入会礼金\n%@ CNY(等值%@ USDT)",
                                        preRequestAmountCNYString,
                                        preRequestAmountUSDTString];
                //12/17 需求: 下方使用双币种显示 , 文案改为上下排版
                [self.btmButton setTitle:@"领取" forState:UIControlStateNormal];
                if (!model.preRequest) self.btmButton.enabled = NO;
            } else {
                [self.btmColorTopLb setHidden:YES];
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
            if(self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didTapNextOne)]) {
                [self.actionDelegate didTapNextOne];
            }
            break;
            
        case VIPMonlyAlertTypePersonal:
            if ([btn.titleLabel.text isEqualToString:@"看看月报"]) {
                if(self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didTapMonthlyReport)]) {
                    [self.actionDelegate didTapMonthlyReport];
                }
            } else if ([btn.titleLabel.text isEqualToString:@"领取"]) {
                if(self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didTapReceiveGift)]) {
                    [self.actionDelegate didTapReceiveGift];
                }
            }
            break;
            
        default:
            break;
    }
}

@end
