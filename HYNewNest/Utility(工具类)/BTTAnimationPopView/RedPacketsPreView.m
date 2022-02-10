//
//  RedPacketsPreView.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/7.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "RedPacketsPreView.h"

@interface RedPacketsPreView()

@property (weak, nonatomic) IBOutlet UILabel *countDownSenondLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation RedPacketsPreView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewAction)];
    _tapGesture = tap;
    
}
- (IBAction)joinRedPacketAction:(id)sender {
    if (self.getRedBlock)
    {
        self.getRedBlock();
    }
}
- (void)configForRedPocketsViewWithDuration:(int)duration
{
    [self startTimeWithDuration:duration];
    [self.backgroundView addGestureRecognizer:self.tapGesture];
}
- (void)startTimeWithDuration:(int)timeValue
{
    WEAKSELF_DEFINE
    __block int timeout = timeValue;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock();
                }
            });
        }
        else
        {
            NSString * titleStr = [NSString stringWithFormat:@"%d秒",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.countDownSenondLabel.text = titleStr;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)backGroundViewAction
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (IBAction)backButtonAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *myGradient = [UIColor gradientImageFromColors:@[kHexColor(0xEB7A73), kHexColor(0xFFEACA), kHexColor(0xFFEC85)]
                                              gradientType:GradientTypeTopToBottom
                                                   imgSize:self.titleLabel.frame.size];
    self.titleLabel.textColor = [UIColor colorWithPatternImage:myGradient];
    self.countDownSenondLabel.textColor = [UIColor colorWithPatternImage:myGradient];
}
@end
