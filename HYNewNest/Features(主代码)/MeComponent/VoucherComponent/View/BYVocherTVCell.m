//
//  BYVocherTVCell.m
//  HYNewNest
//
//  Created by zaky on 3/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYVocherTVCell.h"
#import "NSString+Font.h"
#import "BYVocherModel.h"
#import "HYWideOneBtnAlertView.h"
#import "NSString+JKSize.h"
#import "BYVoucherRequest.h"

@interface BYVocherTVCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLb;
@property (weak, nonatomic) IBOutlet UILabel *streamLb;
@property (weak, nonatomic) IBOutlet UILabel *mianeAmountLb;

@property (weak, nonatomic) IBOutlet UILabel *depositAmountTxtLb; //存款金额
@property (weak, nonatomic) IBOutlet UILabel *depositAmountLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depositAmountLbTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depositAmountLbHeightCOnst;

@property (weak, nonatomic) IBOutlet UILabel *totalStreamLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progsView;

@property (weak, nonatomic) IBOutlet UILabel *suportGameRightLb;
@property (weak, nonatomic) IBOutlet UIImageView *suportGameRightArr;
@property (weak, nonatomic) IBOutlet UIButton *suportGameRightBtn;

@property (weak, nonatomic) IBOutlet UILabel *suportGameDetailLb;

@property (weak, nonatomic) IBOutlet UIButton *btmDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmDetailBtnHCons;

@end

@implementation BYVocherTVCell


#pragma mark - Setter
- (void)setIsExpand:(BOOL)isExpand {
    _isExpand = isExpand;
    if (isExpand) {
        _suportGameRightLb.hidden = YES;
        _suportGameRightArr.hidden = YES;
        _btmDetailBtn.hidden = NO;
        _btmDetailBtnHCons.constant = 30;
        _suportGameDetailLb.hidden = NO;
        _suportGameDetailLb.text = self.model.platforms;
//        [_suportGameDetailLb sizeToFit];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } else {
        _suportGameRightLb.hidden = NO;
        _suportGameRightArr.hidden = NO;
        _btmDetailBtn.hidden = YES;
        _btmDetailBtnHCons.constant = 0;
        _suportGameDetailLb.hidden = YES;
        _suportGameDetailLb.text = @"";
//        [_suportGameDetailLb sizeToFit];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setModel:(BYVocherModel *)model {
    _model = model;
    
    [_titleBtn setTitle:model.prizeName forState:UIControlStateNormal];
    [_titleBtn sizeToFit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleBtn jk_setImagePosition:LXMImagePositionRight spacing:0];
    });
    
    _statusLb.text = VocherStatusString[model.status];
    switch (model.status) {
        case 1:
        case 2:
            _statusLb.textColor = kHexColor(0xFFE090);
            break;
        case 3:
            _statusLb.textColor = kHexColor(0x40FEB3);
            break;
        case 8:
            _statusLb.textColor = kHexColorAlpha(0x40FEB3, 0.3);
            break;
        case 4:
        case 7:
            _statusLb.textColor = kHexColorAlpha(0xFFFFFF, 0.1);
            break;
        case 5:
            _statusLb.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
            break;
        default:
            break;
    }
    
    _mianeAmountLb.text = [model.bonusAmount jk_toDisplayNumberWithDigit:2];
    
    _depositAmountLb.text = [model.depositAmount jk_toDisplayNumberWithDigit:2];
    
    // 是否首存优惠
    if ([model.depositAmount integerValue]) {
        _depositAmountLb.hidden = NO;
        _depositAmountTxtLb.hidden = NO;
        _depositAmountLb.text = [model.depositAmount jk_toDisplayNumberWithDigit:2];
        _depositAmountLbTopConst.constant = 10;
        _depositAmountLbHeightCOnst.constant = 22;
        
    } else {
        _depositAmountLb.hidden = YES;
        _depositAmountTxtLb.hidden = YES;
        _depositAmountLbTopConst.constant = 0;
        _depositAmountLbHeightCOnst.constant = 0;
    }
    
    _totalAmountLb.text = [model.totalAmount jk_toDisplayNumberWithDigit:2];
    _streamLb.text = [@(model.finishedBetAmount) jk_toDisplayNumberWithDigit:0];
    _totalStreamLb.text = [@(model.unlockBetAmount) jk_toDisplayNumberWithDigit:0];
    float percent = (model.finishedBetAmount*1.0)/(model.unlockBetAmount*1.0);
    _progsView.progress = percent;
    
    // 支持游戏
    if ([model.platforms jk_widthWithFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight] constrainedToHeight:30] > 250) {
        _suportGameRightArr.alpha = 1;
        _suportGameRightBtn.enabled = YES;
        _suportGameRightLb.text = model.platforms;
        _suportGameDetailLb.text = model.platforms;
    } else {
        _suportGameRightArr.alpha = 0.3;
        _suportGameRightBtn.enabled = NO;
        if (KIsEmptyString(model.platforms)) {
            _suportGameRightLb.text = @"不限游戏类型";
            _suportGameDetailLb.text = @"不限游戏类型";
        }
    }
}


#pragma mark - View
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
}


#pragma mark - Action

- (IBAction)didTapDetailBtn:(id)sender {
    
}


- (IBAction)didTapRuleBtn:(id)sender {
    [HYWideOneBtnAlertView showWithTitle:@"优惠券说明" content:@"1，优惠券一旦激活，优惠券总额将锁定，直到完成流水要求或额度用光后，自动转入可提现金额；\n2，充值送礼金类的优惠，充值的金额也会被划入到优惠券总额里；\n3，当存在未完成流水要求的优惠券时，您的盈利也会被划入到优惠券总额里；\n4，优惠券总额、流水要求只针对支持的游戏生效，如您领取体育优惠券，不对在百家乐游戏数据生效；\n5，当存在多张优惠券时，系统会优先满足流水要求较小的优惠券；\n6，本优惠券解释权归币游国际所有，如有疑问详询客服。" comfirmText:@"我知道了" comfirmHandler:^{
    }];
}

// 展开
- (IBAction)didTapExpandBtn:(id)sender {
    if (self.changeCellHeightBlock) {
        self.changeCellHeightBlock(YES);
    }
}

// 收缩
- (IBAction)didTapBtmBtn:(id)sender {
    if (self.changeCellHeightBlock) {
        self.changeCellHeightBlock(NO);
    }
}

@end
