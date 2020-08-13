//
//  CNImageCodeModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNImageCodeModel.h"
#import "GTMBase64.h"

@implementation CNImageCodeModel
- (UIImage *)decodeImage {
    NSData *data = [self.image dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *imgData = [GTMBase64 decodeData:data];
    UIImage *img = [UIImage imageWithData:imgData];
    return img;
}
@end
