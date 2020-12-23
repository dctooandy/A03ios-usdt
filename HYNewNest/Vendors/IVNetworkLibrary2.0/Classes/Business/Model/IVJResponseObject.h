//
//  IVJResponseObject.h
//  IVNetworkLibrary2.0
//
//  Created by Key on 17/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVJResponseHead : JSONModel
@property (nonatomic, assign) NSUInteger cost;
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errMsg;
@end

@interface IVJResponseObject : NSObject
@property (nonatomic, strong) id body;
@property (nonatomic, strong) IVJResponseHead *head;
@end

NS_ASSUME_NONNULL_END
