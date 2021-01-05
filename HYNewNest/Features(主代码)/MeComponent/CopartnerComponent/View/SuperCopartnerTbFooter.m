//
//  SuperCopartnerTbFooter.m
//  HYNewNest
//
//  Created by zaky on 12/18/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbFooter.h"
#import "CNBorderBtn.h"
#import "CNSuperCopartnerRequest.h"

@interface SuperCopartnerTbFooter ()
@property (weak, nonatomic) IBOutlet CNBorderBtn *onlyBtn;
@property (assign, nonatomic) SuperCopartnerType footType;

@end

@implementation SuperCopartnerTbFooter

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self jk_addTopBorderWithColor:kHexColor(0xEEEEEE) width:0.5];
}

- (void)setupFootType:(SuperCopartnerType)type strArr:(NSArray<NSNumber *> *)strArr {
    
    _footType = type;
    
    [self.contentView removeAllSubViews];
    
    if (type == SuperCopartnerTypeMyBonus) {
        _lbMiddle.hidden = YES;
        _lbYlq.hidden = NO;
        _lbWlq.hidden = NO;
        _lbReceivedAmount.hidden = NO;
        _lbNotReceivedAmount.hidden = NO;
        _onlyBtn.hidden = NO;
        
        if ([CNUserManager shareManager].isLogin) {
            [_onlyBtn setTitle:@"一键领取" forState:UIControlStateNormal];
            
            NSNumber *recNum = strArr[0];
            NSNumber *recedNum = strArr[1];
            _lbReceivedAmount.text = [NSString stringWithFormat:@"%@usdt", [recNum jk_toDisplayNumberWithDigit:0]];
            _lbNotReceivedAmount.text = [NSString stringWithFormat:@"%@usdt", [recedNum jk_toDisplayNumberWithDigit:0]];
            BOOL isHas = [strArr[2] boolValue];
            _onlyBtn.hidden = !isHas;
            
        } else {
            [_onlyBtn setTitle:@"请登录" forState:UIControlStateNormal];
            _lbReceivedAmount.text = @"__usdt";
            _lbNotReceivedAmount.text = @"__usdt";
        }
        
    } else {
        _lbMiddle.hidden = NO;
        _lbYlq.hidden = YES;
        _lbWlq.hidden = YES;
        _lbReceivedAmount.hidden = YES;
        _lbNotReceivedAmount.hidden = YES;
        _onlyBtn.hidden = YES;
        
        if (type == SuperCopartnerTypeMyRecommen) {
            _lbMiddle.text = [NSString stringWithFormat:@"已推荐 %@ 人", strArr.firstObject];
            
        } else if (type == SuperCopartnerTypeSXHBonus) {
            _lbMiddle.text = @"每月初重新评级，可重复入会";
            
        } else if (type == SuperCopartnerTypeStarGifts) {
            _lbMiddle.text = @"一次晋级，终生有效";
        }
    }
}

- (IBAction)didTapOnekeyRecive:(id)sender {
    if ([CNUserManager shareManager].isLogin) { // 一键领取
        [CNSuperCopartnerRequest applyMyGiftBonusHandler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                NSString *amount = responseObj[@"amount"];
                [CNHUB showSuccess:[NSString stringWithFormat:@"成功领取 %@usdt", amount]];
            }
        }];
    } else { // 登录
        [NNPageRouter jump2Login];
    }
}


@end
