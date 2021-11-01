//
//  CNAddressInfoTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddressInfoTCell.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Gradient.h"
#import "NSURL+HYLink.h"

@interface CNAddressInfoTCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation CNAddressInfoTCell
- (void)setConfig:(AccountModel *)model withShowDeleteButtonFlag:(BOOL)sender {
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon]];
    self.titleLb.text = model.bankName;
    if ([CNUserManager shareManager].isUsdtMode) {
        self.descLb.text = model.protocol;
    } else {
        self.descLb.text = model.accountType;
    }
    self.numLb.text = model.accountNo;
//    [_deleteButton setHidden:!sender];
}
- (void)setModel:(AccountModel *)model {
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL getUrlWithString:model.bankIcon]];
    self.titleLb.text = model.bankName;
    if ([CNUserManager shareManager].isUsdtMode) {
        self.descLb.text = model.protocol;
    } else {
        self.descLb.text = model.accountType;
    }
    self.numLb.text = model.accountNo;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
    [self.numLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
}

- (IBAction)delete:(id)sender {
    !_deleteBlock ?: _deleteBlock();
}

@end
