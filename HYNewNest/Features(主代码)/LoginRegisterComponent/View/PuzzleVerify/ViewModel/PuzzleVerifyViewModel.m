//
//  PuzzleVerifyViewModel.m
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "PuzzleVerifyViewModel.h"
#import "CNCaptchaRequest.h"
#import "CNPuzzleImageCodeModel.h"

@implementation PuzzleVerifyViewModel

- (void)generatePuzzleImageCodeWithCompletion:(void (^)(CGPoint puzzlePosition,UIImage *originImage, UIImage *cutoutImage, UIImage *shadeImage))completion errorCompletion:(void(^)(NSString *))errorCompletion {
    [CNCaptchaRequest getPuzzleImageCode:self.codeType completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            CNPuzzleImageCodeModel *model = [CNPuzzleImageCodeModel cn_parse:responseObj];
            self.captchaId = model.captchaId;
            !completion?:completion(model.puzzlePosition,
                                    model.decodeOriginImage,
                                    model.decodeCutoutImage,
                                    model.decodeShadeImage);
        } else {
            !errorCompletion?:errorCompletion(errorMsg);
        }
    }];
}

- (void)verifyPuzzleImageCodeWithCompletion:(void(^)(BOOL validateResult, NSString *ticket, NSString *errorMsg))completion {
    [CNCaptchaRequest verifyPuzzleImageCode:self.codeType captcha:self.captcha captchaId:self.captchaId handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            CNPuzzleVerifyModel *model = [CNPuzzleVerifyModel cn_parse:responseObj];
            !completion?:completion(model.validateResult, model.ticket, nil);
        } else {
            !completion?:completion(NO, @"", errorMsg);
        }
    }];
}

@end
