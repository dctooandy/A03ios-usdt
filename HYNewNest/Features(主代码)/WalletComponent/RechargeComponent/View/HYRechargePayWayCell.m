//
//  HYRechargePayWayCell.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargePayWayCell.h"
#import <UIImageView+WebCache.h>
#import "HYRechargeHelper.h"
#import "NSURL+HYLink.h"

@interface HYRechargePayWayCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountRange;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTitleTopMargin;

@end

@implementation HYRechargePayWayCell

- (void)setDeposModel:(DepositsBankModel *)deposModel {
    _deposModel = deposModel;
    
    [_imgvIcon sd_setImageWithURL:[NSURL getBankIconWithString:deposModel.bankIcon] placeholderImage:[UIImage imageNamed:@"Exchanges-logo-1"]];
    if ([deposModel.bankname caseInsensitiveCompare:@"dcbox"] == NSOrderedSame) {
        _lblTitle.text = @"小金库";
    } else if ([HYRechargeHelper isUSDTOtherBankModel:deposModel]){
        _lblTitle.text = @"币所";
    } else {
        _lblTitle.text = deposModel.bankname;
    }
    _lblAmountRange.text = [NSString stringWithFormat:@"(%@)", [HYRechargeHelper amountTipUSDT:deposModel]];

}

- (void)setPaywayModel:(PayWayV3PayTypeItem *)paywayModel {
    _paywayModel = paywayModel;
    [_imgvIcon sd_setImageWithURL:[NSURL getBankIconWithString:paywayModel.payTypeIcon] placeholderImage:[UIImage imageNamed:@"channel_fastpay"]];
    _lblTitle.text = paywayModel.payTypeName;
    if ([paywayModel.payType isEqualToString:FastPayType]) {
        _lblAmountRange.text = @"返利1%";
        _lblAmountRange.textColor = kHexColor(0x10B4DD);
    } else {
        _lblAmountRange.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
        _lblAmountRange.text = [NSString stringWithFormat:@"(%@)", [HYRechargeHelper amountTip:paywayModel]];
    }
}

- (void)setBqBank:(BQBankModel *)bqBank {
    _bqBank = bqBank;
    
//    [_imgvIcon sd_setImageWithURL:[NSURL getUrlWithString:bqBank.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
    [self.imgvIcon sd_setImageWithURL:[NSURL getBankIconWithString:bqBank.bankIcon] placeholderImage:[UIImage imageNamed:@"Icon Bankcard"]];
    _lblTitle.text = bqBank.bankName;
    _lblAmountRange.text = @"";

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = kHexColor(0x10101C);
    _lblContent.hidden = YES;
    _lblTitleTopMargin.constant = 28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
