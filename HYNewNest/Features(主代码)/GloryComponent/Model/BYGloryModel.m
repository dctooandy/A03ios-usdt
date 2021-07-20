//
//  BYGloryModel.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryModel.h"

@implementation BYGloryModel

- (NSString *)publishDate {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    serverDateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *serverDate = [serverDateFormatter dateFromString:_publishDate];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    localDateFormatter.dateFormat = @"YYYY年MM月";
    
    return [localDateFormatter stringFromDate:serverDate];
}

@end

@implementation GloryBannerModel
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageName:(NSString *)imageName hideButton:(BOOL)hideButton webURL:(NSString *)webURL{
    self = [super init];
    self.title = title;
    self.content = content;
    self.imageName = imageName;
    self.hideButton = hideButton;
    self.webURL = webURL;
    return self;
}

@end
