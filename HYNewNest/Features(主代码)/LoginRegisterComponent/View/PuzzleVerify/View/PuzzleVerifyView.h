//
//  PuzzleVerifyView.h
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PuzzleVerifyView;

/**
 * Verification changed callback delegate
 */
@protocol PuzzleVerifyViewDelegate <NSObject>
- (void)puzzleVerifyView:(PuzzleVerifyView *)puzzleVerifyView didChangedPuzzlePosition:(CGPoint)newPosition
             xPercentage:(CGFloat)xPercentage yPercentage:(CGFloat)yPercentage;
@end

/**
 * PuzzleVerifyView
 */
@interface PuzzleVerifyView : UIView
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *shadeImage;
@property (nonatomic, strong) UIImage *cutoutImage;  // Image for verification
@property (nonatomic, assign) CGSize puzzleSize;


// Puzzle current position
@property (nonatomic, assign) CGPoint puzzlePosition;

// Puzzle current X and Y position percentage, range: [0, 1]
@property (nonatomic, assign) CGFloat puzzleXPercentage;
@property (nonatomic, assign) CGFloat puzzleYPercentage;

/**
 * Style
 */
// Puzzle shadow
@property (nonatomic, strong) UIColor *puzzleShadowColor; // Default: black
@property (nonatomic, assign) CGFloat puzzleShadowRadius; // Default: 4
@property (nonatomic, assign) CGFloat puzzleShadowOpacity; // Default: 0.5
@property (nonatomic, assign) CGSize puzzleShadowOffset; // Default: (0, 0)

// Callback
@property (nonatomic, weak) id <PuzzleVerifyViewDelegate> delegate; // Callback delegate

- (void)performCallback;

@end

NS_ASSUME_NONNULL_END
