//
//  MineBindView.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/10.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "MineBindView.h"
#import "CNNormalInputView.h"
#import "CNTwoStatusBtn.h"
#import "NSString+Validation.h"

@interface MineBindView () <CNNormalInputViewDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, copy) void(^clickBlock)(NSString* text);
@property (weak, nonatomic) CNNormalInputView *inputTF;
@property (nonatomic, weak) CNTwoStatusBtn *btn;
@property (nonatomic, assign) HYBindType bindType;
@end

@implementation MineBindView

- (instancetype)initWithBindType:(HYBindType)bindType
                    comfirmBlock:(void(^)(NSString *text))comfirmBlock {
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    self.bindType = bindType;
    self.clickBlock = comfirmBlock;
    
    // 半透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavPlusStaBarHeight)];
    bgView.backgroundColor = kHexColorAlpha(0x000000, 0.4);
    [self addSubview:bgView];
    
      // 主背景
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavPlusStaBarHeight, kScreenWidth, 230+kSafeAreaHeight)];
    self.mainView = mainView;
    mainView.tag = 150;
    mainView.backgroundColor = kHexColor(0x212137);
    [self addSubview:mainView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mainView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = mainView.bounds;
    mainView.layer.mask = layer;
    [bgView addSubview:mainView];
    
    // 标题
    UILabel *lblSex = [[UILabel alloc] init];
    lblSex.frame = CGRectMake(0, 0, kScreenWidth, 50);
    lblSex.text = bindType == HYBindTypeWechat?@"绑定微信号":@"绑定电子邮箱";
    lblSex.textAlignment = NSTextAlignmentCenter;
    lblSex.font = [UIFont fontPFM16];
    lblSex.textColor = [UIColor whiteColor];
    [lblSex jk_addBottomBorderWithColor:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5];
    [mainView addSubview:lblSex];
    
      // 关闭按钮
    UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancle setImage:[UIImage imageNamed:@"modal-close"] forState:UIControlStateNormal];
    btnCancle.frame = CGRectMake(CGRectGetWidth(bgView.frame)-30-10, 10, 30, 30);
    [btnCancle addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnCancle];
    
    //input
    CNNormalInputView *inputView = [[CNNormalInputView alloc] initWithFrame:CGRectMake(30, lblSex.bottom, kScreenWidth-60, 89)];
    self.inputTF = inputView;
    inputView.delegate = self;
    [inputView setPlaceholder:bindType==HYBindTypeWechat?@"请输入您的微信号":@"请输入您的电子邮箱地址"];
    [mainView addSubview:inputView];
    
    //btn
    CNTwoStatusBtn *btn = [[CNTwoStatusBtn alloc] initWithFrame:CGRectMake(30, inputView.bottom+30, kScreenWidth - 60, 48)];
    self.btn = btn;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = kScreenHeight-kNavPlusStaBarHeight - 230 - kSafeAreaHeight;
    }];
    
    return self;
}

- (void)inputViewTextChange:(CNNormalInputView *)view {
    BOOL isCorrect = NO;
    if (self.bindType == HYBindTypeWechat) {
        if ([view.text validationType:ValidationTypeWechat]) {
            isCorrect = YES;
        }
    } else  {
        if ([view.text validationType:ValidationTypeMail]) {
            isCorrect = YES;
        }
    }
    
    if (isCorrect) {
        view.wrongAccout = NO;
        self.btn.enabled = YES;
    } else {
        [view showWrongMsg:[NSString stringWithFormat:@"请输入正确的%@",self.bindType == HYBindTypeWechat?@"微信号":@"邮箱号"]];
        self.btn.enabled = NO;
    }
}

- (void)submitClick {
    if (self.clickBlock) {
        self.clickBlock(self.inputTF.text);
    }
    [self removeView];
}

- (void)removeView{
    UIView *mainView = [self viewWithTag:150];
    
    [UIView animateWithDuration:0.25 animations:^{
        mainView.y = kScreenHeight-kNavPlusStaBarHeight;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}

@end
