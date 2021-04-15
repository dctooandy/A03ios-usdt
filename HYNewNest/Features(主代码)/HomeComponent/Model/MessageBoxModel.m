//
//  MessageBoxModel.m
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "MessageBoxModel.h"

@implementation MessageBoxModel

- (void)setParmas:(NSString *)parmas {
    _parmas = parmas;
    NSDictionary *dict = [parmas jk_dictionaryValue];
    self.parmasDict = dict;
}

- (NSString *)level {
    if ([self.parmasDict.allKeys containsObject:@"level"]) {
        return self.parmasDict[@"level"];
    } else {
        return nil;
    }
}

- (NSString *)fixedLevel {
    if ([self.parmasDict.allKeys containsObject:@"fixedLevel"]) {
        return self.parmasDict[@"fixedLevel"];
    } else {
        return nil;
    }
}


@end
