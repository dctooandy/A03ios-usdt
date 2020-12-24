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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
