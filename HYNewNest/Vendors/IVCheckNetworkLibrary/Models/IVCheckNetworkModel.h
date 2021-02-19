//
//  IVCheckNetworkModel.h
//  IVCheckNetwork
//
//  Created by Key on 13/08/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVCheckDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IVCheckNetworkModel : NSObject
@property (nonatomic, copy) NSArray *urls;
@property (nonatomic, copy) NSString *currentUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *fullTitle;
@property (nonatomic, assign) IVKCheckNetworkType type;

@property (nonatomic, strong, readonly) NSMutableArray<IVCheckDetailModel *> *detailModels;
@end

NS_ASSUME_NONNULL_END
