//
//  VIPChartDJTQCell.m
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPChartDJTQCell.h"

@interface VIPChartDJTQCell ()
@property (weak, nonatomic) IBOutlet UIButton *btnCS;

@end

@implementation VIPChartDJTQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = kHexColor(0x0A1D25);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// kefu
- (IBAction)didTapCSBtn:(id)sender {
    UIViewController *vc = [NNControllerHelper getCurrentViewController];
    [vc dismissViewControllerAnimated:YES completion:^{
        
        [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
    }];
}

@end
