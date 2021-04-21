//
//  HYSuperCopartnerAlertView.m
//  HYNewNest
//
//  Created by zaky on 4/20/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYSuperCopartnerAlertView.h"
#import "SuperCopartnerTbDataSource.h"
#import "SuperCopartnerTbFooter.h"
#import "SCMyBonusModel.h"
#import <MJRefresh.h>

@interface HYSuperCopartnerAlertView() <SuperCopartnerDelegate>

@property (assign,nonatomic) SuperCopartnerType type;
@property (strong,nonatomic) SuperCopartnerTbDataSource *dataSource;

@property (weak,nonatomic) UIView *btmBg;
@property (weak,nonatomic) UITableView *tableView;

@end

@implementation HYSuperCopartnerAlertView

+ (void)showAlertViewType:(SuperCopartnerType)type
                  handler:(AlertEasyBlock)handler {
    HYSuperCopartnerAlertView *a = [[HYSuperCopartnerAlertView alloc] initWithType:type];
    a.frame = [UIScreen mainScreen].bounds;
    a.easyBlock = handler;
    [a show];
}

- (instancetype)initWithType:(SuperCopartnerType)type {
    self = [super init];
    _type = type;
    
    NSString * title = @"我的推荐礼金";
    if (type == SuperCopartnerTypeMyXimaRebate) {
        title = @"我的洗码返佣";
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView).offset(-30);
        make.left.equalTo(self.bgView).offset(25);
        make.right.equalTo(self.bgView).offset(-25);
        make.height.mas_equalTo(250);
    }];
    
    
    // 标题背景
    UIImageView *titleBg = [UIImageView new];
    titleBg.image = [UIImage imageNamed:@"topbgimg"];
    [self.contentView addSubview:titleBg];
    [titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    // 标题
    UILabel *titleLb = [UILabel new];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLTDHK--GBK1-0" size:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.attributedText = str;
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(titleBg);
    }];
    
    
    // 底部
    UIView *btmBg = [UIView new];
    btmBg.backgroundColor = kHexColor(0xE20076);
    [self.contentView addSubview:btmBg];
    [btmBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    self.btmBg = btmBg;
    
    
    // 内容
    UITableView *tb = [[UITableView alloc] init];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.allowsSelection = NO;
    tb.rowHeight = 25;
    
    self.dataSource = [[SuperCopartnerTbDataSource alloc] initWithTableView:tb type:type isHomePage:NO];
    self.dataSource.delegate = self;
    [self.contentView addSubview:tb];
    self.tableView = tb;
    [tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(titleBg.mas_bottom);
        make.bottom.equalTo(btmBg.mas_top);
    }];
    
    
    // circleClose 关闭按钮
    UIButton *close = [UIButton new];
    UIImage *closeImg = [UIImage imageNamed:@"circleClose"];
    closeImg = [closeImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    close.tintColor = kHexColorAlpha(0xFFFFFF, 0.7);
    [close setImage:closeImg forState:UIControlStateNormal];
    [close addTarget:self action:@selector(didTapCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.contentView.mas_bottom).offset(27);
        make.width.height.mas_equalTo(26);
    }];
    
    
    return self;
}

- (void)didTapCloseBtn
{
    [self dismiss];
}

- (void)dataSourceReceivedMyBonus:(SCMyBonusModel *)model {
    //增底部信息和点击按钮
    
    // 洗码返佣规则
    if (self.type == SuperCopartnerTypeMyXimaRebate) {
        UILabel *btmLb = [UILabel new];
        btmLb.text = @"1.洗码佣金将会按周结算，自动发放到账无需领取。\n2.洗码佣金最小1USDT即可结算。";
        btmLb.textColor = [UIColor whiteColor];
        btmLb.font = [UIFont fontPFR12];
        btmLb.numberOfLines = 0;
        [self.btmBg addSubview: btmLb];
        [btmLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btmBg).offset(30);
            make.right.equalTo(self.btmBg).offset(-30);
            make.top.bottom.equalTo(self.btmBg);
        }];
    
    // 我的奖金
    } else {
        UILabel *ylqLb = [UILabel new];
        ylqLb.text = [NSString stringWithFormat:@"已领取: %@ USDT   未领取: %@ USDT", model.receivedAmount, model.notReceivedAmount];
        ylqLb.textColor = [UIColor whiteColor];
        ylqLb.font = [UIFont fontPFSB14];
        ylqLb.numberOfLines = 1;
        [self.btmBg addSubview: ylqLb];
        [ylqLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btmBg).offset(5);
            make.top.bottom.equalTo(self.btmBg);
        }];
        
        UIButton *recBtn = [UIButton new];
        [recBtn setTitle:@"一键领取" forState:UIControlStateNormal];
        recBtn.titleLabel.font = [UIFont fontPFSB14];
        recBtn.backgroundColor = [UIColor clearColor];
        [recBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [recBtn addTarget:self action:@selector(whattodo) forControlEvents:UIControlEventTouchUpInside];
        [self.btmBg addSubview:recBtn];
        [recBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btmBg.mas_right).offset(-5);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(25);
            make.centerY.equalTo(self.btmBg);
        }];
        recBtn.enabled = model.notReceivedAmount.integerValue > 0;
        recBtn.alpha = (model.notReceivedAmount.integerValue > 0)?1:0.6;
        recBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        recBtn.layer.borderWidth = 1;
        
    }
}

- (void)dataSourceReceivedMyRebate:(NSString *)weekEstimate {
    // 写入tableview footer 洗码预估佣金
    SuperCopartnerTbFooter *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SuperCopartnerTbFooter"];
    [view setupEstimateRebateAmount:weekEstimate];
}

- (void)whattodo {
    if (self.easyBlock) {
        self.easyBlock();
    }
}

@end
