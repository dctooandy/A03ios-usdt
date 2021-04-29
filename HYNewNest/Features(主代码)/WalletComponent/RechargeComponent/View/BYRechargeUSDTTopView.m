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
#import "BYProtocolExplainVC.h"

@interface BYRechargeUSDTTopView() <UIGestureRecognizerDelegate>
{
    BOOL _isAmountRight;
    NSString *_tipText;
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
@property (strong,nonatomic) CAShapeLayer* arrowLayer;

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
    _tipText = @"";
    [self setupSubViewsUI];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawArrow];
}

#pragma mark - UI

- (void)setupSubViewsUI {
    [_bgView addCornerAndShadow6px];
    _bgView.layer.borderColor = kHexColor(0x10B4DD).CGColor;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTopBgView)];
//    tap.delegate = self;
//    [_bgView addGestureRecognizer:tap];
    
    [_mainEditBgView addCornerAndShadow6px];
    _mainEditBgView.layer.masksToBounds = YES;
    
    UIImage *gdBgImg = [UIColor gradientImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_submitBtn.width, _submitBtn.height)];
    [_submitBtn setBackgroundImage:gdBgImg forState:UIControlStateNormal];
    _submitBtn.enabled = NO;
    
    [self.tfAmount setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfAmount setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfAmount addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfAmount addTarget:self action:@selector(amountTfDidResignFirstResponder:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)drawArrow {
    if (!_arrowLayer) {
        CAShapeLayer *trangle = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.centerX, 103)];
        [path addLineToPoint:CGPointMake(self.centerX - 15, 115)];
        [path addLineToPoint:CGPointMake(self.centerX + 15, 115)];
        [path addLineToPoint:CGPointMake(self.centerX, 103)];
        trangle.path = path.CGPath;
        trangle.fillColor = kHexColor(0x2C2D47).CGColor;
        [self.layer addSublayer:trangle];
        _arrowLayer = trangle;
    }
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

}


#pragma mark - Setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _selBtn.selected = selected;
    if (selected) {
        _bgView.layer.borderWidth = 1.0;
        _mainEditBgView.hidden = _deposModel?NO:YES;
        _arrowLayer.hidden = _deposModel?NO:YES;
    } else {
        _bgView.layer.borderWidth = 0.0;
        _mainEditBgView.hidden = YES;
        _arrowLayer.hidden = YES;
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
    NSString *tipText = [HYRechargeHelper amountTipUSDT:deposModel];
    _tfAmount.placeholder = tipText;
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

- (void)amountTfDidResignFirstResponder:(UITextField *)tf {
    if (!_isAmountRight) {
        [CNHUB showError:_tipText];
    }
}

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    // 校验金额
    if (![text isPrueIntOrFloat]) {
        _tipText = @"请输入正确的数额";
        _isAmountRight = NO;
        
    } else if ([text floatValue] < (float)self.deposModel.minAmount) {
        _tipText = [NSString stringWithFormat:@"请输入≥%ld%@的数额", self.deposModel.minAmount, self.deposModel.currency];;
        _isAmountRight = NO;
        
    } else if ([text floatValue] > (float)self.deposModel.maxAmount){
        _tipText = [NSString stringWithFormat:@"超过最大充币额度%ld%@", self.deposModel.maxAmount, self.deposModel.currency];
        _isAmountRight = NO;
        
    } else {
        _isAmountRight = YES;
    }
    
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
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOneProtocol:)]) {
        [_delegate didSelectOneProtocol:self.selectedProtocol];
    }
}

//- (void)didTapTopBgView {
//    if (self.didTapTopBgActionBlock) {
//        self.didTapTopBgActionBlock(self.lineIdx);
//    }
//}

- (IBAction)didTapSubmitBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapDepositBtnModel:amount:protocol:)]) {
        [_delegate didTapDepositBtnModel:self.deposModel
                                  amount:self.tfAmount.text
                                protocol:self.selectedProtocol];
    }
}

- (IBAction)didTapShortCutAmountBtn:(BYThreeStatusBtn *)sender {
    sender.status = CNThreeStaBtnStatusGradientBackground;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.status = CNThreeStaBtnStatusGradientBorder;
    });
    
    _tfAmount.text = sender.titleLabel.text;
    [self amountTfDidChange:_tfAmount];
}

- (IBAction)didTapQuestion:(id)sender {
    BYProtocolExplainVC *vc = [BYProtocolExplainVC new];
    [[NNControllerHelper getCurrentViewController] presentViewController:vc animated:YES completion:^{
            
    }];
}

@end
