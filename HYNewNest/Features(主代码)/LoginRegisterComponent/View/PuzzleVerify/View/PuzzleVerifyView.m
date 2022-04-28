//
//  PuzzleVerifyView.m
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "PuzzleVerifyView.h"

static CGSize kBTTPuzzleDefaultSize;

@interface PuzzleVerifyView ()

@property (nonatomic, strong) UIImageView *frontImageView;

@property (nonatomic, strong) UIImageView *puzzleImageView;
@property (nonatomic, strong) UIView *puzzleImageContainerView;
@property (nonatomic, assign) CGPoint puzzleContainerPosition;

@property (nonatomic, assign) BOOL lastVerification;
@end

@implementation PuzzleVerifyView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if (_frontImageView) {
        return;
    }
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;

    // Init value
    kBTTPuzzleDefaultSize = CGSizeMake(50, 51);
    self.puzzleSize = kBTTPuzzleDefaultSize;
    self.puzzlePosition = CGPointMake(20, 20);

    self.puzzleShadowColor = [UIColor blackColor];
    self.puzzleShadowRadius = 4;
    self.puzzleShadowOpacity = 0.5;
    self.puzzleShadowOffset = CGSizeZero;

    // Front puzzle hole image view
    _frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _frontImageView.userInteractionEnabled = NO;
    _frontImageView.contentMode = UIViewContentModeScaleAspectFit;
    _frontImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_frontImageView];

    // Puzzle piece container view
    _puzzleImageContainerView =
    [[UIView alloc] initWithFrame:CGRectMake(_puzzleContainerPosition.x, _puzzleContainerPosition.y,
                                             kBTTPuzzleDefaultSize.width, kBTTPuzzleDefaultSize.height)];
    _puzzleImageContainerView.userInteractionEnabled = NO;
    _puzzleImageContainerView.layer.shadowColor = _puzzleShadowColor.CGColor;
    _puzzleImageContainerView.layer.shadowRadius = _puzzleShadowRadius;
    _puzzleImageContainerView.layer.shadowOpacity = _puzzleShadowOpacity;
    _puzzleImageContainerView.layer.shadowOffset = _puzzleShadowOffset;
    [self addSubview:_puzzleImageContainerView];

    // Puzzle piece imageView
    _puzzleImageView = [[UIImageView alloc] initWithFrame:_puzzleImageContainerView.bounds];
    _puzzleImageView.userInteractionEnabled = NO;
    _puzzleImageView.contentMode = UIViewContentModeScaleAspectFit;
    _puzzleImageView.backgroundColor = [UIColor clearColor];
    [_puzzleImageContainerView addSubview:_puzzleImageView];

    // Pan gesture
//    UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer new];
//    [panGestureRecognizer addTarget:self action:@selector(onPanGesture:)];
//    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Pan gesture

//- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
//    CGPoint panLocation = [panGestureRecognizer locationInView:self];
//
//    // New position
//    CGPoint position = CGPointZero;
//    position.x = panLocation.x - _puzzleSize.width / 2;
//    position.y = panLocation.y - _puzzleSize.height / 2;
//
//    // Update position
//    [self setPuzzlePosition:position];
//
//    // Callback
//    [self performCallback];
//}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];

    _frontImageView.frame = self.bounds;
    _puzzleImageContainerView.frame = CGRectMake(
                _puzzleContainerPosition.x, _puzzleContainerPosition.y,
                                                 _puzzleSize.width, _puzzleSize.height);
    _puzzleImageView.frame = _puzzleImageContainerView.bounds;
}

#pragma mark - Callback

- (void)performCallback {
    // Callback for position change
    if ([_delegate respondsToSelector:@selector(puzzleVerifyView:didChangedPuzzlePosition:xPercentage:yPercentage:)]) {
        [_delegate puzzleVerifyView:self didChangedPuzzlePosition:[self puzzlePosition]
                        xPercentage:[self puzzleXPercentage] yPercentage:[self puzzleYPercentage]];
    }
}

#pragma mark - Setter and getter

// Puzzle position

- (void)setPuzzlePosition:(CGPoint)puzzlePosition {
    // Limit range
    puzzlePosition.x = MAX([self puzzleMinX], puzzlePosition.x);
    puzzlePosition.x = MIN([self puzzleMaxX], puzzlePosition.x);
    
    puzzlePosition.y = MAX([self puzzleMinY], puzzlePosition.y);
    puzzlePosition.y = MIN([self puzzleMaxY], puzzlePosition.y);
    
//    // Reset shadow
//    _puzzleImageContainerView.layer.shadowOpacity = _puzzleShadowOpacity;
    
    // Set puzzle image container position
    [self setPuzzleContainerPosition:CGPointMake(puzzlePosition.x,
                                                 puzzlePosition.y)];
}

- (CGPoint)puzzlePosition {
    return CGPointMake(_puzzleContainerPosition.x,
                       _puzzleContainerPosition.y);
}

// Image

- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
}

- (void)setCutoutImage:(UIImage *)cutoutImage {
    _puzzleImageView.image = cutoutImage;
}

- (void)setShadeImage:(UIImage *)shadeImage {
    _frontImageView.image = shadeImage;
}

// Puzzle size

- (void)setPuzzleSize:(CGSize)puzzleSize {
    _puzzleSize = puzzleSize;
    [self setNeedsLayout];
}

// Puzzle container position

- (void)setPuzzleContainerPosition:(CGPoint)puzzleContainerPosition {
    _puzzleContainerPosition = puzzleContainerPosition;
    CGRect frame = _puzzleImageContainerView.frame;
    frame.origin = puzzleContainerPosition;
    _puzzleImageContainerView.frame = frame;
}

// Puzzle X position percentage

- (CGFloat)puzzleXPercentage {
    return ([self puzzlePosition].x - [self puzzleMinX]) / ([self puzzleMaxX] - [self puzzleMinX]);
}

- (void)setPuzzleXPercentage:(CGFloat)puzzleXPercentage {
    // Limit range
    puzzleXPercentage = MAX(0, puzzleXPercentage);
    puzzleXPercentage = MIN(1, puzzleXPercentage);

    // Change position
    CGPoint position = [self puzzlePosition];
    position.x = puzzleXPercentage * ([self puzzleMaxX] - [self puzzleMinX]) + [self puzzleMinX];
    [self setPuzzlePosition:position];
}

// Puzzle Y position percentage

- (CGFloat)puzzleYPercentage {
    return ([self puzzlePosition].y - [self puzzleMinY]) / ([self puzzleMaxY] - [self puzzleMinY]);
}

- (void)setPuzzleYPercentage:(CGFloat)puzzleYPercentage {    
    // Limit range
    puzzleYPercentage = MAX(0, puzzleYPercentage);
    puzzleYPercentage = MIN(1, puzzleYPercentage);

    // Change position
    CGPoint position = [self puzzlePosition];
    position.y = puzzleYPercentage * ([self puzzleMaxY] - [self puzzleMinY]) + [self puzzleMinY];
    [self setPuzzlePosition:position];
}

// Puzzle position range

- (CGFloat)puzzleMinX {
    return 0;
}

- (CGFloat)puzzleMaxX {
    return CGRectGetWidth(self.bounds) - _puzzleSize.width;
}

- (CGFloat)puzzleMinY {
    return 0;
}

- (CGFloat)puzzleMaxY {
    return CGRectGetHeight(self.bounds) - _puzzleSize.height;
}

// Puzzle shadow

- (void)setPuzzleShadowColor:(UIColor *)puzzleShadowColor {
    _puzzleShadowColor = puzzleShadowColor;
    _puzzleImageContainerView.layer.shadowColor = puzzleShadowColor.CGColor;
}

- (void)setPuzzleShadowRadius:(CGFloat)puzzleShadowRadius {
    _puzzleShadowRadius = puzzleShadowRadius;
    _puzzleImageContainerView.layer.shadowRadius = puzzleShadowRadius;
}

- (void)setPuzzleShadowOpacity:(CGFloat)puzzleShadowOpacity {
    _puzzleShadowOpacity = puzzleShadowOpacity;
    _puzzleImageContainerView.layer.shadowOpacity = puzzleShadowOpacity;
}

- (void)setPuzzleShadowOffset:(CGSize)puzzleShadowOffset {
    _puzzleShadowOffset = puzzleShadowOffset;
    _puzzleImageContainerView.layer.shadowOffset = puzzleShadowOffset;
}

@end
