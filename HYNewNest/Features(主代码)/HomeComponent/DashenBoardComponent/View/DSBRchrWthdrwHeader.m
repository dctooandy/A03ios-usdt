//
//  DSBRchrWthdrwHeader.m
//  HYNewNest
//
//  Created by zaky on 12/22/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRchrWthdrwHeader.h"
#import "DXRadianLayerView.h"

@interface DSBRchrWthdrwHeader()

@property (weak, nonatomic) IBOutlet DXRadianLayerView *radianBgView;


@end

@implementation DSBRchrWthdrwHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = kHexColor(0x1C1B34);
        bg;
    });
    
    self.radianBgView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x1B2240) toColor:kHexColor(0x1A2540) withHeight:208];
    self.radianBgView.radian = 20;
    
}




@end
