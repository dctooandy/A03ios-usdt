//
//  BYWithdrawYuEBaoTableViewCell.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYWithdrawTableViewCell.h"
#import "UILabel+Gradient.h"

@interface BYWithdrawTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *withdrawImageView;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BYWithdrawTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndexRow:(NSInteger)row {
    UIImage *image;
    NSString *title;
    NSString *subTitle;
    
    switch (row) {
        case 0:{
            image = [UIImage imageNamed:@"icon_YuEBao"];
            title = @"转入余额宝";
            subTitle = @"年化收益18%";
            [self.suggestionImageView setHidden:false];
            break;
        }
        case 1:{
            image = [UIImage imageNamed:@"icon_withdraw"];
            title = @"提币";
            subTitle = @"提币到数字钱包";
            [self.suggestionImageView setHidden:true];
            break;
        }
        case 2:{
            image = [UIImage imageNamed:@"icon_sell"];
            title = @"卖币";
            subTitle = @"数字钱包兑现";
            [self.suggestionImageView setHidden:true];
            break;
        }
        default:
            break;
    }
    
    [self.withdrawImageView setImage:image];
    [self.titleLabel setText:title];
    [self.subTitleLabel setText:subTitle];
    
    
}

@end
