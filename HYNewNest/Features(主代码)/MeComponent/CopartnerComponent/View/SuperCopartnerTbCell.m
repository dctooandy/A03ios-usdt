//
//  SuperCopartnerTbCell.m
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbCell.h"

@implementation SuperCopartnerTbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = kHexColor(0xFFFFFF);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}


- (void)setupType:(SuperCopartnerType)type strArr:(NSArray<NSString *> *)strArr {
    
    [self removeAllSubViews];
    
    //TODO: 假数据
    UIColor *textColor = kHexColor(0x000000);
    CGFloat lineHeight = 26.0;
    switch (type) {
        case SuperCopartnerTypeMyBonus:
            strArr = @[@"fxxx12", @"VIP2", @"2020.20.20", @"128", @"30天"];
            break;
        case SuperCopartnerTypeMyRecommen:
            strArr = @[@"fxxx12", @"VIP2", @"赌爸", @"2020.20.20"];
            break;
        case SuperCopartnerTypeSXHBonus:
            strArr = @[@"赌神", @"28,571,000", @"5588"];
            break;
        case SuperCopartnerTypeStarGifts:
            strArr = @[@"VIP2", @"571,000", @"238"];
            break;
        case SuperCopartnerTypeCumuBetRank: // 颜色改变
        {
            lineHeight = 20.0;
            
            strArr = @[@"冠军", @"fxxx12", @"28,571,000", @"35"];
            NSString *rank = strArr.firstObject;
            if ([rank isEqualToString:@"冠军"]) {
                textColor = kHexColor(0xD69F5A);
            } else if ([rank isEqualToString:@"亚军"]) {
                textColor = kHexColor(0xD83783);
            } else if ([rank isEqualToString:@"季军"]) {
                textColor = kHexColor(0x6132D4);
            }
            break;
        }
        case SuperCopartnerTypeMyGifts:
            strArr = @[@"2020.20.20", @"Macbook pro 13.3英寸", @"30天"];
            break;
        default:
            break;
    }
    
    __block NSInteger line = strArr.count;
    CGFloat lbWidth = (kScreenWidth - 25) / (line * 1.0);
    [strArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [UILabel new];
        lb.text = obj;
        lb.font = [UIFont fontPFR12];
        lb.textColor = textColor;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.adjustsFontSizeToFitWidth = YES;
        lb.frame = CGRectMake(lbWidth * idx, 0, lbWidth, lineHeight);
        [self addSubview:lb];
    }];
}

@end
