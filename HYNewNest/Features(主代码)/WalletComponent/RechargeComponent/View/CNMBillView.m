//
//  CNMBillView.m
//  HYNewNest
//
//  Created by cean on 3/17/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNMBillView.h"

@implementation CNMBillView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    self.statusBtn.layer.cornerRadius = 16;
    self.statusBtn.layer.borderColor = self.statusBtn.titleLabel.textColor.CGColor;
    self.statusBtn.layer.borderWidth = 1;
    self.statusBtn.layer.masksToBounds = YES;
}

- (IBAction)copyBill:(id)sender {
    [UIPasteboard generalPasteboard].string = self.billNoLb.text;
    [CNTOPHUB showSuccess:@"已复制"];
}

@end
