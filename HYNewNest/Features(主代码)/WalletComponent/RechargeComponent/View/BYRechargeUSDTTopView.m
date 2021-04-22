//
//  BYRechargeUSDTTopView.m
//  HYNewNest
//
//  Created by zaky on 3/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUSDTTopView.h"
#import "UILabel+Gradient.h"
#import "BYThreeStatusBtn.h"
#import "HYRechargeHelper.h"

@interface BYRechargeUSDTTopView()
@property (weak, nonatomic) IBOutlet UIImageView *payWayImgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *mainEditBgView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *rmbStaffImgv;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIView *protocolContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

/// 选中的协议
@property (nonatomic, copy) NSString *selectedProtocol;
//@property (nonatomic, copy) NSString *selectProtocolAddress;
@property (nonatomic, strong) NSArray *protocols; // 所有协议
@property (nonatomic, strong) NSArray *protocolAddrs; // 所有协议分别对应的转账地址
@end

@implementation BYRechargeUSDTTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_bgView addCornerAndShadow6px];
    [_mainEditBgView addCornerAndShadow6px];
    _mainEditBgView.layer.masksToBounds = YES;
    
    _bgView.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    [_titleLb setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight From:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    
    UIImage *gdBgImg = [UIColor gradientImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_submitBtn.width, _submitBtn.height)];
    [_submitBtn setBackgroundImage:gdBgImg forState:UIControlStateNormal];
    
    
    [self.tfAmount setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfAmount setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfAmount addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _selBtn.selected = selected;
    if (selected) {
        _bgView.layer.borderWidth = 1.0;
//        _bgView.backgroundColor = kHexColor(0x3C3C6A);
        _mainEditBgView.hidden = NO;
    } else {
        _bgView.layer.borderWidth = 0.0;
//        _bgView.backgroundColor = kHexColor(0x272749);
        _mainEditBgView.hidden = YES;
    }
}

- (void)setModel:(DepositsBankModel *)model {
    _model = model;
//    [_imgvIcon sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon] placeholderImage:[UIImage imageNamed:@"rmb"]];
    _tfAmount.placeholder = [NSString stringWithFormat:@"%ld%@起，最多%ld%@", model.minAmount, model.currency, model.maxAmount, model.currency];
    if ([model.bankname caseInsensitiveCompare:@"dcbox"] == NSOrderedSame) {
        _titleLb.text = @"小金库";
        _payWayImgv.image = [UIImage imageNamed:@"xjk"];
    } else if ([HYRechargeHelper isUSDTOtherBankModel:model]){
        _titleLb.text = @"其他钱包";
        _payWayImgv.image = [UIImage imageNamed:@"qtqb"];
    } else {
        _titleLb.text = model.bankname;
    }
    
    
    //protocols
    NSString *pros = model.usdtProtocol;
    NSArray *proStrArr = [pros componentsSeparatedByString:@";"];

    NSMutableArray *protocolsArr = @[].mutableCopy;
    NSMutableArray *protocolAddrsArr = @[].mutableCopy;

    int j = 0;
    for (NSInteger i=proStrArr.count-1; i>=0; i--) { //倒序。。
        NSString *depositor = proStrArr[i];
        NSString *firstStr = [depositor componentsSeparatedByString:@":"].firstObject;
        NSString *lastStr = [depositor componentsSeparatedByString:@":"].lastObject;
        [protocolsArr addObject:firstStr];
        [protocolAddrsArr addObject:lastStr];
        
        if (j==0) {
            self.selectedProtocol = firstStr;
//            self.selectProtocolAddress = lastStr;
        }
        j++;
    }
    
    self.protocols = protocolsArr;
    self.protocolAddrs = protocolAddrsArr;
    
    [self setupProtocolView];
}

- (void)setupProtocolView {
    //TODO: 
//    CGFloat ItemMargin = 16;
//    CGFloat ItemWidht = (kScreenWidth - 15*2 - 14*2 - ItemMargin*2)/3.0;
//
//    HYRechProcButton *firstBtn;
//    for (__block int i=0; i<self.protocols.count; i++) {
//        HYRechProcButton *proBtn = [[HYRechProcButton alloc] init];
//        [proBtn setTitle:self.protocols[i] forState:UIControlStateNormal];
//        [proBtn addTarget:self action:@selector(protocolSelected:) forControlEvents:UIControlEventTouchUpInside];
//        proBtn.tag = i;
//
//        [self.protocolBgView addSubview:proBtn];
//        proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * (i%3), (i/3) * (40+16), ItemWidht, 40);
//
//        if (i==0) {
//            firstBtn = proBtn;
//        }
//    }
//    // 选中第一个
//    [self protocolSelected:firstBtn];
//
//    // tmd小金库要隐藏协议
//    if ([HYRechargeHelper isOnlinePayWayDCBox:self.deposModel]) {
//        self.protocolBgView.hidden = YES;
//        self.amountTfViewTopMargin.constant = 22;
//        // 自内而外改变高度
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(249-62);
//        }];
//    } else {
//        self.protocolBgView.hidden = NO;
//        self.amountTfViewTopMargin.constant = 86;
//        // 自内而外改变高度
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(249);
//        }];
//    }
}

#pragma mark - TextField

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    NSString *tipText = @"";
//    // 校验金额
//    if ([text floatValue] < (float)self.deposModel.minAmount) {
//        tipText = [NSString stringWithFormat:@"请输入≥%ld%@的数额", self.deposModel.minAmount, self.deposModel.currency];;
//        self.isAmountRight = NO;
//        
//    } else if ([text floatValue] > (float)self.deposModel.maxAmount){
//        tipText = [NSString stringWithFormat:@"超过最大充币额度%ld%@", self.deposModel.maxAmount, self.deposModel.currency];
//        self.isAmountRight = NO;
//        
//    } else {
//        self.isAmountRight = YES;
//    }
//    // 改变UI
//    if (!self.isAmountRight) {
//        self.lblUponAmoTf.text = tipText;
//        self.lblUponAmoTf.textColor = kHexColor(0xFF5D5B);
//        self.amountTfBgView.layer.borderColor = kHexColor(0xFF5D5B).CGColor;
//        
//    } else {
//        self.lblUponAmoTf.text = @"充币额度";
//        self.lblUponAmoTf.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
//        self.amountTfBgView.layer.borderColor = kHexColorAlpha(0xFFFFFF, 0.3).CGColor;
//    }
//    // 通知代理
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeIsAmountRight:)]) {
//        [self.delegate didChangeIsAmountRight:self.isAmountRight];
//    }
}

#pragma mark - ACTION

//- (IBAction)didTapTopBgView:(id)sender {
//    MyLog(@"点击伸缩");
//    if (self.didTapTopBgActionBlock) {
//        self.didTapTopBgActionBlock(self.lineIdx);
//    }
//}

- (IBAction)didTapSubmitBtn:(id)sender {
    MyLog(@"提交订单+获取地址");
}



@end
