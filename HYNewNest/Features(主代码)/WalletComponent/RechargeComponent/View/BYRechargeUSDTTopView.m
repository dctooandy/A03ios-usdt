//
//  BYRechargeUSDTTopView.m
//  HYNewNest
//
//  Created by zaky on 3/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUSDTTopView.h"
#import "UILabel+Gradient.h"

@interface BYRechargeUSDTTopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *rmbStaffImgv;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end

@implementation BYRechargeUSDTTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_bgView addCornerAndShadow6px];
    _bgView.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    [_titleLb setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight From:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _selBtn.selected = selected;
    if (selected) {
        _bgView.layer.borderWidth = 1.0;
        _bgView.backgroundColor = kHexColor(0x3C3C6A);
    } else {
        _bgView.layer.borderWidth = 0.0;
        _bgView.backgroundColor = kHexColor(0x272749);
    }
}

//- (IBAction)didTapMe:(id)sender {
//    [NNPageRouter openExchangeElecCurrencyPage];
//}

@end
