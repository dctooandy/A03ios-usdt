//
//  A03PopViewModel.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface A03PopViewModel : NSObject
@property (nonatomic, copy) NSString *isShow;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *preStartDate;

@property (nonatomic, copy) NSString *preEndDate;

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;
- (instancetype)initWithIsShow:(NSString* )isShow
                     WithTitle:(NSString* )title
                      withLink:(NSString* )link
                     withImage:(NSString* )image
              withPreStartDate:(NSString* )preStartDate
                 withreEndDate:(NSString* )preEndDate
                 withStartDate:(NSString* )startDate
                   withEndDate:(NSString* )endDate;
@end


