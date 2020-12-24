//
//  IVNUtility.m
//  IVNetworkLibrary2.0
//
//  Created by key.l on 13/09/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVNUtility.h"

@implementation IVNUtility
+ (void)log:(NSString *)format, ...
{
#if DEBUG
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("%s",[str UTF8String]);
#endif
}
@end
