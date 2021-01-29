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

@end

@implementation DSBProfitFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    _go2RemDeskBtn.enabled = YES;
    
    self.backgroundView = ({
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = kHexColor(0x1C1B34);
        bg;
    });
}

- (void)setIsUsrOnline:(BOOL)isUsrOnline {
    _isUsrOnline = isUsrOnline;
    if (isUsrOnline) {
        [_go2RemDeskBtn setTitle:@"去围观" forState:UIControlStateNormal];
    } else {
        [_go2RemDeskBtn setTitle:@"去推荐桌台" forState:UIControlStateNormal];
    }
}

- (IBAction)didTapMoreHistoryBtn:(id)sender {
    !_btmBtnClikHistoryBlock?:_btmBtnClikHistoryBlock();
}

- (IBAction)didTapBtmButton:(id)sender {
    !_btmBtnClikBlock?:_btmBtnClikBlock();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.backgroundView jk_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10];
//    self.backgroundView.layer.masksToBounds = YES;
}

@end
