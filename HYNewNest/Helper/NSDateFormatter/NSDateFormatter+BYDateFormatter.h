//
//  NSDateFormatter+BYDateFormatter.h
//  HYNewNest
//
//  Created by RM04 on 2021/8/11.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (BYDateFormatter)
- (NSDate *)monthOfFirstDate;
- (NSDate *)monthOfEndDate;
@end

NS_ASSUME_NONNULL_END
