//
//  HYBuyECoinComfirmView.m
//  HYNewNest
//
//  Created by zaky on 10/16/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBuyECoinComfirmView.h"
#import "HYRechProcButton.h"
#import "HYRechargeHelper.h"
#import "CNTwoStatusBtn.h"

@interface HYBuyECoinComfirmView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void(^switchHandler)(NSInteger idx);
@property (nonatomic, copy) void(^submitHandler)(NSString * amo);

@property (nonatomic, assign, readwrite) NSInteger selcPayWayIdx;
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) NSArray *btns;
@property (nonatomic, assign) BOOL isAmountRight;

@property (strong, nonatomic) UILabel *lblUponAmoTf;
@property (strong, nonatomic) UIView *line;
@property (nonatomic, strong) CNTwoStatusBtn *comfirmBtn;
@property (nonatomic, strong) UITextField *amountTf;
@end

@implementation HYBuyECoinComfirmView

+ (void)showWithDepositModels:(NSArray *)depositModels
                switchHandler:(void(^)(NSInteger idx))switchHandler
                submitHandler:(void(^)(NSString  * amount))submitHandler {
    
    HYBuyECoinComfirmView *view = [[HYBuyECoinComfirmView alloc] initWithDepositModels:depositModels switchHandler:switchHandler submitHandler:submitHandler];
    [kKeywindow addSubview:view];
    [view show];
}

- (instancetype)initWithDepositModels:(NSArray *)depositModels
                        switchHandler:(void(^)(NSInteger idx))switchHandler
                        submitHandler:(void(^)(NSString * amount))submitHandler {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.depositModels = depositModels;
        self.switchHandler = switchHandler;
        self.submitHandler = submitHandler;
        
        // 半透明背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgView.backgroundColor = kHexColorAlpha(0x000000, 0.3);
        [self addSubview:bgView];
              
        // 主背景
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, AD(344))];
        mainView.tag = 150;
        mainView.backgroundColor = kHexColor(0x212137);
        [mainView jk_setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:20];
        [self addSubview:mainView];
        self.contentView = mainView;
        
        // 标题
        UILabel *lblSex = [[UILabel alloc] init];
        lblSex.frame = CGRectMake(0, 0, kScreenWidth, AD(50));
        lblSex.text = @"充币信息";
        lblSex.textAlignment = NSTextAlignmentCenter;
        lblSex.font = [UIFont fontPFSB16];
        lblSex.textColor = [UIColor whiteColor];
        [mainView addSubview:lblSex];
          [lblSex addLineDirection:LineDirectionBottom color:kHexColorAlpha(0xFFFFFF, 0.3) width:0.5];
        
        // 关闭按钮
        UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancle setImage:[UIImage imageNamed:@"tips-close"] forState:UIControlStateNormal];
        btnCancle.frame = CGRectMake(CGRectGetWidth(bgView.frame)-AD(30)-25, AD(12), AD(30), AD(30));
        [btnCancle addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:btnCancle];
        
        CGFloat maxY = 50;
        CGFloat ItemMargin = 16;
        CGFloat ItemLeading = 18;
        CGFloat ItemWidht = (kScreenWidth - ItemLeading*2 - ItemMargin*2)/3.0;
        
        // 充值方式
        NSMutableArray *btns = @[].mutableCopy;
        HYRechProcButton *firstBtn;
        for (__block int i=0; i<self.depositModels.count; i++) {
            DepositsBankModel *model = self.depositModels[i];
            
            HYRechProcButton *proBtn = [[HYRechProcButton alloc] init];
            if ([HYRechargeHelper isOnlinePayWayDCBox:model]) {
                [proBtn setTitle:@"小金库" forState:UIControlStateNormal];
            } else {
                [proBtn setTitle:@"币所" forState:UIControlStateNormal];
            }
            [proBtn addTarget:self action:@selector(protocolSelected:) forControlEvents:UIControlEventTouchUpInside];
            proBtn.tag = i;
            
            [self.contentView addSubview:proBtn];
            proBtn.frame = CGRectMake(ItemLeading + (ItemMargin + ItemWidht) * (i%3), maxY + 20+ (i/3) * (40+16), ItemWidht, 40);
            
            if (i==0) {
                firstBtn = proBtn;
            }
            if (i == self.depositModels.count - 1) {
                maxY = proBtn.bottom;
            }
            [btns addObject:proBtn];
        }
        // 选中第一个
        [self protocolSelected:firstBtn];
        _selcPayWayIdx = 0;
        self.btns = btns.copy;
        
        // 协议
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = @"请在币所选择 ERC20 协议提币，否则无法到账";
        lbl.textColor = kHexColor(0x19CDCD);
        lbl.font = [UIFont fontPFSB14];
        lbl.frame = CGRectMake(ItemLeading, maxY + 12, self.contentView.width - 18*2, 20);
        [self.contentView addSubview:lbl];
        
        // 金额
        UILabel *lblAmo = [UILabel new];
        lblAmo.text = @"充币数额";
        lblAmo.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
        lblAmo.font = [UIFont fontPFSB14];
        lblAmo.frame = CGRectMake(ItemLeading, lbl.bottom + 27, self.contentView.width - 18*2, 20);
        [self.contentView addSubview:lblAmo];
        self.lblUponAmoTf = lblAmo;
        
        DepositsBankModel *firModel = depositModels[0];
        // 输入
        UITextField *tf = [[UITextField alloc] init];
        tf.frame = CGRectMake(ItemLeading, lblAmo.bottom + 10, self.contentView.width - 18*2, 23);
        tf.borderStyle = UITextBorderStyleNone;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.placeholder = [NSString stringWithFormat:@"请输入≥%ldUSDT的数额", firModel.minAmount];
        tf.font = [UIFont fontDBOf16Size];
        tf.textColor = kHexColor(0xFFFFFF);
        [tf setValue:kHexColorAlpha(0xFFFFFF, 0.4) forKeyPath:@"placeholderLabel.textColor"];
        [tf setValue:[UIFont fontPFR15] forKeyPath:@"placeholderLabel.font"];
        [tf addTarget:self action:@selector(amountTfDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:tf];
        self.amountTf = tf;
        
        // line
        UIView *line = [UIView new];
        line.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.3);
        line.frame = CGRectMake(ItemLeading, tf.bottom + 10, self.contentView.width - 18*2, 0.5);
        [self.contentView addSubview:line];
        self.line = line;
        
        //button
        CNTwoStatusBtn *comBtn = [[CNTwoStatusBtn alloc] init];
        comBtn.enabled = NO;
        [comBtn setTitle:@"提交订单+获取地址" forState:UIControlStateNormal];
        comBtn.frame = CGRectMake(ItemLeading, line.bottom + 44, self.contentView.width - 18*2, 48);
        [comBtn addTarget:self action:@selector(touchupComfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:comBtn];
        self.comfirmBtn = comBtn;
        
    }
    return self;
}


#pragma mark - ACTION

- (void)touchupComfirmBtn {
    if (self.submitHandler) {
        self.submitHandler([self.amountTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
    [self removeView];
}

- (void)protocolSelected:(UIButton *)aBtn {
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    aBtn.selected = YES;
    self.selcPayWayIdx = aBtn.tag;
    if (self.switchHandler) {
        self.switchHandler(self.selcPayWayIdx);
    }
    
}


#pragma mark - TextField

- (void)amountTfDidChange:(UITextField *)tf {
    NSString *text = tf.text;
    NSString *tipText = @"";
    DepositsBankModel *model = self.depositModels[_selcPayWayIdx];
    // 校验金额
    if ([text floatValue] < (float)model.minAmount) {
        tipText = [NSString stringWithFormat:@"请输入≥%ld%@的数额", model.minAmount, model.currency];;
        self.isAmountRight = NO;
        
    } else if ([text floatValue] > (float)model.maxAmount){
        tipText = [NSString stringWithFormat:@"超过最大充币额度%ld%@", model.maxAmount, model.currency];
        self.isAmountRight = NO;
        
    } else {
        self.isAmountRight = YES;
    }
    // 改变UI
    if (!self.isAmountRight) {
        self.lblUponAmoTf.text = tipText;
        self.lblUponAmoTf.textColor = kHexColor(0xFF5D5B);
        self.line.backgroundColor = kHexColor(0xFF5D5B);
        self.comfirmBtn.enabled = NO;
        
    } else {
        self.lblUponAmoTf.text = @"充币数额";
        self.lblUponAmoTf.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
        self.line.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.3);
        self.comfirmBtn.enabled = YES;
    }
    
}


#pragma mark - REMOVE

- (void)show {
    UIView *mainView = [self viewWithTag:150];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = self.superview.height - mainView.height;
    } completion:^(BOOL finished) {
    }];
}

- (void)cancleClick{
    
    [self removeView];
}

- (void)removeView{
    UIView *mainView = [self viewWithTag:150];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = self.superview.height;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}


@end
