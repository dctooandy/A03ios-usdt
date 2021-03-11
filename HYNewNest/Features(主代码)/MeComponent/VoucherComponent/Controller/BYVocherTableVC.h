//
//  BYVocherTableVC.h
//  HYNewNest
//
//  Created by zaky on 3/10/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BYVocherTagList) {
    BYVocherTagListInReview = 0,
    BYVocherTagListUsing,
    BYVocherTagListEnded
};

@interface BYVocherTableVC : UITableViewController
@property (nonatomic, assign) BYVocherTagList listType;
- (void)loadData;
- (instancetype)initWithType:(BYVocherTagList)type;

@end

NS_ASSUME_NONNULL_END
