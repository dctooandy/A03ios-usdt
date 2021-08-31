//
//  BYLargeAmountView.m
//  HYNewNest
//
//  Created by RM04 on 2021/8/26.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYLargeAmountView.h"
#import "NNPageRouter.h"
#import "CNTwoStatusBtn.h"

@interface BYLargeAmountView ()
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *customServiceButton;

@end

@implementation BYLargeAmountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)loadViewFromXib {
    [super loadViewFromXib];
    self.backgroundColor = kHexColor(0x272749);
    [self addCornerAndShadow];
    self.customServiceButton.enabled = true;
}

- (void)addCornerAndShadow{
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = AD(10);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0f);
    self.layer.shadowRadius = 10;
    self.layer.shadowOpacity = 0.23f; //透明度
}

- (IBAction)customClicked:(id)sender {
    [NNPageRouter presentOCSS_VC:true];
}

@end
