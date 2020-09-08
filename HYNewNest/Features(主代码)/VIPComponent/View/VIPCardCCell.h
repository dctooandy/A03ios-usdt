//
//  VIPCardCCell.h
//  HYNewNest
//
//  Created by zaky on 8/31/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIPCardCCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbReachNum;
@property (copy,nonatomic) NSString *cardName;
@property (copy, nonatomic) NSString *duzunName;//独尊是否显示以及她的名字，如果不现实传空字符
@end

NS_ASSUME_NONNULL_END
