//
//  PuzzleVerifyPopoverView.h
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleVerifyViewModel.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSInteger const kBTTLoginOrRegisterCaptchaPuzzle;

@class PuzzleVerifyView;
@protocol PuzzleVerifyPopoverViewDelegate;

@interface PuzzleVerifyPopoverView : UIView
@property(nonatomic, readonly) NSString *ticket;
@property(nonatomic, readonly) NSString *captchaId;
@property(nonatomic, assign) BOOL correct;
@property(nonatomic, weak)id<PuzzleVerifyPopoverViewDelegate> delegate;
@property(nonatomic, strong) PuzzleVerifyViewModel *viewModel;
- (void)reset;
- (void)getPuzzleImageCodeForceRefresh:(BOOL)forceRefresh;
@end

@protocol PuzzleVerifyPopoverViewDelegate <NSObject>
- (void)puzzleViewVerifySuccess:(PuzzleVerifyPopoverView *)puzzleView;
@end

NS_ASSUME_NONNULL_END
