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
#import "UIColor+Gradient.h"

#import "CNMAmountSelectCCell.h"
#define kCNMAmountSelectCCell  @"CNMAmountSelectCCell"

@interface HYRechargeCNYEditView () <CNNormalInputViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblPayWayName;
@property (weak, nonatomic) IBOutlet UIView *refundTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundTipViewH;
@property (weak, nonatomic) IBOutlet UILabel *tipLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountBtnsTopMargin;
@property (weak, nonatomic) IBOutlet UIView *amountBtnsContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountBtnsContainH;
@property (weak, nonatomic) IBOutlet CNNormalInputView *amountTfView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTfViewH;
@property (weak, nonatomic) IBOutlet CNNormalInputView *depositorTfView;
@property (weak, nonatomic) IBOutlet UIView *depositIdBtnsContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depositIdBtnsContainH;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UIView *btmBankSelcView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmBankSelcViewH;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet CNBaseTF *bankTf;

@property (nonatomic, strong) PayWayV3PayTypeItem *itemModel;
@property (nonatomic, strong) OnlineBanksModel *bankModel;
@property (nonatomic, strong) AmountListModel *amountModel;
@property (nonatomic, strong) BQBankModel *bqBankModel;

@property (nonatomic, copy) NSArray *dataList;

// OUTTER
@property (nonatomic, copy, readwrite) NSString *rechargeAmount;
@property (nonatomic, copy, readwrite) NSString *depositor;
@property (nonatomic, copy, readwrite) NSString *depositorId;

@end

@implementation HYRechargeCNYEditView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.contentView.backgroundColor = kHexColor(0x272749);
    [self.contentView addCornerAndShadow];
    
    [self.depositorTfView setPlaceholder:@"请输入付款人姓名"];
    self.depositorTfView.delegate = self;
    [self.depositorTfView setTextColor:kHexColorAlpha(0xFFFFFF, 0.5)];
    [self.depositorTfView setPrefixText:@"付款人姓名: "];
    
    [self.amountTfView setInputBackgoundColor:kHexColor(0x16162C)];
    self.amountTfView.delegate = self;
    [self.amountTfView setKeyboardType:UIKeyboardTypeNumberPad];
    
        
    if ([[CNUserManager shareManager] userDetail].depositLevel == 0) {
        self.warningLabel.attributedText = ({
            UIColor *gdColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:280];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@" CNY充值时，付款人姓名必须和银行卡绑定姓名一致" attributes:@{NSFontAttributeName:[UIFont fontPFR12], NSForegroundColorAttributeName:gdColor}];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"yellow exclamation"];
            attch.bounds = CGRectMake(0, 0, 14, 15);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attrStr insertAttributedString:string atIndex:0];
            attrStr;
        });
    }
    
}

#pragma mark - SET & GET
- (void)setupBQBankModel:(BQBankModel *)model {
    _bqBankModel = model;
    
    [self.bankIcon sd_setImageWithURL:[NSURL getBankIconWithString:model.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
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
    [self.imgvIcon sd_setImageWithURL:[NSURL getUrlWithString:itemModel.payTypeIcon] placeholderImage:[UIImage imageNamed:@"channel_fastpay"]];
    self.lblPayWayName.text = itemModel.payTypeName;

    
    if ([self.lblPayWayName.text containsString:@"支付宝"] || [self.lblPayWayName.text containsString:@"微信"]) {
        self.tipLbl.attributedText = ({
            UIColor *gdColor = kHexColor(0x999999);
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@" 如果出现风控提示，建议使用银行卡转账" attributes:@{NSFontAttributeName:[UIFont fontPFR12], NSForegroundColorAttributeName:gdColor}];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"yellow exclamation"];
            attch.bounds = CGRectMake(0, 0, 12, 12);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attrStr insertAttributedString:string atIndex:0];
            attrStr;
        });
        self.tipLbl.hidden = NO;
    } else {
        self.tipLbl.hidden = YES;
    }
//    self.lblPayWayLimit.text = [NSString stringWithFormat:@"(%@)", [HYRechargeHelper amountTip:itemModel]];
    
    /// 金额选择按钮
    for (UIButton *btn in self.amountBtnsContain.subviews) {
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

            UIButton *proBtn = [[UIButton alloc] init];
            [proBtn setTitle:[NSString stringWithFormat:@"%@", amoTit] forState:UIControlStateNormal];
            [proBtn addTarget:self action:@selector(amountBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
            proBtn.tag = i;

            [self.amountBtnsContain addSubview:proBtn];
            proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * (i%3), (i/3) * (ItemHeight+ItemMargin), ItemWidht, ItemHeight);
            [proBtn setBackgroundImage:[UIColor gradientImageFromColors:@[kHexColor(0x10B4DD), kHexColor(0x19CECE)] gradientType:GradientTypeLeftToRight imgSize:proBtn.frame.size]
                              forState:UIControlStateSelected];
            [proBtn setTitleColor:kHexColor(0x11B5DD) forState:UIControlStateNormal];
            [proBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateSelected];
            proBtn.layer.borderColor = kHexColor(0x10B4DD).CGColor;
            proBtn.layer.borderWidth = 1.f;
            proBtn.layer.cornerRadius = 4;
            proBtn.layer.masksToBounds = true;

        }
        self.amountBtnsContain.hidden = NO;
        self.amountBtnsContainH.constant = ItemHeight + ((amoArr.count-1)/3)*(ItemHeight+ItemMargin);;
        self.amountBtnsTopMargin.constant = 22 + (self.tipLbl.isHidden ? 0 : 20);
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
        make.bottom.equalTo(self.btmBankSelcView).offset(40);
    }];
    
    [self setupMatchUI];
}

#pragma mark - 撮合相关

- (void)setupMatchUI {
    //92:支付宝秒存 91:微信秒存 90：迅捷网银
    NSArray *array = @[@"91", @"92", @"93"];
    if ([array containsObject:self.itemModel.payType]) {
        self.dataList = [self getRecommendAmountFromAmount:nil];
        if (self.dataList.count > 0) {
            self.refundTipView.hidden = NO;
            self.refundTipViewH.constant = 38;
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            self.collectionView.hidden = NO;
            [self.collectionView registerNib:[UINib nibWithNibName:kCNMAmountSelectCCell bundle:nil] forCellWithReuseIdentifier:kCNMAmountSelectCCell];
            self.collectionViewH.constant = 50 * ceilf(self.dataList.count/3.0);
            [self.collectionView reloadData];
            return;
        }
    }
    self.collectionViewH.constant = 0;
    self.collectionView.hidden = YES;
    self.refundTipView.hidden = YES;
    self.refundTipViewH.constant = 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNMAmountSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNMAmountSelectCCell forIndexPath:indexPath];
    cell.amountLb.text = [NSString stringWithFormat:@"¥ %@", self.dataList[indexPath.row]];
    cell.recommendTag.hidden = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.bounds.size.width-15)/3.0, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.amountTfView.text = self.dataList[indexPath.row];
    self.rechargeAmount = self.amountTfView.text;
    [self.amountTfView setStatusToNormal];
    [self checkEnableStatus];
}

/// 计算合理推荐金额
- (NSArray *)getRecommendAmountFromAmount:(NSString *)amount {
    
    NSArray *sourceArray = self.matchAmountList;
    
    if (sourceArray.count < 9) {
        return sourceArray;
    }
    
    if (amount == nil || amount.length == 0) {
        return [sourceArray subarrayWithRange:NSMakeRange(sourceArray.count - 9, 9)];
    }
    
    NSMutableArray *sortArr = [sourceArray mutableCopy];
    [sortArr addObject:amount];
    
    sortArr = [[sortArr sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        if (obj1.intValue < obj2.intValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }] mutableCopy];
    
    NSInteger index = [sortArr indexOfObject:amount];

    if (index < 5) {
        return [sourceArray subarrayWithRange:NSMakeRange(0, 9)];
    } else if  (index > (sourceArray.count - 5)) {
        return [sourceArray subarrayWithRange:NSMakeRange(sourceArray.count - 9, 9)];
    } else {
        return [sourceArray subarrayWithRange:NSMakeRange(index - 4, 9)];
    }
}


#pragma mark - ACTION

- (void)amountBtnSelected:(UIButton *)btn {
    for (UIButton *btn in self.amountBtnsContain.subviews) {
        btn.selected = NO;
    }
    btn.selected = YES;
    self.rechargeAmount = btn.titleLabel.text;
    self.amountTfView.text = btn.titleLabel.text;
    [self.amountTfView setStatusToNormal];
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
        for (UIButton *btn in self.amountBtnsContain.subviews) {
            btn.selected = NO;
        }
        
        self.dataList = [self getRecommendAmountFromAmount:view.text];
        [self.collectionView reloadData];
        
        if ([self.dataList containsObject:view.text]) {
            NSInteger index = [self.dataList indexOfObject:view.text];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathsForSelectedItems].lastObject animated:YES];
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
