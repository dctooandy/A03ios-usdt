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
        case SuperCopartnerTypeMyRecommen:
            return @[@"用户", @"星级", @"私享会", @"注册时间"];
            break;
        case SuperCopartnerTypeSXHBonus:
            return @[@"身份", @"月流水", @"入会礼金"];
            break;
        case SuperCopartnerTypeStarGifts:
            return @[@"星级", @"周流水", @"入会礼金"];
            break;
        case SuperCopartnerTypeCumuBetRank:
            return @[@"排名", @"用户", @"月总累投额", @"已推人数"];
            break;
        case SuperCopartnerTypeMyGifts:
            return @[@"生效时间", @"奖品", @"有效期"];
            break;
        default:
            break;
    }
}

- (void)setHeadType:(SuperCopartnerType)headType {
    _headType = headType;
    [self.contentView removeAllSubViews];
    
    NSArray *lbTextArr = [self topLbTextArrayWithType:headType];
    __block NSInteger line = lbTextArr.count;
    CGFloat lbWidth = (kScreenWidth - 25 - 20) / (line * 1.0);
    [lbTextArr enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [UILabel new];
        lb.text = obj;
        lb.font = [UIFont fontPFSB12];
        lb.textColor = kHexColor(0x000000);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.adjustsFontSizeToFitWidth = YES;
        lb.frame = CGRectMake(10 + lbWidth * idx, 0, lbWidth, 26);
        [self.contentView addSubview:lb];
    }];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kHexColor(0xFFFFFF);
        view;
    });
    
    return self;
}

@end
