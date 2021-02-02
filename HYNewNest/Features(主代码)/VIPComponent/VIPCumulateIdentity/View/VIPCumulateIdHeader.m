//
//  VIPCumulateIdHeader.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCumulateIdHeader.h"

@interface VIPCumulateIdHeader ()
@property (weak, nonatomic) IBOutlet UIButton *btnRight0;
@property (weak, nonatomic) IBOutlet UIButton *btnRight1;
@property (weak, nonatomic) IBOutlet UIButton *btnRight2;
@property (weak, nonatomic) IBOutlet UIButton *btnRight3;
@property (weak, nonatomic) IBOutlet UIButton *btnRIght4;
@property (nonatomic, strong) NSArray <UIButton *>* btns;// 5按钮数组
@property (nonatomic, strong) NSArray <NSString *>* ranks;// 所有等级
@property (nonatomic, copy) NSString *selRank; // 选中等级
@property (weak, nonatomic) IBOutlet UILabel *lblLeft;
@end

@implementation VIPCumulateIdHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 头部不能设置背景色 无效 必须设置背景view
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kHexColor(0x181514);
        view;
    });
    
    _selRank = self.ranks[0];
    self.btns = @[self.btnRIght4,self.btnRight3,self.btnRight2,self.btnRight1,self.btnRight0];
    
}


- (IBAction)didTapSwitchRankBtn:(UIButton *)sender {
    
    self.selRank = sender.titleLabel.text;
        
    double xMargin = sender.left - self.lblLeft.left;
    [UIView animateWithDuration:0.0013 * xMargin animations:^{
        //        self.lblLeft.transform = CGAffineTransformMakeTranslation(xMargin, 0);
        //        sender.transform = CGAffineTransformMakeTranslation(-xMargin, 0);
        
        self.lblLeft.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(xMargin*1.4, 0),
                                                         CGAffineTransformMakeScale(0.7, 0.7));
        sender.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-xMargin*0.6, 0),
                                                   CGAffineTransformMakeScale(1.6, 1.6));
        
    } completion:^(BOOL finished) {
        
        self.lblLeft.transform = CGAffineTransformIdentity;
        sender.transform = CGAffineTransformIdentity;
        
        self.selRank = sender.titleLabel.text;
        self.lblLeft.text = [NSString stringWithFormat:@"%@区", self->_selRank];
        NSMutableArray *tmps = [self.ranks mutableCopy];
        [tmps removeObject:self.selRank];
        for (int i=0; i<tmps.count; i++) {
            UIButton *btn = self.btns[i];
            [btn setTitle:tmps[i] forState:UIControlStateNormal];
        }
        
        if (self.didTapBtnBlock) {
            self.didTapBtnBlock(self.selRank);
        }
    }];
}


- (NSArray<NSString *> *)ranks {
    if (!_ranks) {
        _ranks = @[@"赌尊",@"赌神",@"赌圣",@"赌王",@"赌霸",@"赌侠"];
    }
    return _ranks;
}


@end
