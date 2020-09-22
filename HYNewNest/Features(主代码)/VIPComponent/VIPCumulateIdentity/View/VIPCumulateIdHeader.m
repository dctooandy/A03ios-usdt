//
//  VIPCumulateIdHeader.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCumulateIdHeader.h"

@interface VIPCumulateIdHeader ()
@property (weak, nonatomic) IBOutlet UIButton *btnRight0;
@property (weak, nonatomic) IBOutlet UIButton *btnRight1;
@property (weak, nonatomic) IBOutlet UIButton *btnRight2;
@property (weak, nonatomic) IBOutlet UIButton *btnRight3;
@property (weak, nonatomic) IBOutlet UIButton *btnRIght4;

@property (weak, nonatomic) IBOutlet UILabel *lblLeft;
@property (nonatomic, copy) NSString *selRank;
@end

@implementation VIPCumulateIdHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _selRank = @"赌尊";
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kHexColor(0x181514);
        view;
    });
    
    
}

- (void)setSelRank:(NSString *)selRank {
    _selRank = selRank;
    _lblLeft.text = [NSString stringWithFormat:@"%@区", selRank];
}

- (IBAction)didTapSwitchRankBtn:(UIButton *)sender {
    MyLog(@"dianle rank");
    
    self.selRank = sender.titleLabel.text;
}


@end
