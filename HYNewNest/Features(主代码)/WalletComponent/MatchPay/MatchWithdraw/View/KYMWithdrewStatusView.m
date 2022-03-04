//
//  KYMWithdrewStatusView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewStatusView.h"

@interface KYMWithdrewStatusView ()
@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *selectedImgArray;
@end
@implementation KYMWithdrewStatusView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
        [self setupStatusItemView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)setupStatusItemView
{
    self.statusTitleArray = @[@"已提交",@"等待付款",@"待确认到账",@"取款完成"];
    self.imgArray = @[@"mwd_已提交-hover取",@"mwd_等待付款-取",@"mwd_待确认到账-取",@"mwd_取款完成-取"];
    self.selectedImgArray = @[@"mwd_已提交-hover取",@"mwd_等待付款-hover取",@"mwd_待确认到账-hover取",@"mwd_取款完成-hover取"];
    for (int i = 0; i < self.statusTitleArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 1130 + i;
        imageView.image = [UIImage imageNamed:self.imgArray[i]];
        [self.statusItemView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = self.statusTitleArray[i];
        lable.font = [UIFont fontWithName:@"PingFang SC Regular" size:14];
        lable.textColor =  [UIColor colorWithRed:0x67 / 255.0 green:0x67 / 255.0 blue:0x67 / 255.0 alpha:1];
        lable.tag = 1230 + i;
        [self.statusItemView addSubview:lable];
        
        if (i != self.statusTitleArray.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.tag = 1330 + i;
            line.backgroundColor = [UIColor colorWithRed:0xFF /255.0 green:0xFF /255.0  blue:0xFF /255.0  alpha:0.1];
            [self.statusItemView addSubview:line];
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgW = 42;
    CGFloat imgH = 42;
    [self.statusItemView layoutIfNeeded];
    CGFloat mergin = (CGRectGetWidth(self.statusItemView.frame) - imgW * 4) / 3.0;
    for (int i = 0; i < self.statusTitleArray.count; i++) {
        UIImageView *imageView = [self.statusItemView viewWithTag:1130 + i];
        CGFloat imgX = (imgW + mergin) * i;
        imageView.frame = CGRectMake(imgX, 0, imgW, imgH);
        
        UILabel *label = [self.statusItemView viewWithTag:1230 + i];
        CGFloat labelH = 20;
        CGFloat labelY = CGRectGetMaxY(imageView.frame) + 5;
        CGFloat lableW = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil].size.width;
        CGFloat labelX = CGRectGetMidX(imageView.frame) - lableW * 0.5;
        label.frame = CGRectMake(labelX, labelY, lableW, labelH);
        
        if (i != self.statusTitleArray.count - 1) {
            UIView *line = [self.statusItemView viewWithTag:1330 + i];;
            CGFloat lineW = mergin - 4;
            CGFloat lineH = 1;
            CGFloat lineX = CGRectGetMaxX(imageView.frame) + 2;
            CGFloat lineY = CGRectGetMidY(imageView.frame) - lineH;
            line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        }
    }
}

- (void)setStep:(KYMWithdrewStep)step
{
    _step = step;
    int realStep = 1;
    switch (step) {
        case KYMWithdrewStepOne:{
            realStep = 1;
            self.stautsLB1.text = @"已经提交取款订单，系统审核中...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF9 / 255.0 green:0xBD / 255.0 blue:0x52 / 255.0 alpha:1];
            self.statusLB2.text = @"耐心等待5秒到1分钟即可";
            self.statusLB2.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12] ;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        }
        case KYMWithdrewStepTwo:{
            realStep = 2;
            self.stautsLB1.text = @"审核通过，系统付款中，请等待付款通知...";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xF9 / 255.0 green:0xBD / 255.0 blue:0x52 / 255.0 alpha:1];
            self.statusLB2.text = @"取款到账后，请务必在15分钟内点击确认到账";
            self.statusLB2.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        }
        case KYMWithdrewStepThree:{
            realStep = 3;
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.text = @"请在";
            self.statusLB2.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
            self.statusLB3.hidden = NO;
            self.statusLB4.hidden = NO;
            break;
        }
        case KYMWithdrewStepFour:{
            realStep = 3;
            self.stautsLB1.text = @"订单已付款，请您核实银行卡是否到账";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.text = @"未确认到账，订单异常";
            self.statusLB2.textColor = [UIColor colorWithRed:0xF9 / 255.0 green:0xBD / 255.0 blue:0x52 / 255.0 alpha:1];
            self.statusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:15];
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        }
        case KYMWithdrewStepFive:{
            realStep = 4;
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        }
        case KYMWithdrewStepSix:{
            realStep = 4;
            self.stautsLB1.text = @"您完成了一笔取款";
            self.stautsLB1.textColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.4];
            self.statusLB2.hidden = YES;
            self.statusLB3.hidden = YES;
            self.statusLB4.hidden = YES;
            break;
        }
            
        default:
            break;
    }
    for (int i = 0; i < realStep; i++) {
        UIImageView *image = [self.statusItemView viewWithTag:1130 + i];
        image.image = [UIImage imageNamed:self.selectedImgArray[i]];
        UILabel *label = [self.statusItemView viewWithTag:1230 + i];
        label.textColor =  [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:1];
    }
    CGFloat lable2W = [self.statusLB2.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.statusLB2.font} context:nil].size.width + 10;
    self.statusLB2Width.constant = lable2W;
}

@end
