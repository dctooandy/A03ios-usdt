//
//  A03PopViewModel.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "A03PopViewModel.h"

@implementation A03PopViewModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
- (instancetype)initWithIsShow:(NSString* )isShow
                     WithTitle:(NSString* )title
                      withLink:(NSString* )link
                     withImage:(NSString* )image
              withPreStartDate:(NSString* )preStartDate
                 withreEndDate:(NSString* )preEndDate
                 withStartDate:(NSString* )startDate
                   withEndDate:(NSString* )endDate
{
    self = [super init];
    _isShow = isShow;
    _title = title;
    _link = link;
    _image = image;
    _preStartDate = preStartDate;
    _preEndDate = preEndDate;
    _startDate = startDate;
    _endDate = endDate;
    return  self;
}


@end
