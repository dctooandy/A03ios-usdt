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
@property (strong,nonatomic) NSString *cardName; 
@end

NS_ASSUME_NONNULL_END
