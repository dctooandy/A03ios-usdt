//
//  IVCheckHttpManager.h
//  IVCheckNetworkLibrary
//
//  Created by Key on 25/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "KYHTTPManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVCheckRequest : KYHTTPManager
@property (nonatomic, copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
