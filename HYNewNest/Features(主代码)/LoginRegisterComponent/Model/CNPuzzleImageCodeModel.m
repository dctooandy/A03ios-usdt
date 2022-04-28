//
//  CNPuzzleImageCodeModel.m
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNPuzzleImageCodeModel.h"
#import "GTMBase64.h"

@implementation CNPuzzleImageCodeModel

- (UIImage *)decodeOriginImage {
    NSData *data = [self.originImage dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *imgData = [GTMBase64 decodeData:data];
    UIImage *img = [UIImage imageWithData:imgData];
    return img;
}

- (UIImage *)decodeCutoutImage {
    NSData *data = [self.cutoutImage dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *imgData = [GTMBase64 decodeData:data];
    UIImage *img = [UIImage imageWithData:imgData];
    return img;
}

- (UIImage *)decodeShadeImage {
    NSData *data = [self.shadeImage dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *imgData = [GTMBase64 decodeData:data];
    UIImage *img = [UIImage imageWithData:imgData];
    return img;
}

- (CGPoint)puzzlePosition {
    return CGPointMake(self.x, self.y);
}
@end


@implementation CNPuzzleVerifyModel
@end
