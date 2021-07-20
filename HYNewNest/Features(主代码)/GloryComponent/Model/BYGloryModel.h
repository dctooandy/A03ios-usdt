//
//  BYGloryModel.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYGloryModel : CNBaseModel
@property (nonatomic, copy) NSString *abstractName;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *publishDate;

@end

@interface GloryBannerModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, assign) BOOL hideButton;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageName:(NSString *)imageName hideButton:(BOOL)hideButton webURL:(NSString *)webURL;
@end

NS_ASSUME_NONNULL_END
