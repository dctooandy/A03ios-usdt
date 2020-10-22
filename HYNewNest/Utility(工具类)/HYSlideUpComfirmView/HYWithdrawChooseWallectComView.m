//
//  HYWithdrawChooseWallectComView.m
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYWithdrawChooseWallectComView.h"

@interface HYWithdrawChooseWallectComView ()
@property (nonatomic, strong) NSArray *wallBtns;
@property (nonatomic, strong) NSNumber *accountId; //if -1 when no wallet
@end


@implementation HYWithdrawChooseWallectComView

+ (void)showWithAmount:(NSNumber *)amount
   subWalAccountsModel:(nullable NSArray<AccountModel *> *)models
         submitHandler:(SubmitComfirmArgsBlock)handler {
    
    HYWithdrawChooseWallectComView *view = [[HYWithdrawChooseWallectComView alloc] initWithContentViewHeight:AD(323) title:@"选择钱包" comfirmBtnText:@"提交"];
    view.submitArgsHandler = handler;
    [view setupWithModels:models amount:amount];
}

- (instancetype)initWithContentViewHeight:(CGFloat)height title:(NSString *)title comfirmBtnText:(NSString *)btnTitle {
    self = [super initWithContentViewHeight:height title:title comfirmBtnText:btnTitle];
    self.comfirmBtn.enabled = YES;
    return self;
}

// 核心内容
- (void)setupWithModels:(nullable NSArray<AccountModel *> *)models amount:(NSNumber *)amount{
    NSString *topStr = [NSString stringWithFormat:@"请选择将 %@USDT 转入", amount];
    UILabel *topLb = [UILabel new];
    topLb.text = topStr;
    topLb.font = [UIFont fontPFR14];
    topLb.textColor = kHexColorAlpha(0xFFFFFF, 0.8);
    [topLb sizeToFit];
    topLb.jk_origin = CGPointMake(AD(20), self.titleLbl.bottom + AD(20));
    [self.contentView addSubview:topLb];
    
    CGFloat maxY = topLb.bottom + AD(7);
    if (!models.count) {
        UIButton *btn = [self commonBtn:@"USDT余额" orgP:CGPointMake(AD(20), maxY + AD(13))];
        btn.tag = -1;
        btn.selected = YES;
        self.accountId = @(-1);
        self.wallBtns = @[btn];
        
    } else {
        NSMutableArray *btns = @[].mutableCopy;
        for (int i=0; i<models.count; i++) {
            AccountModel *model = models[i];
            NSString *bankName = [model.bankName isEqualToString:@"DCBOX"]?@"小金库":model.bankName;
            NSString *longTitle = [NSString stringWithFormat:@"%@ %@ (%@)", bankName, model.protocol, model.accountNo];
            UIButton *btn = [self commonBtn:longTitle orgP:CGPointMake(AD(20), maxY + AD(13))];
            btn.tag = [model.accountId integerValue];
            maxY = btn.bottom;
            [btns addObject:btn];
            
            if (i==0) { //default
                btn.selected = YES;
                self.accountId = @(btn.tag);
            }
        }
        self.wallBtns = btns;
    }
}

- (void)touchupComfirmBtn {
    if (self.submitArgsHandler) {
        self.submitArgsHandler(YES, self.accountId, nil);
    }
    [self dismiss];
}

#pragma mark - Common UI

- (UIButton *)commonBtn:(NSString *)title orgP:(CGPoint)p {
    UIButton *btnWall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnWall setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [btnWall setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [btnWall setTitle:[NSString stringWithFormat:@" %@", title] forState:UIControlStateNormal];
    [btnWall setTitleColor:kHexColorAlpha(0xFFFFFF, 0.8) forState:UIControlStateSelected];
    [btnWall setTitleColor:kHexColorAlpha(0xFFFFFF, 0.6) forState:UIControlStateNormal];
    btnWall.titleLabel.font = [UIFont fontPFR14];
    [btnWall sizeToFit];
    btnWall.jk_origin = p;
    [btnWall addTarget:self action:@selector(didClickWalBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnWall];
    
    return btnWall;
}

- (void)didClickWalBtn:(UIButton *)sender {
    for (UIButton *btn in self.wallBtns) {
        btn.selected = NO;
    }
    sender.selected = YES;
    // 回传的是accountID 或者 -1
    self.accountId = @(sender.tag);
    
}

@end
