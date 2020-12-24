//
//  IVJResponseObject.m
//  IVNetworkLibrary2.0
//
//  Created by Key on 17/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVJResponseObject.h"

@implementation IVJResponseHead
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation IVJResponseObject
- (IVJResponseHead *)head
{
    if (!_head) {
        _head = [[IVJResponseHead alloc] init];
    }
    return _head;
}
@end
