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
//    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}


- (void)setupType:(SuperCopartnerType)type strArr:(NSArray<NSString *> *)strArr {
    
    [self removeAllSubViews];
    NSMutableArray *arr = strArr.mutableCopy;
    UIColor *textColor = kHexColor(0x000000);
    UIFont *textFont = [UIFont fontPFR12];
    switch (type) {
        case SuperCopartnerTypeMyBonus:
            if (strArr.count == 0) {
                arr = @[@"--", @"--", @"--", @"--", @"--"].mutableCopy;
            }
            break;
        case SuperCopartnerTypeMyXimaRebate:
            if (strArr.count == 0) {
                arr = @[@"--", @"--", @"--", @"--"].mutableCopy;
            }
            break;
//        case SuperCopartnerTypeMyRecommen:
//            if (strArr.count == 0) {
//                arr = @[@"--", @"--", @"--", @"--", @"--"].mutableCopy;
//            }
//            break;
        case SuperCopartnerTypeStarGifts:
        case SuperCopartnerTypeSXHBonus:
        {
            textFont = [UIFont fontPFR13];
            textColor = kHexColor(0xFFFFFF);
        }
        case SuperCopartnerTypeCumuBetRank: // 颜色改变
        {
            NSString *rank = arr.firstObject;
            if ([rank isEqualToString:@"1"]) {
                textColor = kHexColor(0xD69F5A);
                [arr replaceObjectAtIndex:0 withObject:@"冠军"];
            } else if ([rank isEqualToString:@"2"]) {
                textColor = kHexColor(0xD83783);
                [arr replaceObjectAtIndex:0 withObject:@"亚军"];
            } else if ([rank isEqualToString:@"3"]) {
                textColor = kHexColor(0x6132D4);
                [arr replaceObjectAtIndex:0 withObject:@"季军"];
            } else {
                [arr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"第%@名", rank]];
            }
            break;
        }
        default:
            break;
    }
    
    __block NSInteger line = arr.count;
    CGFloat lbWidth = (kScreenWidth - 50) / (line * 1.0);
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [UILabel new];
        lb.text = obj;
        lb.font = textFont;
        lb.textColor = textColor;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.adjustsFontSizeToFitWidth = YES;
        lb.frame = CGRectMake(lbWidth * idx, 0, lbWidth, 26);
        [self addSubview:lb];
    }];
}

@end
