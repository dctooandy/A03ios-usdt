//
//  HYUpdateAlertView.m
//  HYNewNest
//
//  Created by zaky on 8/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYUpdateAlertView.h"
#import "CNTwoStatusBtn.h"
#import "NSAttributedString+Selectable.h"

@interface HYUpdateAlertView()<UITextViewDelegate>
{
    BOOL _isForceUpdate; // 更新弹窗
    
    BOOL _isEndTask; // 新手任务 是否已结束
}
@end

@implementation HYUpdateAlertView

#pragma mark - 升级
+ (void)showWithVersionString:(NSString *)string isForceUpdate:(BOOL)isForce handler:(void (^)(BOOL isComfirm))handler {
    HYUpdateAlertView *a = [[HYUpdateAlertView alloc] initWithVersionString:string isForceUpdate:isForce handler:handler];
    a.frame = [UIScreen mainScreen].bounds;
    [a show];
}

- (instancetype)initWithVersionString:(NSString *)string isForceUpdate:(BOOL)isForce handler:(void (^)(BOOL isComfirm))handler {
    self = [super init];
    
    self.comfirmBlock = handler;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(50);
        make.right.equalTo(self.bgView).offset(-50);
        make.height.mas_equalTo(308);
    }];
    
    _isForceUpdate = isForce;
    if (!isForce) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(byebye) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
            make.top.equalTo(self.contentView).offset(8);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"DL-pic-newer"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.contentView).offset(41);
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"发现新版本";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFSB16];
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [self.contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(imgv.mas_bottom).offset(30);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *lblContent = [[UILabel alloc] init];
    if (string.length > 6) {
        lblContent.text = string;
    } else {
        lblContent.text = [NSString stringWithFormat:@"最新版本 V%@",string];
    }
    lblContent.font = [UIFont fontPFR14];
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    lblContent.numberOfLines = 0;
    [self.contentView addSubview:lblContent];
    [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AD(22));
        make.right.equalTo(self.contentView).offset(AD(-22));
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
    }];
    [lblContent sizeToFit];
    
    CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
    [btn setTitle:@"立即更新版本" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = YES;
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self.contentView).offset(-23);
    }];
    
    [self.contentView addCornerAndShadow];
        
    return self;
}

#pragma mark 首充
+ (void)showFirstDepositOrTaskEndIsEnd:(BOOL)isTaskEnd handler:(void(^)(BOOL isComfm))handler{
    
    HYUpdateAlertView *a = [[HYUpdateAlertView alloc] init];
    a.frame = [UIScreen mainScreen].bounds;
    a->_isEndTask = isTaskEnd;
    a.comfirmBlock = handler;
    [a setupFDP];
    [a show];
}

- (void)setupFDP {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(30);
        make.right.equalTo(self.bgView).offset(-30);
        make.height.mas_equalTo(_isEndTask?246:284);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(byebye) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"温馨提示";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontPFSB16];
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [self.contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kHexColorAlpha(0xFFFFFF, 0.08);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(lblTitle.mas_bottom);
    }];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:_isEndTask?@"pop_img2":@"pop_img1"];
    imgv.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.contentView).offset(72);
    }];
    
    
    if (_isEndTask) { //活动已结束
        UILabel *lblContent = [[UILabel alloc] init];
        lblContent.text = @"很抱歉，活动已结束";
        lblContent.font = [UIFont fontPFR14];
        lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
        lblContent.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lblContent];
        [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(AD(22));
            make.right.equalTo(self.contentView).offset(AD(-22));
            make.top.equalTo(imgv.mas_bottom).offset(20);
        }];
        [lblContent sizeToFit];
        
        UITextView *lblDown = [[UITextView alloc] init];
        lblDown.linkTextAttributes = @{};
        lblDown.backgroundColor = [UIColor clearColor];
        lblDown.attributedText = [NSAttributedString attributeText:@"" selectableText:@"去看看其他优惠活动" selectableColor:kHexColor(0x46D9FF) isUnderline:YES URLStr:@""];
        lblDown.delegate = self;
        lblDown.editable = NO;
        lblDown.scrollEnabled = NO;
        [self.contentView addSubview:lblDown];
        [lblDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(AD(22));
            make.right.equalTo(self.contentView).offset(AD(-22));
            make.top.equalTo(lblContent.mas_bottom).offset(2);
        }];
        [lblDown sizeThatFits:CGSizeMake(self.contentView.width, 28)];
        
    } else { // 完成首充任务
        NSString *string = @"完成首次充值任务，解锁累计登录和限时充值奖励";
        NSString *highStr = @"首次充值";
        UILabel *lblContent = [[UILabel alloc] init];
        lblContent.numberOfLines = 0;
        lblContent.textAlignment = NSTextAlignmentCenter;
        lblContent.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:kHexColor(0xEEEEEE), NSFontAttributeName:[UIFont fontPFR14]}];
        NSRange rang = [string rangeOfString:highStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:kHexColor(0x46D9FF) range:rang];
        lblContent.attributedText = attStr;
        [self.contentView addSubview:lblContent];
        [lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(AD(30));
            make.right.equalTo(self.contentView).offset(AD(-30));
            make.top.equalTo(imgv.mas_bottom).offset(6);
            make.height.mas_equalTo(44);
        }];
        [lblContent sizeToFit];
        
        CNTwoStatusBtn *btn = btn = [[CNTwoStatusBtn alloc] init];
        [btn setTitle:@"立即充值" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = YES;
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(245);
            make.height.mas_equalTo(48);
            make.bottom.equalTo(self.contentView).offset(-23);
        }];
        
    }
    
    [self.contentView addCornerAndShadow];
}


#pragma mark - Public

- (void)byebye {
    if (self.comfirmBlock) {
        self.comfirmBlock(NO);
    }
    [self dismiss];
}

- (void)comfirmClick {
    if (self.comfirmBlock) {
        self.comfirmBlock(YES);
    }
    if (!_isForceUpdate) {
        [self dismiss];
    }
}


#pragma mark - Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    [self comfirmClick];
    return NO;
}

@end
