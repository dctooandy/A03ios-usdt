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

@property (weak, nonatomic) IBOutlet UILabel *gameStatusColrLbl;


@end

@implementation DSBProfitBoardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _gameStatusColrLbl.layer.backgroundColor = [kHeColor CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
