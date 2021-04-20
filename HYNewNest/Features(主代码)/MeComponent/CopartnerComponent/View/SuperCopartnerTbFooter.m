//
//  SuperCopartnerTbFooter.m
//  HYNewNest
//
//  Created by zaky on 12/18/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbFooter.h"
#import "CNSuperCopartnerRequest.h"
#import "HYDownloadLinkView.h"

@interface SuperCopartnerTbFooter ()
@property (assign, nonatomic) SuperCopartnerType footType;
// 我的本周预估佣金:  XXX USDT
@property (weak, nonatomic) IBOutlet UILabel *weekRebateLb;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@end

@implementation SuperCopartnerTbFooter

- (void)drawRect:(CGRect)rect {
    // Drawing code

}

// 只有星级礼金，VIP礼金，洗码返佣需要footer
- (void)setupFootType:(SuperCopartnerType)type {
    
    [self.contentView removeAllSubViews];
    
    _footType = type;
    
    switch (type) {
        case SuperCopartnerTypeSXHBonus:
        case SuperCopartnerTypeStarGifts:
            self.contentView.backgroundColor = kHexColor(0x37127C);
            [self.contentView addLineDirection:LineDirectionTop color:kHexColor(0x190A39) width:1.5];
            _weekRebateLb.hidden = YES;
            [_knowBtn setTitle:(type==SuperCopartnerTypeSXHBonus)?@"了解私享会":@"了解星级" forState:UIControlStateNormal];
            break;
        case SuperCopartnerTypeMyXimaRebate:
            self.contentView.backgroundColor = [UIColor whiteColor];
            _weekRebateLb.hidden = NO;
            //TODO: 写入参数 我的本周预估佣金:  XXX USDT
            break;
        default:
            break;
    }
}

- (IBAction)didTapKnowBtn:(id)sender {
    if (self->_footType == SuperCopartnerTypeSXHBonus) { //去私享会
        [kCurNavVC popToRootViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NNControllerHelper currentTabBarController].selectedIndex = 1;
        });
    } else { // 去星级H5
        [NNPageRouter jump2HTMLWithStrURL:@"/starall" title:@"星特权新体验" needPubSite:YES];
    }
}


@end
