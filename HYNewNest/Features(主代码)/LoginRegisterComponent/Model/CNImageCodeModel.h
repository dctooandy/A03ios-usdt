//
//  CNImageCodeModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 图片验证码模型
@interface CNImageCodeModel : CNBaseModel
@property (nonatomic, copy) NSString *captchaId;
@property (nonatomic, copy) NSString *image;

/// 解码data后的图片
@property (nonatomic, strong) UIImage *decodeImage;
/// 汉字验证码需要
@property (nonatomic, strong) NSArray <NSString *> *specifyWord;
@end

NS_ASSUME_NONNULL_END
