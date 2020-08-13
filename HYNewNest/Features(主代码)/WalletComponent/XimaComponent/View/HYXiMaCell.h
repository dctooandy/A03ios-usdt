//
//  HYXiMaCell.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYXiMaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblXimaAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblBetAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;

@property (nonatomic, assign) BOOL isChoose;
@end

NS_ASSUME_NONNULL_END
