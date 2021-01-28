//
//  DSBProfitBoardCell.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBProfitBoardCell.h"
#import "BYDashenBoardConst.h"


@interface DSBProfitBoardCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *hallTableNumLbl;
@property (weak, nonatomic) IBOutlet UIButton *isOnTableFlag;

@property (weak, nonatomic) IBOutlet UILabel *playTypeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *previosAmountLbl;
// 庄赢 闲赢 和
@property (weak, nonatomic) IBOutlet UILabel *gameStatusColrLbl;

// 盈利 1234.. usdt
@property (weak, nonatomic) IBOutlet UILabel *cusAccountLbl;
// ..点
@property (weak, nonatomic) IBOutlet UILabel *bankerPointLbl;
@property (weak, nonatomic) IBOutlet UILabel *playerPointLbl;


@end

@implementation DSBProfitBoardCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupPrListItem:(PrListItem *)item {
    NSString *currency = item.currency.lowercaseString;
    _timeLbl.text = [item.billTime componentsSeparatedByString:@" "].lastObject;
    
    NSDate *billTime = [NSDate jk_dateWithString:item.billTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval interval = [billTime timeIntervalSinceNow];
    _isOnTableFlag.hidden = fabs(interval) > 60*5; //5分钟内在桌
    
    _hallTableNumLbl.text = [item.tableCode stringByAppendingString:@"桌"];
    
    _playTypeNameLbl.text = item.playTypeName;
    
    // 根据哪方赢 修改背景色 和 文字
    if (item.bankerPoint > item.playerPoint) {
        _gameStatusColrLbl.layer.backgroundColor = [kZhuanColor CGColor];
        _gameStatusColrLbl.text = @"庄赢";
    } else if (item.bankerPoint == item.playerPoint) {
        _gameStatusColrLbl.layer.backgroundColor = [kHeColor CGColor];
        _gameStatusColrLbl.text = @"和";
    } else {
        _gameStatusColrLbl.layer.backgroundColor = [kXianColor CGColor];
        _gameStatusColrLbl.text = @"闲赢";
    }
    
    _previosAmountLbl.text = [[item.previosAmount jk_toDisplayNumberWithDigit:2] stringByAppendingString:currency];
    
    _cusAccountLbl.text = [NSString stringWithFormat:@"盈利 %@ %@" , [item.cusAccount jk_toDisplayNumberWithDigit:2], currency];
    _bankerPointLbl.text = [NSString stringWithFormat:@"%ld点", (long)item.bankerPoint];
    _playerPointLbl.text = [NSString stringWithFormat:@"%ld点", (long)item.playerPoint];
}

@end
