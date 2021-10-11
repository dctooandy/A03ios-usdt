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

@interface GloryBannerModel ()
@property (nonatomic, strong) NSArray *webURLs; // For CNY/USDT please set CNY URL to first Object
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

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageName:(NSString *)imageName hideButton:(BOOL)hideButton webURLs:(NSArray<NSString *> *)webURLs {
    self = [super init];
    self.title = title;
    self.content = content;
    self.imageName = imageName;
    self.hideButton = hideButton;
    self.webURLs = webURLs;
    return self;
}

- (NSString *)webURL {
    if (self.webURLs == nil) {
        return _webURL;
    }
    
    if ([CNUserManager shareManager].isLogin == false) {
        return self.webURLs[0];
    }
    
    return [CNUserManager shareManager].isUsdtMode ? self.webURLs[1] : self.webURLs[0];
}

@end
