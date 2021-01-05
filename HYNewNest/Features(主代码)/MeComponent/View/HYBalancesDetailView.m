//
//  HYBalancesDetailView.m
//  HYNewNest
//
//  Created by zaky on 12/1/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYBalancesDetailView.h"
#import "BalanceManager.h"
#import "UILabel+Gradient.h"

@interface HYBalancesDetailView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottom;

@property (weak, nonatomic) IBOutlet UILabel *danweiLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *balsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *platformTotalBalLbl;
@property (weak, nonatomic) IBOutlet UILabel *byTotalBalLbl;
@property (weak, nonatomic) IBOutlet UILabel *sumupTotBalLbl;
@property (weak, nonatomic) IBOutlet UILabel *minimalWithdrawBalLbl;

@end

@implementation HYBalancesDetailView


+ (void)showBalancesDetailView {
    HYBalancesDetailView *view = [[HYBalancesDetailView alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    view.frame = window.bounds;
    [window addSubview:view];
    
    [view setupData];
    
    [[NNControllerHelper currentTabBarController].tabBar setHidden:YES];
    [view configUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 不加这下面两句，获得的尺寸会是xib里的未完成autolayout适配时的尺寸
    // storyboard同理（把这两句写在viewDidLoad:方法中，将contentView换成控制器的view）
    [self.bgView setNeedsLayout];
    [self.bgView layoutIfNeeded];
    [self.bgView jk_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:AD(12)];
}

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    self.bgView.backgroundColor = kHexColor(0x212137);
}


#pragma mark - Action
- (IBAction)didTapRefreshBtn:(id)sender {
    [self requestData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.bgView.layer convertPoint:point fromLayer:self.layer];

    if (![self.bgView.layer containsPoint:point]) {
        self.bgViewBottom.constant = -512;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [[NNControllerHelper currentTabBarController].tabBar setHidden:NO];
        }];
    }
    
}


#pragma mark - Private

- (void)configUI {
    self.bgViewBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)setupData {
    [LoadingView show];
    [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
        [LoadingView hide];
        [self setupViewsWithModel:model];
    }];
}

- (void)requestData {
    [LoadingView show];
    [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
        [LoadingView hide];
        [self setupViewsWithModel:model];
    }];
}

- (void)setupViewsWithModel:(AccountMoneyDetailModel *)model {
    if (!model) {
        return;
    }
    
    // Platform View
    [self.balsScrollView removeAllSubViews];
    
    NSMutableArray *mergedPlatBalances = model.platformBalances.mutableCopy;
    // USDT模式下有可能返回重复的平台 将余额合并后去重
    if ([CNUserManager shareManager].isUsdtMode) {
        __block platformBalancesItem *lastItem;
        [mergedPlatBalances enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(platformBalancesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (lastItem && [lastItem.platformCode isEqualToString:obj.platformCode]) { //有重复值
                CGFloat mergeBalance = lastItem.balance.floatValue + obj.balance.floatValue;
                lastItem.balance = @(mergeBalance);
                [mergedPlatBalances removeObject:obj];
            }
            if ([obj.platformName isEqualToString:@"环亚体育"]) {
                obj.platformName = @"币游体育";
            }
            lastItem = obj;
        }];
    }
    
    CGFloat kMargin = AD(15);
    CGFloat kItem_W = (kScreenWidth - 30 - kMargin*3) * 0.5;
    CGFloat kItem_H = 58.0;
    [mergedPlatBalances enumerateObjectsUsingBlock:^(platformBalancesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *squareView = [UIView new];
        squareView.frame = CGRectMake(kMargin + idx%2 * (kMargin + kItem_W), idx/2 * (kItem_H + kMargin), kItem_W, kItem_H);
        squareView.backgroundColor = kHexColor(0x343452);
        [squareView jk_setRoundedCorners:UIRectCornerAllCorners radius:AD(5)];
        
        UILabel *nameLb = [UILabel new];
        nameLb.text = obj.platformName;
        nameLb.font = [UIFont fontPFR14];
        nameLb.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
        [nameLb sizeToFit];
        nameLb.jk_origin = CGPointMake((kItem_W-nameLb.width)*0.5, 8);
        [squareView addSubview:nameLb];
        
        UILabel *moneyLb = [UILabel new];
        moneyLb.text = [obj.balance jk_toDisplayNumberWithDigit:2];
        moneyLb.font = [UIFont fontPFR14];
        moneyLb.textColor = [UIColor whiteColor];
        [moneyLb sizeToFit];
        moneyLb.jk_origin = CGPointMake((kItem_W-moneyLb.width)*0.5, nameLb.bottom);
        [squareView addSubview:moneyLb];
        
        [self.balsScrollView addSubview:squareView];
        self.balsScrollView.contentSize = CGSizeMake(0, squareView.bottom + 10);
    }];
    
    // TEXT
    self.danweiLbl.text = [NSString stringWithFormat:@"（单位：%@）", model.currency.lowercaseString];
    self.platformTotalBalLbl.text = [model.platformTotalBalance jk_toDisplayNumberWithDigit:2];
    self.byTotalBalLbl.text = [model.localBalance jk_toDisplayNumberWithDigit:2];
    self.sumupTotBalLbl.text = [NSString stringWithFormat:@"总余额 : %@", [model.balance jk_toDisplayNumberWithDigit:2]];
    [self.sumupTotBalLbl setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    self.minimalWithdrawBalLbl.text = [NSString stringWithFormat:@"厅内余额少于%@%@无法转出到网站", model.minWithdrawAmount, model.currency.lowercaseString];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
