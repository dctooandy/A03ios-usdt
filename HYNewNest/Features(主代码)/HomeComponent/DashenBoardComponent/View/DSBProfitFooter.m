//
//  DSBProfitFooter.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBProfitFooter.h"
#import "CNTwoStatusBtn.h"

@interface DSBProfitFooter()

@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *go2RemDeskBtn;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *followBtn;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *circuseeBtn;

@end

@implementation DSBProfitFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    _go2RemDeskBtn.enabled = YES;
    _followBtn.enabled = YES;
    _circuseeBtn.enabled = YES;
    
    self.backgroundView = ({
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = kHexColor(0x1C1B34);
        bg;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.backgroundView jk_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
//    self.backgroundView.layer.masksToBounds = YES;
}

@end
