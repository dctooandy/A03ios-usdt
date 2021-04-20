//
//  SuperCopartnerTbHeader.m
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbHeader.h"

@implementation SuperCopartnerTbHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)topLbTextArrayWithType:(SuperCopartnerType)type {
    switch (type) {
        case SuperCopartnerTypeMyBonus:
            return @[@"用户", @"晋级为", @"生效时间", @"推荐礼金(usdt)", @"有效期"];
            break;
//        case SuperCopartnerTypeMyRecommen:
//            return @[@"我的推荐好友", @"晋级为", @"生效时间", @"推荐礼金(usdt)", @"有效期"];
//            break;
        case SuperCopartnerTypeSXHBonus:
            return @[@"好友身份", @"月流水(usdt)", @"入会礼金"];
            break;
        case SuperCopartnerTypeStarGifts:
            return @[@"好友星级", @"周流水(usdt)", @"星级推荐礼金"];
            break;
        case SuperCopartnerTypeCumuBetRank:
            return @[@"排名", @"用户", @"好友月累投额", @"当月已推人数"];
            break;
        case SuperCopartnerTypeMyXimaRebate:
            return @[@"我的下级", @"晋级为", @"周有效流水", @"推荐礼金(usdt)"];
            break;
        default:
            return @[];
            break;
    }
}

- (void)setHeadType:(SuperCopartnerType)headType {
    _headType = headType;
    [self.contentView removeAllSubViews];
    
    UIColor *textColor = kHexColor(0x000000);
    UIFont *textFont = [UIFont fontPFSB12];
    
    switch (headType) {
        case SuperCopartnerTypeSXHBonus:
        case SuperCopartnerTypeStarGifts:
            textColor = kHexColor(0xFFFFFF);
            textFont = [UIFont fontPFSB14];
            break;
        default:
            break;
    }
    
    NSArray *lbTextArr = [self topLbTextArrayWithType:headType];
    __block NSInteger line = lbTextArr.count;
    CGFloat lbWidth = (kScreenWidth - 50) / (line * 1.0);
    [lbTextArr enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [UILabel new];
        lb.text = obj;
        lb.font = textFont;
        lb.textColor = textColor;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.adjustsFontSizeToFitWidth = YES;
        lb.frame = CGRectMake(lbWidth * idx, 0, lbWidth, 35);
        [self.contentView addSubview:lb];
    }];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];//TODO:
        view;
    });
    
    return self;
}

@end
