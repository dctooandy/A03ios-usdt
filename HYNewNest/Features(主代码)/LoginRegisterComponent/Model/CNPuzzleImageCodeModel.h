//
//  CNPuzzleImageCodeModel.h
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNPuzzleImageCodeModel : CNBaseModel
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, copy) NSString *originImage;
@property (nonatomic, copy) NSString *cutoutImage;
@property (nonatomic, copy) NSString *shadeImage;
@property (nonatomic, copy) NSString *captchaId;

@property (nonatomic, readonly) UIImage *decodeOriginImage;
@property (nonatomic, readonly) UIImage *decodeCutoutImage;
@property (nonatomic, readonly) UIImage *decodeShadeImage;
@property (nonatomic, readonly) CGPoint puzzlePosition;
@end

@interface CNPuzzleVerifyModel : CNBaseModel
@property (nonatomic, assign) BOOL validateResult;
@property (nonatomic, copy) NSString *ticket;
@end

NS_ASSUME_NONNULL_END
