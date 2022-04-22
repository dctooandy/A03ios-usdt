//
//  PuzzleVerifyPopoverView.m
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "PuzzleVerifyPopoverView.h"

#import "PuzzleVerifyPopoverView.h"
#import "PuzzleVerifyView.h"
#import <Masonry/Masonry.h>

NSInteger const kBTTLoginOrRegisterCaptchaPuzzle = 3;

@interface PuzzleVerifyPopoverView()<PuzzleVerifyViewDelegate>

@property(nonatomic, strong) UIImage *cutoutImage;
@property(nonatomic, strong) UIImage *originImage;
@property(nonatomic, strong) UIImage *shadeImage;
@property(nonatomic, assign) CGPoint puzzlePosition;

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) PuzzleVerifyView *verifyView;
@property(nonatomic,strong) UIView *slidView;
@property(nonatomic,strong) UILabel *slidTitle;
@property(nonatomic,strong) UISlider *slider;
@property(nonatomic,strong) UIView *innerView;

@property(nonatomic,assign) BOOL sliding;
@property(nonatomic,strong) CAGradientLayer *gradientLayer;
@property(nonatomic,strong) CABasicAnimation *locationAnimation;
@property(nonatomic,strong) UIButton *refreshButton;

@end

@implementation PuzzleVerifyPopoverView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
        [self setLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setLayout];
    }
    return self;
}

-(void)setupUI {
    self.alpha = 0;
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.verifyView];
    
    [self addSubview:self.slidView];
    [self.slidView addSubview:self.innerView];
    [self.slidView addSubview:self.slidTitle];
    [self.slidView addSubview:self.slider];

    [self addSubview:self.refreshButton];
}

-(void)setLayout {
    [self.verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(95);
    }];
    
    [self.slidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    [self.slidTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(-12);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(4);
        make.right.mas_equalTo(-4);
        make.height.mas_equalTo(46);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.verifyView);
        make.width.height.offset(30);
    }];
}

#pragma mark - event methods

- (void)refresh {
    [self getPuzzleImageCodeForceRefresh:YES];
}


- (void)reset {
    self.alpha = 1.0;
    _verifyView.puzzleXPercentage = 0;
    _slider.value = 0.0;
}


- (void)getPuzzleImageCodeForceRefresh:(BOOL)forceRefresh {
    if (!forceRefresh && self.viewModel.captchaId.length != 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel generatePuzzleImageCodeWithCompletion:^(CGPoint puzzlePosition,UIImage *originImage, UIImage *cutoutImage, UIImage *shadeImage){
        weakSelf.puzzlePosition = puzzlePosition;
        weakSelf.originImage = originImage;
        weakSelf.cutoutImage = cutoutImage;
        weakSelf.shadeImage = shadeImage;
        [weakSelf reset];
    } errorCompletion:^(NSString * errMsg) {
        [CNTOPHUB showError:errMsg];
    }];
}

#pragma mark - layout subviews [生成文字动画]

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_gradientLayer) {
        UILabel *animationLabel = [[UILabel alloc] initWithFrame:_slidTitle.bounds];
        animationLabel.text = _slidTitle.text;
        animationLabel.font = _slidTitle.font;
        animationLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat duration = 1.0;
        NSArray *gradientColors = @[(id)[UIColor colorWithWhite:0.4 alpha:1.0].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithWhite:0.4 alpha:1.0].CGColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = _slidTitle.bounds;
        gradientLayer.position = CGPointMake(_slidTitle.width / 2.0, _slidTitle.height / 2.0);
        
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
            
        gradientLayer.colors = gradientColors;
        gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
        self.gradientLayer = gradientLayer;
        CABasicAnimation *locationAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        locationAnimation.fromValue = @[@(0),@(0.0),@(0.3)];
        locationAnimation.toValue = @[@(0.7),@(1),@(1)];
        locationAnimation.duration = duration;
        locationAnimation.repeatCount = HUGE;
        locationAnimation.autoreverses = NO;
        self.locationAnimation = locationAnimation;
        [_slidTitle.layer addSublayer:gradientLayer];
        _slidTitle.maskView = animationLabel;
        gradientLayer.mask = animationLabel.layer;
        [gradientLayer addAnimation:locationAnimation forKey:locationAnimation.keyPath];
    }
}

#pragma mark - slider actions

// UISlider actions
- (void)sliderUp:(UISlider *)sender {
    if (_sliding) {
        _sliding = NO;
        [_verifyView performCallback];
    }
}

- (void)sliderDown:(UISlider *)sender {
    _sliding = YES;
}

- (void)sliderChanged:(UISlider *)sender {
    _verifyView.puzzleXPercentage = sender.value;
}

#pragma mark - PuzzleVerifyViewDelegate

- (void)puzzleVerifyView:(PuzzleVerifyView *)puzzleVerifyView didChangedPuzzlePosition:(CGPoint)newPosition xPercentage:(CGFloat)xPercentage yPercentage:(CGFloat)yPercentage {
    NSDictionary * dict = @{@"x":@(newPosition.x), @"y":@(newPosition.y)};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.viewModel.captcha = result;
    __weak typeof(self) weakSelf = self;
    [self.viewModel verifyPuzzleImageCodeWithCompletion:^(BOOL validateResult, NSString * _Nonnull ticket, NSString * _Nonnull errorMsg) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (validateResult) {
            strongSelf->_ticket = ticket;
            strongSelf.correct = YES;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(puzzleViewVerifySuccess:)]) {
                [strongSelf.delegate puzzleViewVerifySuccess:strongSelf];
            }
        } else {
            strongSelf->_ticket = nil;
            strongSelf.correct = NO;
            [strongSelf getPuzzleImageCodeForceRefresh:YES];
            [CNTOPHUB showError:errorMsg];
        }
    }];
}

#pragma mark - setter and getter

- (NSString *)captchaId {
    return self.viewModel.captchaId;
}

- (void)setOriginImage:(UIImage *)originImage {
    _verifyView.originImage = originImage;
}

- (void)setShadeImage:(UIImage *)shadeImage {
    _verifyView.shadeImage = shadeImage;
}

- (void)setCutoutImage:(UIImage *)cutoutImage {
    _verifyView.cutoutImage = cutoutImage;
}

- (void)setPuzzlePosition:(CGPoint)puzzlePosition {
    _verifyView.puzzlePosition = puzzlePosition;
}

- (PuzzleVerifyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PuzzleVerifyViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
        _refreshButton.adjustsImageWhenHighlighted = NO;
        [_refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

-(PuzzleVerifyView *)verifyView{
    
    if (!_verifyView) {
        _verifyView = [[PuzzleVerifyView alloc] initWithFrame:CGRectMake(20, 20, 300, 95)];
        _verifyView.puzzlePosition = CGPointMake(100, 30);
        _verifyView.puzzleXPercentage = 0;
        _verifyView.layer.masksToBounds = YES;
        _verifyView.delegate = self;
    }
    return _verifyView;
}

-(UIView *)slidView{
    
    if (!_slidView) {
        _slidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 46)];
        _slidView.backgroundColor = [UIColor whiteColor];
        _slidView.layer.masksToBounds = YES;
    }
    return _slidView;
}

- (UIView *)innerView {
    if (!_innerView) {
        CGSize size = CGSizeMake(266, 22);
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(17, 12, size.width, size.height)];
        _innerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
        _innerView.layer.cornerRadius = 11.0;
        _innerView.clipsToBounds = YES;
        CALayer *shadowLayer = [[CALayer alloc] init];
        shadowLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15].CGColor;
        shadowLayer.position = CGPointMake(size.width / 2, -size.height/ 2 + 0.5);
        shadowLayer.bounds = CGRectMake(0, 0, size.width, size.height);
        shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        shadowLayer.shadowOffset = CGSizeMake(0.5, 0.5);
        shadowLayer.shadowOpacity = 0.8;
        shadowLayer.shadowRadius = 5.0;
        [_innerView.layer addSublayer:shadowLayer];
    }
    return _innerView;
}

-(UILabel *)slidTitle {
    if (!_slidTitle) {
        _slidTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 36)];
        _slidTitle.textColor = [UIColor clearColor];
        _slidTitle.font = [UIFont boldSystemFontOfSize:14];
        _slidTitle.textAlignment = NSTextAlignmentCenter;
        _slidTitle.text = @"拖动滑块完成拼图验证>>>";
    }
    return _slidTitle;
}

-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.continuous = YES;
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        _slider.value = 0.0;
        _slider.backgroundColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        // Set the slider action methods
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self
                    action:@selector(sliderDown:)
          forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self
                    action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

@end
