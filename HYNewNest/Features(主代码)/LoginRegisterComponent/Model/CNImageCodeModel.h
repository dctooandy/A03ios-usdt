//
//  CNImageCodeModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNImageCodeModel : CNBaseModel
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) UIImage *decodeImage;
@end

NS_ASSUME_NONNULL_END
