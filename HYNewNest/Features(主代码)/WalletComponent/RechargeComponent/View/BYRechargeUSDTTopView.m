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
{
    BOOL _isAmountRight;
}
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
    _isAmountRight = NO;
    [self setupSubViewsUI];

}


#pragma mark - UI

- (void)setupSubViewsUI {
    [_bgView addCornerAndShadow6px];
    _bgView.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTopBgView)];
    [_bgView addGestureRecognizer:tap];
    
    [_mainEditBgView addCornerAndShadow6px];
    _mainEditBgView.layer.masksToBounds = YES;
    
    UIImage *gdBgImg = [UIColor gradientImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_submitBtn.width, _submitBtn.height)];
    [_submitBtn setBackgroundImage:gdBgImg forState:UIControlStateNormal];
    _submitBtn.enabled = NO;
    
    [self.tfAmount setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfAmount setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfAmount addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (UIButton *)getPortocalBtn {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_newrecharge_sel"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontDBOf16Size];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn addTarget:self action:@selector(protocolSelected:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setupProtocolView {
    [self.protocolContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
    }];
    
    CGFloat ItemMargin = 16;
    CGFloat ItemHight = 20;
    CGFloat ItemWidht = 72;
    for (__block int i=0; i<self.protocols.count; i++) {
        UIButton *proBtn = [self getPortocalBtn];
        [proBtn setTitle:self.protocols[i] forState:UIControlStateNormal];
        proBtn.tag = i;

        [self.protocolContainer addSubview:proBtn];
        proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * i, (self.protocolContainer.height-ItemHight)*0.5, ItemWidht, ItemHight);
        if (i==0) { // 选中第一个
            [self protocolSelected:proBtn];
        }
    }

    // tmd小金库要隐藏协议
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


#pragma mark - Setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _selBtn.selected = selected;
    if (selected) {
        _bgView.layer.borderWidth = 1.0;
        _mainEditBgView.hidden = _deposModel?NO:YES;
    } else {
        _bgView.layer.borderWidth = 0.0;
        _mainEditBgView.hidden = YES;
    }
}

- (void)setDeposModel:(DepositsBankModel *)deposModel {
    _deposModel = deposModel;
    
//    [_payWayImgv sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon] placeholderImage:[UIImage imageNamed:@"rmb"]];
    
    // RMB直冲方式
    if (deposModel == nil) {
        _titleLb.text = @"人民币直充";
        _contentLb.text = @"买币直接上分";
        _payWayImgv.image = [UIImage imageNamed:@"rmb"];
        [_rmbStaffImgv enumerateObjectsUsingBlock:^(UIImageView  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        return;
    }
    
    // 其他支付方式
    [_rmbStaffImgv enumerateObjectsUsingBlock:^(UIImageView  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    _tfAmount.placeholder = [NSString stringWithFormat:@"%ld%@起，最多%ld%@", deposModel.minAmount, deposModel.currency, deposModel.maxAmount, deposModel.currency];
    if ([deposModel.bankname caseInsensitiveCompare:@"dcbox"] == NSOrderedSame) {
        _titleLb.text = @"小金库";
        _contentLb.text = @"官方合作 到账快";
        _payWayImgv.image = [UIImage imageNamed:@"xjk"];
    } else if ([HYRechargeHelper isUSDTOtherBankModel:deposModel]){
        _titleLb.text = @"其他钱包";
        _contentLb.text = @"任意钱包上分";
        _payWayImgv.image = [UIImage imageNamed:@"qtqb"];
    } else {
        _titleLb.text = deposModel.bankname;
    }
    
    [_titleLb setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight From:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    
    //protocols
    NSString *pros = deposModel.usdtProtocol;
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


#pragma mark - TextField

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    NSString *tipText = @"";
    // 校验金额
    if ([text floatValue] < (float)self.deposModel.minAmount) {
        tipText = [NSString stringWithFormat:@"请输入≥%ld%@的数额", self.deposModel.minAmount, self.deposModel.currency];;
        _isAmountRight = NO;
        
    } else if ([text floatValue] > (float)self.deposModel.maxAmount){
        tipText = [NSString stringWithFormat:@"超过最大充币额度%ld%@", self.deposModel.maxAmount, self.deposModel.currency];
        _isAmountRight = NO;
        
    } else {
        _isAmountRight = YES;
    }
    // 改变UI
//    if (!_isAmountRight) {
//        self.lblUponAmoTf.text = tipText;
//        self.lblUponAmoTf.textColor = kHexColor(0xFF5D5B);
//        self.amountTfBgView.layer.borderColor = kHexColor(0xFF5D5B).CGColor;
//
//    } else {
//        self.lblUponAmoTf.text = @"充币额度";
//        self.lblUponAmoTf.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
//        self.amountTfBgView.layer.borderColor = kHexColorAlpha(0xFFFFFF, 0.3).CGColor;
//    }
    
    _submitBtn.enabled = _isAmountRight;
}


#pragma mark - ACTION

- (void)protocolSelected:(UIButton *)aBtn {
    for (UIButton *btn in self.protocolContainer.subviews) {
        btn.selected = NO;
    }
    aBtn.selected = YES;
    self.selectedProtocol = _protocols[aBtn.tag];
//    self.selectProtocolAddress = _protocolAddrs[aBtn.tag];
}

- (void)didTapTopBgView {
    if (self.didTapTopBgActionBlock) {
        self.didTapTopBgActionBlock(self.lineIdx);
    }
}

- (IBAction)didTapSubmitBtn:(id)sender {
    MyLog(@"提交订单+获取地址");
}



@end
