//
//  SuspendBall.m
//
//  Created by 李昊泽 on 16/12/5.
//

#import "SuspendBall.h"
#import "UIButton+JKImagePosition.h"

/*** 分类方法  ***/
@interface UIView (lhzExtension)
@property (nonatomic, assign) CGFloat lhz_width;
@property (nonatomic, assign) CGFloat lhz_height;

@property (nonatomic, assign) CGFloat lhz_x;
@property (nonatomic, assign) CGFloat lhz_y;

@property (nonatomic, assign) CGFloat lhz_centerX;
@property (nonatomic, assign) CGFloat lhz_centerY;
@end

@implementation UIView (lhzExtension)

- (CGFloat)lhz_width
{
    return self.frame.size.width;
}

- (CGFloat)lhz_height
{
    return self.frame.size.height;
}

- (void)setLhz_width:(CGFloat)lhz_width
{
    CGRect frame = self.frame;
    frame.size.width = lhz_width;
    self.frame = frame;
}

- (void)setLhz_height:(CGFloat)lhz_height
{
    CGRect frame = self.frame;
    frame.size.height = lhz_height;
    self.frame = frame;
}

- (CGFloat)lhz_x
{
    return self.frame.origin.x;
}

- (void)setLhz_x:(CGFloat)lhz_x
{
    CGRect frame = self.frame;
    frame.origin.x = lhz_x;
    self.frame = frame;
}

- (CGFloat)lhz_y
{
    return self.frame.origin.y;
}

- (void)setLhz_y:(CGFloat)lhz_y
{
    CGRect frame = self.frame;
    frame.origin.y = lhz_y;
    self.frame = frame;
}

- (CGFloat)lhz_centerX
{
    return self.center.x;
}

- (void)setLhz_centerX:(CGFloat)lhz_centerX
{
    CGPoint center = self.center;
    center.x = lhz_centerX;
    self.center = center;
}

- (CGFloat)lhz_centerY
{
    return self.center.y;
}

- (void)setLhz_centerY:(CGFloat)lhz_centerY
{
    CGPoint center = self.center;
    center.y = lhz_centerY;
    self.center = center;
}
@end


/*** 悬浮球的实现  ***/
@interface SuspendBall ()<UIGestureRecognizerDelegate> {
    
}
@end
@implementation SuspendBall
static CGFloat fullButtonWidth    = 60;
static CGFloat btnBigImageWidth   = 60;
static CGFloat btnSmallImageWidth = 60;

///!!!: TO DO --- 以后会加上对横屏的支持 2018.11.28
#define KScreenWidth MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define KScreenHeight MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define IS_IPHONEX ((KScreenHeight == 812.f || KScreenHeight == 896.f) ? YES : NO)
#define KNavBarHeight (IS_IPHONEX ? 88.f:64.f)


#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];

        [self setBackgroundImage:[UIImage imageNamed:@"bg_w"] forState:0];
        
        [self setImage:[UIImage imageNamed:@"service-float"] forState:UIControlStateNormal];
        [self setTitle:@"客服" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontPFM13];
        [self setTitleColor:kHexColor(0x10B4DD) forState:UIControlStateNormal];
        [self jk_setImagePosition:LXMImagePositionTop spacing:3];

        [self addTarget:self action:@selector(suspendBallShow) forControlEvents:UIControlEventTouchUpInside];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSuspend:)];
        pan.delegate = self;
        pan.delaysTouchesBegan = NO;
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%@---%@", gestureRecognizer.view, otherGestureRecognizer.view);
    return NO;
}

+(instancetype)shareInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


+ (instancetype)suspendBallWithFrame:(CGRect)ballFrame delegate:(id<SuspendBallDelegte>)delegate subBallImageArray:(NSArray *)imageArray
{
    SuspendBall *suspendBall = [SuspendBall shareInstance];
    suspendBall.frame = ballFrame;
    suspendBall.delegate = delegate;
    suspendBall.imageNameGroup = imageArray;
    return suspendBall;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)initialization
{
    _imageNameGroup = @[@"up", @"down"];
    //    _superBallBackColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    _showFunction = NO;
    _stickToScreen = YES;
}

- (void)setImageNameGroup:(NSArray *)imageNameGroup
{
    _imageNameGroup = imageNameGroup;
    _functionMenu = nil;
    
}

- (void)setSuperBallBackColor:(UIColor *)superBallBackColor
{
    //    _superBallBackColor = superBallBackColor;
    //    self.backgroundColor = superBallBackColor;
}

#pragma mark - Selector
//移动悬浮球  在这里添加对悬浮球的边界判断以及是否需要粘性效果
- (void)moveSuspend:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan locationInView:self.superview];
    self.lhz_centerX = point.x;
    self.lhz_centerY = point.y;
    
    switch (pan.state) {
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateChanged:
        {
            // 判断上下有没有超过安全距离
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            //            if (point.x < fullButtonWidth / 2) {
            //                [UIView animateWithDuration:0.5 animations:^{
            //                    self.lhz_x = 0;
            //                }];
            //            }
            //
            //            if ( point.x > KScreenWidth - fullButtonWidth / 2 ) {
            //                [UIView animateWithDuration:0.5 animations:^{
            //                    self.lhz_x = KScreenWidth - fullButtonWidth;
            //                }];
            //            }
            //
                        if (point.y > KScreenHeight - fullButtonWidth / 2 - self.bottom) {
                            [UIView animateWithDuration:0.5 animations:^{
                                self.lhz_y = KScreenHeight - fullButtonWidth - self.bottom ;
                            }];
                        }
            
                        if (point.y < fullButtonWidth / 2 + self.top) {
                            [UIView animateWithDuration:0.5 animations:^{
                                self.lhz_y =  self.top;
                            }];
                        }
            
            [self judgeLeftOrRight:pan];
            break;
            
        default:
            break;
    }
}

- (void)suspendBallShow{
    
    
    [self addAnimate:_showFunction];
    

    __weak typeof(self) weakSelf = self;
    if(_showFunction == NO) {
        // 调整主按钮
        [self setImage:[UIImage imageNamed:@"arrow_cs"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"bg"] forState:0];
        [self setTitle:nil forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsZero;
        self.titleEdgeInsets = UIEdgeInsetsZero;
        _showFunction = YES;
        
        //添加背景
       [self.superview addSubview:self.bgView];
       [self.superview insertSubview:self.bgView belowSubview:self];
        
        [self functionMenuShow];
        
        if (weakSelf.show) {
            weakSelf.show(_showFunction);
        }
        return;
        
    }else if (_showFunction == YES) { //full state
        // 调整主按钮
        [self setImage:[UIImage imageNamed:@"service-float"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"bg_w"] forState:0];
        [self setTitle:@"客服" forState:UIControlStateNormal];
        [self jk_setImagePosition:LXMImagePositionTop spacing:3];
        _showFunction = NO;
        
        // 移除
        [self dismissMenuShow];
        
        if (weakSelf.close) {
            weakSelf.close(_showFunction);
        }
        return;
    }
    
    
}

// 主按钮添加动画
- (void)addAnimate:(BOOL)showFunction
{
    if (showFunction == YES) {
        //scale
        CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.values = @[@1, @1.2, @1, @0.1];
        scaleAnim.duration = 0.2f;
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.autoreverses = YES;
        scaleAnim.removedOnCompletion = YES;
        [self.imageView.layer addAnimation:scaleAnim forKey:@"btn_scale"];
        
    } else {
        //rotation 360°
        CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnim.fromValue = [NSNumber numberWithFloat:0];
        rotationAnim.toValue = [NSNumber numberWithFloat:M_PI*2];
        
        CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.values = @[@0.1, @1,@1.2,@1.0];
        CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
        // 动画时长
        animaGroup.duration = 0.4f;
        // 防止回到最初状态
        animaGroup.fillMode = kCAFillModeForwards;
        animaGroup.animations = @[rotationAnim,scaleAnim];
        animaGroup.autoreverses = NO;
        animaGroup.removedOnCompletion = YES;
        animaGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.imageView.layer  addAnimation:animaGroup forKey:@"btn_rotation"];
    }
}

// 隐藏菜单栏
- (void)dismissMenuShow {
    // 先做动画
    [self.functionMenu.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.values = @[@1, @1.2, @1, @0.1];
        scaleAnim.duration = 0.4f;
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer addAnimation:scaleAnim forKey:@"Animation"];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.41 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.functionMenu removeFromSuperview];
        [self.bgView removeFromSuperview];
    });
}

//展示菜单栏
- (void)functionMenuShow
{
    [self.superview addSubview:self.functionMenu];
    //judge leftOrRight
    CGFloat myCenterX = self.center.x;
    if (myCenterX < KScreenWidth / 2) { //在屏幕的左侧
        [self addSubMenuView:YES];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.functionMenu attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
    } else if (myCenterX >= KScreenWidth / 2) { //屏幕的右侧
        [self addSubMenuView:NO];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.functionMenu attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    }
    self.functionMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.functionMenu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:fullButtonWidth]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.functionMenu attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.imageNameGroup.count * fullButtonWidth]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.functionMenu attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}


-(void)addSubMenuView:(BOOL) isLeft{
    for(UIView* sub in [self.functionMenu subviews]){
        [sub removeFromSuperview];
    }
    NSArray *titles = @[@"存取",@"疑问",@"回拨",@"400"];
    for (int i = 0; i < self.imageNameGroup.count; i++) {
        UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [functionBtn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:self.imageNameGroup[i]];
        if (img) {
            [functionBtn setImage:img forState:UIControlStateNormal];
        }
        [functionBtn setTitle:titles[i] forState:UIControlStateNormal];
        [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        functionBtn.titleLabel.font = [UIFont fontPFM13];
        [functionBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
        
        functionBtn.lhz_y = 0;
        functionBtn.lhz_width = fullButtonWidth;
        functionBtn.lhz_height = fullButtonWidth;
        if(isLeft){
            functionBtn.lhz_x = i * fullButtonWidth;
        }else{
            functionBtn.lhz_x = (self.imageNameGroup.count-i-1) * fullButtonWidth;
        }
        
//        functionBtn.layer.cornerRadius = fullButtonWidth / 2;
        //            functionBtn.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        functionBtn.tag = i;
        [functionBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.functionMenu addSubview:functionBtn];
        
        // 缩放动画
        CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.values = @[@0.1, @1,@1.2,@1.0];
        // 中心轴旋转
        CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnim.fromValue = [NSNumber numberWithFloat:0];
        rotationAnim.toValue = [NSNumber numberWithFloat:M_PI*2];
        // 大小
        CABasicAnimation *scaleBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
        scaleBounds.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
        scaleBounds.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, fullButtonWidth, fullButtonWidth)];
        // 位置
        CABasicAnimation *scalePosition = [CABasicAnimation animationWithKeyPath:@"position"];
        scaleBounds.fromValue = [NSValue valueWithCGPoint:CGPointMake(0,0)];
        scalePosition.toValue = [NSValue valueWithCGPoint:CGPointMake(isLeft?i * fullButtonWidth+fullButtonWidth/2:(self.imageNameGroup.count-i-1) * fullButtonWidth+fullButtonWidth/2, fullButtonWidth/2)];
        
        CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
        // 动画时长
        animaGroup.duration = 0.4f;
        // 防止回到最初状态
        animaGroup.fillMode = kCAFillModeForwards;
        animaGroup.removedOnCompletion = YES;
        animaGroup.animations = @[scaleAnim,rotationAnim,scalePosition];
        rotationAnim.repeatCount = 1;
        animaGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [functionBtn.layer addAnimation:animaGroup forKey:@"Animation"];
        
//        [UIView animateWithDuration:0.6 animations:^{
//
//            functionBtn.lhz_y = 0;
//            functionBtn.lhz_width = fullButtonWidth;
//            functionBtn.lhz_height = fullButtonWidth;
//        }];
//        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//        } completion:^(BOOL finished) {
//        }];
        
    }
}

//判断悬浮球拖动结束时在屏幕的哪侧
- (void)judgeLeftOrRight:(UIPanGestureRecognizer *)pan
{
    if (!_stickToScreen) return;
    
    CGPoint endPoint = [pan locationInView:self.superview];
    if (endPoint.x < KScreenWidth / 2) {
        [UIView animateWithDuration:.6f delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:13.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lhz_x = 0;
            self.lhz_width = self.lhz_width;
            self.lhz_height = self.lhz_height;
        } completion:^(BOOL finished) {
        }];
        //        [UIView animateWithDuration:0.2 animations:^{
        
        //            self.lhz_x = 0;
        //        }];
    }
    
    if (endPoint.x > KScreenWidth / 2) {
        [UIView animateWithDuration:.6f delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:13.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lhz_x = KScreenWidth - fullButtonWidth;
            self.lhz_width = self.lhz_width;
            self.lhz_height = self.lhz_height;
        } completion:^(BOOL finished) {
        }];
    }
    
}

//功能按钮点击
- (void)menuBtnClicked:(UIButton *)menuBtn {
    if ([self.delegate respondsToSelector:@selector(suspendBall:didSelectTag:)]) {
        [self.delegate suspendBall:menuBtn didSelectTag:menuBtn.tag];
    }
    NSLog(@"点击了第%ld个子悬浮球", (long)menuBtn.tag);
}

#pragma mark - Frame


#pragma mark - Lazy
- (UIView *)functionMenu
{
    if (!_functionMenu) {
        
        _functionMenu = [[UIView alloc] init];
    }
    return _functionMenu;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _bgView.backgroundColor = kHexColorAlpha(0x000000, 0.7);
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suspendBallShow)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

#pragma mark - private method
- (UIImage *)resizeImage:(UIImage *)originImage wantSize:(CGSize)wantSize
{
    UIGraphicsBeginImageContextWithOptions(wantSize, NO, 0.0);
    [originImage drawInRect:CGRectMake(0, 0, wantSize.width, wantSize.height)];
    UIImage *wantImage = UIGraphicsGetImageFromCurrentImageContext();
    return wantImage;
}

#pragma mark - other method

@end
