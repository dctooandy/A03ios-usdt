//
//  HYSuperCopartnerSlideUpView.m
//  HYNewNest
//
//  Created by zaky on 12/18/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYSuperCopartnerSlideUpView.h"
#import "SuperCopartnerTbDataSource.h"

@interface HYSuperCopartnerSlideUpView()

@property (assign,nonatomic) SuperCopartnerType type;
@property (strong,nonatomic) SuperCopartnerTbDataSource *dataSource;
@end

@implementation HYSuperCopartnerSlideUpView

+ (void)showSlideupViewType:(SuperCopartnerType)type{
    HYSuperCopartnerSlideUpView *view = [[HYSuperCopartnerSlideUpView alloc] initWithType:type];
    view.type = type;
}

- (instancetype)initWithType:(SuperCopartnerType)type {
    self = [super initWithContentViewHeight:AD(369) title:@"我的推荐" comfirmBtnText:@""];
    
    [self setupViews];
    
    return self;
}

- (void)setType:(SuperCopartnerType)type {
    _type = type;
    
    NSString *title = @"";
    switch (self.type) {
        case SuperCopartnerTypeMyBonus:
            title = @"奖金记录";
            break;
        case SuperCopartnerTypeMyGifts:
            title = @"我的奖品";
            break;
        case SuperCopartnerTypeMyRecommen:
            title = @"我的推荐";
            break;
        case SuperCopartnerTypeSXHBonus:
            title = @"私享会礼金";
            break;
        case SuperCopartnerTypeStarGifts:
            title = @"星级礼金";
            break;
        default:
            break;
    }
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLTDHK--GBK1-0" size:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.titleLbl.attributedText = str;
    
    UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, AD(64), kScreenWidth, AD(305))];
    self.dataSource = [[SuperCopartnerTbDataSource alloc] initWithTableView:tb type:self.type isHomePage:NO];
    [self.contentView addSubview:tb];
}

- (void)setupViews {
    self.comfirmBtn.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.frame = CGRectMake(AD(342), AD(15), AD(30), AD(30));
    self.titleLbl.frame = CGRectMake(0, 0, kScreenWidth, AD(64));
    self.titleLbl.backgroundColor = kHexColor(0x6020DB);  
    self.topLine.hidden = YES;
}


@end
