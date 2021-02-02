//
//  CNDashenBoardVC.h
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"
#import "BYDashenBoardConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNDashenBoardVC : CNBaseVC
@property (nonatomic, weak) id <DashenBoardAutoHeightDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
