//
//  BYDepositUsdtEditorView.m
//  HYNewNest
//
//  Created by zaky on 6/22/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYDepositUsdtEditorView.h"
#import "HYRechargeHelper.h"
#import "BYThreeStatusBtn.h"
#import "BYProtocolExplainVC.h"

@interface BYDepositUsdtEditorView()
{
    BOOL _isAmountRight;
    NSString *_tipText;
}
@property (weak, nonatomic) IBOutlet UIView *protocolContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UIButton *protocolQuestBtn;
@property (weak, nonatomic) IBOutlet UILabel *amountTipsLb;
@property (strong, nonatomic) IBOutletCollection(BYThreeStatusBtn) NSArray *shortCutAmountBtns;

/// 选中的协议
@property (nonatomic, copy, readwrite) NSString *selectedProtocol;
@property (nonatomic, strong) NSArray *protocols; // 所有协议
//@property (nonatomic, copy) NSString *selectProtocolAddress;
//@property (nonatomic, strong) NSArray *protocolAddrs; // 所有协议分别对应的转账地址
@end

@implementation BYDepositUsdtEditorView


#pragma mark - View Life Cycle

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    _isAmountRight = NO;
    _tipText = @"";
    [_protocolQuestBtn jk_setImagePosition:LXMImagePositionRight spacing:5];
    
    [self.tfAmount setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
    [self.tfAmount setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
    [self.tfAmount addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfAmount addTarget:self action:@selector(amountTfDidResignFirstResponder:) forControlEvents:UIControlEventEditingDidEnd];
    
}


#pragma mark - Protocol

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
        if (i==0) { // 进入选中第一个
            [self protocolSelected:proBtn];
        }
    }
}

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


#pragma mark - Setter

- (void)setDeposModel:(DepositsBankModel *)deposModel {
    _deposModel = deposModel;
        
    // RMB直冲方式
    if (deposModel == nil) {
        return;
    }
    
    NSString *tipText = [HYRechargeHelper amountTipUSDT:deposModel];
    _amountTipsLb.text = tipText;
//    _tfAmount.placeholder = tipText;
    
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
//    self.protocolAddrs = protocolAddrsArr;
    
    [self setupProtocolView];
}

- (void)setRechargeAmount:(NSString *)rechargeAmount {
    _rechargeAmount = rechargeAmount;
    self.tfAmount.text = rechargeAmount;
    [self checkEnableStatus:self.tfAmount];
}

- (void)setAmount_list:(NSString *)amount_list {
    _amount_list = amount_list;
    NSArray *amounts = [amount_list componentsSeparatedByString:@";"];
    [self.shortCutAmountBtns enumerateObjectsUsingBlock:^(BYThreeStatusBtn  * _Nonnull  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:amounts[idx] forState:UIControlStateNormal];
    }];
}


#pragma mark - TextField

- (void)amountTfDidResignFirstResponder:(UITextField *)tf {
    if (!_isAmountRight) {
        [CNTOPHUB showError:_tipText];
    }
}

- (void)amountTfDidChange:(UITextField *)tf {
    // 当手动编辑时 取消点击的按钮
    for (int tag = 100; tag < 106; tag++) {
        BYThreeStatusBtn *btn = (BYThreeStatusBtn *)[self viewWithTag:tag];
        btn.status = CNThreeStaBtnStatusGradientBorder;
    }
    
    [self checkEnableStatus:tf];
}

- (void)checkEnableStatus:(UITextField *)tf {
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
        _rechargeAmount = tf.text;
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(depositAmountIsRight:)]) {
        [_delegate depositAmountIsRight:_isAmountRight];
    }
    
}


#pragma mark - IBAction

- (IBAction)didTapShortCutAmountBtn:(BYThreeStatusBtn *)sender {
    for (int tag = 100; tag < 106; tag++) {
        BYThreeStatusBtn *btn = (BYThreeStatusBtn *)[self viewWithTag:tag];
        btn.status = CNThreeStaBtnStatusGradientBorder;
    }
    sender.status = CNThreeStaBtnStatusGradientBackground;
    
    _tfAmount.text = sender.titleLabel.text;
    [self checkEnableStatus:_tfAmount];
}

- (IBAction)didTapQuestion:(id)sender {
    BYProtocolExplainVC *vc = [BYProtocolExplainVC new];
    [[NNControllerHelper getCurrentViewController] presentViewController:vc animated:YES completion:^{
    }];
}

@end
