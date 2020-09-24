//
//  VIPCumulateIdCell.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCumulateIdCell.h"
#import "VIPCumulateIdButton.h"
#import "HYVIPReceiveAlertView.h"

@interface VIPCumulateIdCell ()
@property (weak, nonatomic) IBOutlet UIView *centerBGView;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet VIPCumulateIdButton *btnReceive;

@end

@implementation VIPCumulateIdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    _btnExpand.backgroundColor = kHexColorAlpha(0x000000, 0.4);
    _btnExpand.layer.cornerRadius = 1;
    _btnExpand.layer.masksToBounds = YES;
    
    if (arc4random_uniform(4)%2 == 0) {
        _btnReceive.enabled = YES;
    } else {
        _btnReceive.enabled = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapBtnReceive:(id)sender {
    MyLog(@"Receive Gift");
    [HYVIPReceiveAlertView showReceiveAlertTimes:3 gift:@"18线嫩模" comfirmHandler:^(BOOL isComfirm) {
        MyLog(@"sdfsdfsdgaOOXXXOXXX");
    }];
}


- (IBAction)didTapBtnExpand:(id)sender {
    MyLog(@"Expandddd");
}

@end
