//
//  CNMBillView.m
//  HYNewNest
//
//  Created by cean on 3/17/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNMBillView.h"

@interface CNMBillView ()
@property (weak, nonatomic) IBOutlet UIImageView *promoTagIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnW;

@end

@implementation CNMBillView

- (void)setPromoTag:(BOOL)show {
    self.statusBtn.layer.borderColor = self.statusBtn.titleLabel.textColor.CGColor;
    self.statusBtn.layer.borderWidth = 1;
    self.statusBtn.layer.masksToBounds = YES;
    self.promoTagIV.hidden = !show;
    if (show) {
        [self.statusBtn setTitle:@"上传凭证催单" forState:UIControlStateNormal];
        self.statusBtn.layer.cornerRadius = 6;
        self.statusBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        self.statusBtnW.constant = 90;
        self.statusBtnH.constant = 40;
    } else {
        [self.statusBtn setTitle:@"确认存款" forState:UIControlStateNormal];
        self.statusBtn.layer.cornerRadius = 6;
        self.statusBtn.layer.masksToBounds = YES;
        self.statusBtn.titleEdgeInsets = UIEdgeInsetsZero;
        self.statusBtnW.constant = 80;
        self.statusBtnH.constant = 32;
    }
}

- (IBAction)copyBill:(id)sender {
    [UIPasteboard generalPasteboard].string = self.billNoLb.text;
    [CNTOPHUB showSuccess:@"已复制"];
}

@end
