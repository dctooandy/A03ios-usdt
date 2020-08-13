//
//  HYArticalTableViewController.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNGloryRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYArticalTableViewController : UITableViewController
@property (nonatomic, assign) A03ArticleTagList listType;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
