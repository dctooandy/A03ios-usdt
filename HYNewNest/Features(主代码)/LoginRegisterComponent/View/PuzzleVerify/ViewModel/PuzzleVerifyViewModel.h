//
//  PuzzleVerifyViewModel.h
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PuzzleVerifyViewModel : NSObject
@property(nonatomic, assign) NSUInteger codeType;
@property(nonatomic, copy) NSString *captcha;
@property(nonatomic, copy) NSString *captchaId;

- (void)generatePuzzleImageCodeWithCompletion:(void(^)(CGPoint puzzlePosition,UIImage *originImage, UIImage *cutoutImage, UIImage *shadeImage))completion errorCompletion:(void(^)(NSString *))errorCompletion;
- (void)verifyPuzzleImageCodeWithCompletion:(void(^)(BOOL validateResult, NSString *ticket, NSString *errorMsg))completion;
@end

NS_ASSUME_NONNULL_END
