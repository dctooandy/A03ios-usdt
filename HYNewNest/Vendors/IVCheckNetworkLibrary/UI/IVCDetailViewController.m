//
//  IVCDetailViewController.m
//  IVNetworkDemo
//
//  Created by Key on 2018/9/2.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "IVCDetailViewController.h"
#import "IVCProgressView.h"
#import "IVCheckNetworkWrapper.h"
#import "IVCNetworkStatusView.h"
#import "IVCheckNetworkModel.h"
#import "IVHttpManager.h"
@interface IVCDetailViewController ()
{
    IVCProgressView *_progressView;
    UIButton *_savaBtn;
    UITextView *_textView;
}
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, copy) NSArray *logs;
@property (nonatomic, copy) NSArray<IVCheckNetworkModel *> *datas;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger currentCount;
@end

@implementation IVCDetailViewController

- (instancetype)initWithThemeColor:(UIColor *)themeColor
{
    self = [super init];
    if (self) {
        _themeColor = themeColor;
        _totalCount = 6;
        _currentCount = 0;
    }
    return self;
}
- (NSArray *)logs
{
//    if (!_logs) {
        NSString *allLog = [[NSUserDefaults standardUserDefaults] valueForKey:kCheckLogKey];
        _logs = [allLog componentsSeparatedByString:@"\n"];
//    }
    return _logs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络诊断";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _savaBtn = [[UIButton alloc] init];
    _savaBtn.backgroundColor = self.themeColor;
    [_savaBtn setTitle:@"保存截图" forState:UIControlStateNormal];
    [_savaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_savaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    saveBtn.layer.cornerRadius = 5.0;
    [_savaBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_savaBtn];
    _savaBtn.hidden = YES;
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.editable = NO;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    _textView.text = @"start check ...";
    if (@available(iOS 11.0, *)) {
        _textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _textView.selectable = NO;
//    _textView.userInteractionEnabled = NO;
    [self.view addSubview:_textView];
    
    _progressView = [[IVCProgressView alloc] init];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _progressView.progressTintColor = _savaBtn.backgroundColor;
    _progressView.textAlignment = NSTextAlignmentCenter;
    _progressView.textColor = [UIColor whiteColor];
    _progressView.text = @"";
    [self.view addSubview:_progressView];
    
    IVCheckNetworkModel *gatewayModel = [[IVCheckNetworkModel alloc] init];
    gatewayModel.urls = [IVHttpManager shareManager].gateways;
    gatewayModel.type = IVKCheckNetworkTypeGateway;
    IVCheckNetworkModel *domainModel = [[IVCheckNetworkModel alloc] init];
    domainModel.urls = [IVHttpManager shareManager].domains;
    domainModel.type = IVKCheckNetworkTypeDomain;
    NSString *gc = [IVHttpManager shareManager].gameDomain;
    if (gc && gc.length > 0) {
        IVCheckNetworkModel *gcModel = [[IVCheckNetworkModel alloc] init];
        gcModel.urls =@[gc];
        gcModel.type = IVKCheckNetworkTypeGameDomian;
        self.datas = @[gatewayModel,domainModel,gcModel];
    } else {
        self.datas = @[gatewayModel,domainModel];
    }
    __weak typeof(self)weakSelf = self;
    [IVCheckNetworkWrapper setPrintLogBlock:^(NSString * _Nonnull log) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf printLog:log];
        });
    }];
    
}
- (void)start
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kCheckLogKey];
    
    [IVCheckNetworkWrapper writeCheckLog:@"========================" isAuto:NO];
    NSString *str = [NSString stringWithFormat:@"current mobile domain:%@",[IVCheckNetworkWrapper replaceSecurityUrl:[IVHttpManager shareManager].domain]];
    NSString *gateway = [NSURL URLWithString:[IVHttpManager shareManager].gateway].host;
    NSString *str1 = [NSString stringWithFormat:@"current gateway:%@",[IVCheckNetworkWrapper replaceSecurityUrl:gateway]];
    [IVCheckNetworkWrapper writeCheckLog:str isAuto:NO];
    [IVCheckNetworkWrapper writeCheckLog:str1 isAuto:NO];
    [IVCheckNetworkWrapper writeCheckLog:@"========================" isAuto:NO];
    [self checkTripartiteDomain];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setCurrentCount:(NSInteger)currentCount
{
    _currentCount = currentCount;
    if (currentCount >= self.totalCount) {
        _savaBtn.hidden = NO;
        _progressView.hidden = YES;
        return;
    }
    CGFloat progress = (double)currentCount / (double)self.totalCount;
    [_progressView setProgress:progress animated:YES];
    _progressView.text = [NSString stringWithFormat:@"%.1lf%%",progress * 100.0];
}
- (void)printLog:(NSString *)log
{
    _textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",log]];
    [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
}
- (void)viewDidLayoutSubviews
{
    CGFloat saveBtnW = CGRectGetWidth(self.view.frame) * 0.9;
    CGFloat saveBtnX = (CGRectGetWidth(self.view.frame) - saveBtnW) * 0.5;
    CGFloat saveBtnH = 45;
    CGFloat saveBtnY = CGRectGetHeight(self.view.frame) - 30 - saveBtnH;
    _savaBtn.frame = CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH);
    _progressView.frame = _savaBtn.frame;
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat textViewY = self.navigationController.navigationBar.frame.size.height + statusH;
    _textView.frame = CGRectMake(0, textViewY, CGRectGetWidth(self.view.frame), CGRectGetMinY(_savaBtn.frame) - textViewY);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveImage
{
    NSString *string = _textView.text;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setLineSpacing:0.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:10.0],
                                 NSForegroundColorAttributeName : _textView.textColor,
                                 NSBackgroundColorAttributeName : _textView.backgroundColor,
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image = [self imageFromString:string attributes:attributes size:CGSizeMake(CGRectGetWidth(_textView.frame), _textView.contentSize.height)];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    [IVCNetworkStatusView showToastWithMessage:msg superView:self.view];
}
- (void)dealloc
{
    NSLog(@"111111");
}

- (void)checkTripartiteDomain
{
    [IVCheckNetworkWrapper checkTripartiteDomainWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [self pingGateway];
        });
    }];
}
- (void)pingGateway
{
    [IVCheckNetworkWrapper startPingGatewayWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [self startConnectGatewaySocket];
        });
    }];
}
- (void)startConnectGatewaySocket
{
    [IVCheckNetworkWrapper startConnectGatewaySocketWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [self startHttpRequestGateway];
        });
    }];
}
- (void)startHttpRequestGateway
{
    [IVCheckNetworkWrapper startHttpRequestGatewayWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [self startCheckGatewayStatus];
        });
    }];
}
- (void)startCheckGatewayStatus
{
    [IVCheckNetworkWrapper startCheckGatewayStatusWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [self checkHealth];
        });
    }];
}
- (void)checkHealth
{
    IVCheckNetworkModel *model = self.datas[0];
    NSInteger index = 0;
    [self checkWithModel:model index:index completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentCount++;
            [IVCheckNetworkWrapper sendCheckLog];
        });
    }];
}
- (void)checkWithModel:(IVCheckNetworkModel *)model index:(NSInteger)index completion:(nullable void (^)(void))completion
{
    [IVCheckNetworkWrapper getOptimizeUrlSynWithArray:model.urls isAuto:NO type:model.type progress:nil completion:^(IVCheckDetailModel * _Nonnull respone) {
        if (index < self.datas.count - 1) {
            [self checkWithModel:self.datas[index + 1] index:index + 1 completion:completion];
        } else {
            //检测完成
            completion();
        }
    }];
}
@end
