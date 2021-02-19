//
//  IVCNetworkStatusView.m
//  IVNetworkDemo
//
//  Created by Key on 2018/8/31.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "IVCNetworkStatusView.h"
#import "IVCProgressView.h"
#import "IVCheckNetworkWrapper.h"
#import "IVHttpManager.h"

@interface IVCNetworkStatusView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *detailBtn;
@property (nonatomic, strong)UIActivityIndicatorView *activityView;
@end
@implementation IVCNetworkStatusView

- (void)startCheck
{
    
    IVCheckNetworkModel *gatewayModel = [[IVCheckNetworkModel alloc] init];
    gatewayModel.title = @"当前业务线路";
    gatewayModel.urls = [IVHttpManager shareManager].gateways;
    gatewayModel.type = IVKCheckNetworkTypeGateway;
    IVCheckNetworkModel *gameModel = [[IVCheckNetworkModel alloc] init];
    gameModel.title = @"当前游戏线路";
    gameModel.urls = [IVHttpManager shareManager].gameDomain ? @[[IVHttpManager shareManager].gameDomain] : @[];
    gameModel.type = IVKCheckNetworkTypeGameDomian;
    self.datas = @[gatewayModel,gameModel];
    
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7f];
    
    CGFloat btnH = 50.f;
    CGFloat cornerRadius = 12.f;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    contentView.bounds = CGRectMake(0, 0, 280, 350);
    contentView.layer.cornerRadius = cornerRadius;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame) - btnH);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.layer.masksToBounds = YES;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(tableView.frame), 25)];
    titleLab.text = @"网络情况";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16.f];
    [headerView addSubview:titleLab];
    UILabel *ipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(tableView.frame), 25)];
    ipLab.text = @"获取中...";
    ipLab.textAlignment = NSTextAlignmentCenter;
    ipLab.textColor = [UIColor grayColor];
    ipLab.font = [UIFont systemFontOfSize:14.f];
    [headerView addSubview:ipLab];
    
    tableView.tableHeaderView = headerView;
    [contentView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    CGFloat lineH = 1.0f / [UIScreen mainScreen].scale;
    UIColor * lineColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.5];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), CGRectGetWidth(contentView.frame), lineH)];
    line1.backgroundColor = lineColor;
    [contentView addSubview:line1];
    
    CGFloat btnW = CGRectGetWidth(contentView.frame) * 0.5f;
    UIButton *detailBtn = [UIButton new];
    UIColor *titleColor = [UIColor colorWithRed:30.f/255 green:144.f/255 blue:255.f/255 alpha:1.f];
    detailBtn.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame) + lineH, btnW - lineH, btnH - lineH);
    [detailBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [detailBtn setTitle:@"诊断中..." forState:UIControlStateNormal];
    detailBtn.backgroundColor = [UIColor whiteColor];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:detailBtn];
    detailBtn.enabled = NO;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = detailBtn.center;
    activityView.bounds = CGRectMake(0, 0, 30, 30);
    [activityView startAnimating];
    [contentView addSubview:activityView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(detailBtn.frame), CGRectGetMinY(detailBtn.frame), lineH, CGRectGetHeight(detailBtn.frame))];
    line2.backgroundColor = lineColor;
    [detailBtn addSubview:line2];
    
    UIButton *captureBtn = [UIButton new];
    captureBtn.frame = CGRectMake(CGRectGetMaxX(line2.frame), CGRectGetMinY(detailBtn.frame), btnW, CGRectGetHeight(detailBtn.frame));
    [captureBtn setTitle:@"保存截图" forState:UIControlStateNormal];
    [captureBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [captureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    captureBtn.backgroundColor = [UIColor whiteColor];
    captureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [captureBtn addTarget:self action:@selector(captureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:captureBtn];
    self.detailBtn = detailBtn;
    self.activityView = activityView;
    self.tableView = tableView;
    [self check];
}
- (void)check
{
    __block int i = 0;
    for (NSInteger index = 0; index < self.datas.count; index++) {
        IVCheckNetworkModel *model = self.datas[index];
        [IVCheckNetworkWrapper getOptimizeUrlWithArray:model.urls isAuto:YES type:model.type progress:^(IVCheckDetailModel * _Nonnull respone) {
            [self checkProgressWithTableView:self.tableView model:model respone:respone];
        } completion:^(IVCheckDetailModel * _Nonnull respone) {
            i++;
            model.fullTitle = [NSString stringWithFormat:@"%@: 线路%zi",model.title,respone.index + 1];
            [self.tableView reloadData];
            if (i == self.datas.count) {
                [self.detailBtn setTitle:@"网络诊断" forState:UIControlStateNormal];
                self.detailBtn.enabled = YES;
                [self.activityView stopAnimating];
            }
        }];
    }
}

- (void)checkProgressWithTableView:(UITableView *)tableView model:(IVCheckNetworkModel *)model respone:(IVCheckDetailModel *)respone
{
    NSInteger index = 0;
    BOOL exit = NO;
    for (IVCheckDetailModel *detailModel in model.detailModels) {
        NSInteger i = [model.detailModels indexOfObject:detailModel];
        NSURL *url = [NSURL URLWithString:detailModel.url];
        NSURL *url1 = [NSURL URLWithString:respone.url];
        if ([url.host isEqualToString:url1.host] ) {
            index = i;
            exit = YES;
        }
    }
    if (exit) {
        model.detailModels[index] = respone;
    }
    [tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datas[section].detailModels.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *name = self.datas[section].fullTitle;
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14.f];
    lab.text = [@"    " stringByAppendingString:name];
    return lab;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    CGFloat marginRight = 20.f;
    CGFloat cellH = 40.f;
    CGFloat lineW = 50.f;
    UILabel *lineLab = [[ UILabel alloc] initWithFrame:CGRectMake(marginRight, 0, lineW, cellH)];
    lineLab.font = [UIFont systemFontOfSize:12];
    lineLab.textColor = [UIColor blackColor];
    lineLab.text = self.datas[indexPath.section].detailModels[indexPath.row].title;
    [cell.contentView addSubview:lineLab];
    CGFloat speed =  self.datas[indexPath.section].detailModels[indexPath.row].time;
    NSString *speedStr = [NSString stringWithFormat:@"%.lfms",speed];
    int progress = 0;
    UIColor *progressColor = [UIColor greenColor];
    
    if (speed == 0) {
        progressColor = [UIColor blackColor];
        speedStr = @"诊断中...";
    } else if (speed > 20000) {
        speedStr = @"失败";
        progress = 0;
        progressColor = [UIColor redColor];
    } else if (speed >= 200) {
        progress = [@(((600 - speed) / 10 + 1)) intValue];
        if (progress < 1) {
            progress = 1;
        }
        progressColor = [UIColor redColor];
    } else if (speed >= 100) {
        progress = [@((200 - speed) / 3 + 40) intValue];
        progressColor = [UIColor orangeColor];
    } else if (speed >= 60) {
        progress = [@((100 - speed + 70)) intValue];
        progressColor = [UIColor greenColor];
    } else {
        progress = 100;
        progressColor = [UIColor greenColor];
    }
    
    CGFloat speedW = 50.f;
    UILabel *speedLab = [[UILabel alloc] init];
    speedLab.frame = CGRectMake(CGRectGetWidth(tableView.frame) - speedW - marginRight, 0, speedW, cellH);
    speedLab.font = [UIFont systemFontOfSize:12.f];
    speedLab.text = speedStr;
    speedLab.textColor = progressColor;
    speedLab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:speedLab];
    
    CGFloat progressW = CGRectGetWidth(tableView.frame) - marginRight * 2.f - speedW - lineW;
    CGRect progressFrame = CGRectMake(CGRectGetMaxX(lineLab.frame), 15, progressW, 10);
    
    IVCProgressView *progressView = [[IVCProgressView alloc] initWithFrame:progressFrame];
    progressView.trackTintColor = [UIColor lightGrayColor];
    progressView.progressTintColor = progressColor;
    progressView.layer.cornerRadius = 3.0;
    progressView.layer.masksToBounds = YES;
    
    [progressView setProgress:progress / 100.0f animated:YES];
    [cell.contentView addSubview:progressView];
    
    NSString *urlStr = self.datas[indexPath.section].detailModels[indexPath.row].url;
    NSURL *url = [NSURL URLWithString:urlStr];
    urlStr = url.host;
    urlStr = [IVCheckNetworkWrapper replaceSecurityUrl:urlStr];
    UILabel *urlLab = [[UILabel alloc] init];
    urlLab.frame = CGRectMake(CGRectGetMinX(progressView.frame), CGRectGetMaxY(progressView.frame), CGRectGetWidth(progressView.frame), 20);
    urlLab.textColor = [UIColor blackColor];
    urlLab.font = [UIFont systemFontOfSize:10.f];
    urlLab.textAlignment = NSTextAlignmentCenter;
    urlLab.text = urlStr;
    [cell.contentView addSubview:urlLab];
    
    return cell;
}

- (void)detailBtnClicked
{
    [self removeFromSuperview];
    if (self.detailBtnClickedBlock) {
        self.detailBtnClickedBlock();
    }
}
- (void)captureBtnClicked
{
    UIGraphicsBeginImageContext(self.superview.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //把图片保存在本地
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
       
    }
    [IVCNetworkStatusView showToastWithMessage:msg superView:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
+ (void)showToastWithMessage:(NSString *)message superView:(UIView *)superView
{
    UILabel *label = [UILabel new];
    label.text = message;
    label.font = [UIFont systemFontOfSize:15.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.7f];
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
    CGFloat height = 40.f;
    CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)].width;
    label.center = CGPointMake(centerX, centerY);
    label.bounds = CGRectMake(0, 0, width + 10, height);
    label.layer.cornerRadius = 3.f;
    label.layer.masksToBounds = YES;
    [superView addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.alpha = 0;
        [label removeFromSuperview];
    });
}
@end
