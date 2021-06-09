//
//  HYRechargeCNYEditView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/11.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargeCNYEditView.h"
#import "CNNormalInputView.h"
#import "HYRechProcButton.h"
#import "CNBaseTF.h"
#import "NSURL+HYLink.h"
#import "HYRechargeHelper.h"
#import <UIImageView+WebCache.h>

@interface HYRechargeCNYEditView () <CNNormalInputViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWayName;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWayLimit;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountBtnsTopMargin;
@property (weak, nonatomic) IBOutlet UIView *amountBtnsContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountBtnsContainH;
@property (weak, nonatomic) IBOutlet CNNormalInputView *amountTfView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTfViewH;
@property (weak, nonatomic) IBOutlet CNNormalInputView *depositorTfView;
@property (weak, nonatomic) IBOutlet UIView *depositIdBtnsContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depositIdBtnsContainH;

@property (weak, nonatomic) IBOutlet UIView *btmBankSelcView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmBankSelcViewH;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet CNBaseTF *bankTf;

@property (nonatomic, strong) PayWayV3PayTypeItem *itemModel;
@property (nonatomic, strong) OnlineBanksModel *bankModel;
@property (nonatomic, strong) AmountListModel *amountModel;
@property (nonatomic, strong) BQBankModel *bqBankModel;

// OUTTER
@property (nonatomic, copy, readwrite) NSString *rechargeAmount;
@property (nonatomic, copy, readwrite) NSString *depositor;
@property (nonatomic, copy, readwrite) NSString *depositorId;

@end

@implementation HYRechargeCNYEditView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.contentView.backgroundColor = kHexColor(0x212137);
    [self.contentView addCornerAndShadow];
    
    [self.depositorTfView setPlaceholder:@"请输入付款人姓名"];
    self.depositorTfView.delegate = self;
    self.amountTfView.delegate = self;
    [self.amountTfView setKeyboardType:UIKeyboardTypeNumberPad];
}



#pragma mark - SET & GET
- (void)setupBQBankModel:(BQBankModel *)model {
    _bqBankModel = model;
    
    [self.bankIcon sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
    self.bankTf.text = model.bankName;
    
    [self checkEnableStatus];
}

- (void)setupPayTypeItem:(PayWayV3PayTypeItem *)itemModel
               bankModel:(nullable OnlineBanksModel *)bankModel
             amountModel:(nullable AmountListModel *)amountModel {
    _itemModel = itemModel;
    _bankModel = bankModel;
    _amountModel = amountModel;
    
    /// 顶上信息
    [self.imgvIcon sd_setImageWithURL:[NSURL getUrlWithString:itemModel.payTypeIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
    self.lblPayWayName.text = itemModel.payTypeName;
    self.lblPayWayLimit.text = [NSString stringWithFormat:@"(%@)", [HYRechargeHelper amountTip:itemModel]];
    
    /// 金额选择按钮
    for (HYRechProcButton *btn in self.amountBtnsContain.subviews) {
        [btn performSelector:@selector(removeFromSuperview)];
    }
    CGFloat ItemMargin = 16;
    CGFloat ItemWidht = (kScreenWidth - 15*2 - 14*2 - ItemMargin*2)/3.0;
    CGFloat ItemHeight = 40;
    NSArray *amoArr;
    if ([HYRechargeHelper isOnlinePayWay:itemModel]) {
        amoArr = bankModel.amountType.amounts;
    } else {
        amoArr = amountModel.amounts;
    }
    if (amoArr.count) {
        for (__block int i=0; i<amoArr.count; i++) {
            NSNumber *amoTit = amoArr[i];

            HYRechProcButton *proBtn = [[HYRechProcButton alloc] init];
            [proBtn setTitle:[NSString stringWithFormat:@"%@", amoTit] forState:UIControlStateNormal];
            [proBtn addTarget:self action:@selector(amountBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
            proBtn.tag = i;

            [self.amountBtnsContain addSubview:proBtn];
            proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * (i%3), (i/3) * (ItemHeight+ItemMargin), ItemWidht, ItemHeight);

        }
        self.amountBtnsContain.hidden = NO;
        self.amountBtnsContainH.constant = ItemHeight + ((amoArr.count-1)/3)*(ItemHeight+ItemMargin);;
        self.amountBtnsTopMargin.constant = 22;
    } else {
        self.amountBtnsContain.hidden = YES;
        self.amountBtnsContainH.constant = 0;
        self.amountBtnsTopMargin.constant = 0;
    }

    /// 金额输入框
    [self.amountTfView setPlaceholder:[NSString stringWithFormat:@"请输入您想充值的金额 %ld-%ld CNY", itemModel.minAmount, itemModel.maxAmount]];
    self.amountTfView.hidden = NO;
    self.amountTfViewH.constant = 80;
    // 是否隐藏金额输入
    if ([HYRechargeHelper isOnlinePayWay:itemModel]) {
        if ([bankModel.amountType.fix integerValue] != 0) {
            self.amountTfView.hidden = YES;
            self.amountTfViewH.constant = 0;
        }
    } else {
        if ([amountModel.fix integerValue] != 0) {
            self.amountTfView.hidden = YES;
            self.amountTfViewH.constant = 0;
        }
    }

    if ([HYRechargeHelper isOnlinePayWay:itemModel] && amountModel.depositorList.count) {
        
        /// 付款人选择按钮
        self.depositIdBtnsContain.hidden = NO;
        self.depositIdBtnsContainH.constant = 40 + ((amountModel.depositorList.count-1)/3)*(40+16);
                    
        for (int i=0; i<amountModel.depositorList.count; i++) {
            NSDictionary *dictDepositor = [amountModel.depositorList objectAtIndex:i];
            NSString *depositor = [dictDepositor objectForKey:@"depositor"];
            NSNumber *depositorId = [dictDepositor objectForKey:@"id"];

            HYRechProcButton *btn = [[HYRechProcButton alloc] init];
            [btn setTitle:depositor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(depositorBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = [depositorId integerValue];

            [self.depositIdBtnsContain addSubview:btn];
            btn.frame = CGRectMake((ItemMargin + ItemWidht) * (i%3), (i/3) * (40+16), ItemWidht, 40);
        }

    } else {
        self.depositIdBtnsContain.hidden = YES;
        self.depositIdBtnsContainH.constant = 0;
    }
    
    // 选择收款银行 暂时废弃 隐藏掉
    self.btmBankSelcView.hidden = YES;
    self.btmBankSelcViewH.constant = 0;
    
    // 调整高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btmBankSelcView).offset(20);
    }];
}


#pragma mark - ACTION

- (void)amountBtnSelected:(UIButton *)btn {
    for (UIButton *btn in self.amountBtnsContain.subviews) {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.rechargeAmount = btn.titleLabel.text;
    self.amountTfView.text = btn.titleLabel.text;
    [self endEditing:YES];
    
    [self checkEnableStatus];
}

- (void)depositorBtnSelected:(UIButton *)btn {
    for (UIButton *btn in self.depositIdBtnsContain.subviews) {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.depositorId = [NSString stringWithFormat:@"%ld", btn.tag];
    self.depositorTfView.text = @"";
    [self endEditing:YES];
    
    [self checkEnableStatus];
}

- (IBAction)didTapSwitchBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSwitchBtnModel:)]) {
        [self.delegate didTapSwitchBtnModel:self.itemModel];
    }
}

- (IBAction)didTapBankSelection:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSelectBank:)]) {
//        [self.delegate didTapSelectBank:self.bankModel];
//    }
}

- (void)clearAmountData {
    for (UIButton *btn in self.amountBtnsContain.subviews) {
        btn.selected = NO;
    }
    self.amountTfView.text = @"";
    self.rechargeAmount = @"";
}

#pragma mark - CNNormalInputViewDelegate

- (void)inputViewTextChange:(CNNormalInputView *)view {
    if (view == self.amountTfView) {
        NSInteger amount = [view.text integerValue];
        if (![view.text isPrueIntOrFloat]) {
            [view showWrongMsg:@"请输入正确的数字金额"];
        } else if (amount < self.itemModel.minAmount || amount > self.itemModel.maxAmount) {
            [view showWrongMsg:[NSString stringWithFormat:@"单笔 %@ CNY", [HYRechargeHelper amountTip:self.itemModel]]];
        } else {
            view.wrongAccout = NO;
            self.rechargeAmount = view.text;
        }
        if (view.text.length > 0) {
            for (UIButton *btn in self.amountBtnsContain.subviews) {
                btn.selected = NO;
            }
        }
    } else if (view == self.depositorTfView) {
        if (![view.text validationType:ValidationTypeRealName]) {
            [view showWrongMsg:@"姓名填写有误"];
        } else {
            view.wrongAccout = NO;
        }
    }
    [self checkEnableStatus];
}

- (void)inputViewDidEndEditing:(CNNormalInputView *)view {
    if (view == self.depositorTfView) {
        if (view.text.length > 0) {
            for (UIButton *btn in self.depositIdBtnsContain.subviews) {
                btn.selected = NO;
            }
            self.depositor = view.text;
            self.depositorId = @"";
        }
    }
    
    [self checkEnableStatus];
}

- (void)checkEnableStatus {

    if ((self.depositorId.length > 0 || (self.depositor && !_depositorTfView.wrongAccout)) && !_amountTfView.wrongAccout){
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeIsStatusRight:)]) {
            [_delegate didChangeIsStatusRight:YES];
        }
        
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeIsStatusRight:)]) {
            [_delegate didChangeIsStatusRight:NO];
        }
    }
    
}

@end
