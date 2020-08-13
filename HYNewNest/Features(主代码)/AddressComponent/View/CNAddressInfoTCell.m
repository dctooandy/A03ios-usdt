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
@end

@implementation CNAddressInfoTCell

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
    
    [self.titleLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    [self.numLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
}

- (IBAction)delete:(id)sender {
    !_deleteBlock ?: _deleteBlock();
}

@end
