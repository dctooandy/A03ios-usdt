//
//  IVCNetworkStatusView.h
//  IVNetworkDemo
//
//  Created by Key on 2018/8/31.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVCheckNetworkModel.h"

@interface IVCNetworkStatusView : UIView
@property (nonatomic, copy) NSArray<IVCheckNetworkModel *> *datas;
@property (nonatomic ,copy) void (^detailBtnClickedBlock)(void);
- (void)startCheck;
+ (void)showToastWithMessage:(NSString *)message superView:(UIView *)superView;
@end
