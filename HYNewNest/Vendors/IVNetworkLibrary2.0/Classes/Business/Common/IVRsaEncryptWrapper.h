//
//  IVRsaEncryptWrapper.h
//  IVNetworkLibrary2.0
//
//  Created by Key on 24/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVRsaEncryptWrapper : NSObject

/**
 ras 加密

 @param string 待加密串
 @return 加密后的串
 */
+ (NSString *)encryptorString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
