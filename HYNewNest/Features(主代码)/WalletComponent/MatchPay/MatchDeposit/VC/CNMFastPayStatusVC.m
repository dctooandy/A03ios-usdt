//
//  CNMFastPayStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayStatusVC.h"
#import "CNMAlertView.h"
#import "CNMatchPayRequest.h"

#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import <ZLPhotoBrowser/ZLShowBigImgViewController.h>
#import <UIImageView+WebCache.h>

#import <CSCustomSerVice/CSCustomSerVice.h>

#import "PublicMethod.h"
#import "CNTOPHUB.h"

/// 页面 UI 状态区分
typedef NS_ENUM(NSUInteger, CNMPayUIStatus) {
    CNMPayUIStatusSubmit,  //已提交
    CNMPayUIStatusPaying,  //等待支付
    CNMPayUIStatusConfirm, //已确认
    CNMPayUIStatusSuccess  //已完成
};

@interface CNMFastPayStatusVC ()

#pragma mark - 顶部状态试图
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusIVs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
/// 时间前面
@property (weak, nonatomic) IBOutlet UILabel *tip1Lb;
/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *tip2Lb;
/// 时间后面
@property (weak, nonatomic) IBOutlet UILabel *tip3Lb;
/// 时间下面
@property (weak, nonatomic) IBOutlet UILabel *tip4Lb;
/// 大字提示语
@property (weak, nonatomic) IBOutlet UILabel *tip5Lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip5LbH;

///倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeInterval;

#pragma mark - 中间金额视图
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTipLbH;

#pragma mark - 中间银行卡视图，一共有7行信息栏
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *bankRow5;
@property (weak, nonatomic) IBOutlet UIView *bankRow6;
@property (weak, nonatomic) IBOutlet UIView *bankRow7;
@property (weak, nonatomic) IBOutlet UILabel *rowTitle6;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *bankAmount;
@property (weak, nonatomic) IBOutlet UILabel *submitDate;
/// 确认时间/订单编号公用
@property (weak, nonatomic) IBOutlet UILabel *confirmDate;
/// 复制内容标签组
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *contentLbArray;


#pragma mark - 底部提示内容
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *submitTipView;
@property (weak, nonatomic) IBOutlet UIView *confirmTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmTipViewH;

#pragma mark - 底部按钮组
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *customerServerBtn;

#pragma mark - 相册选择
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (strong, nonatomic) IBOutlet UIView *pictureView;

/// 上面一个按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb1;
/// 存放图片
@property (nonatomic, strong) NSMutableArray *pictureArr1;
/// 存放上传后返回图片名
@property (nonatomic, strong) NSMutableArray *pictureName1;

/// 下面面按钮组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *pictureBtnArr;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *deleteBtnArr;
@property (weak, nonatomic) IBOutlet UILabel *countLb2;
/// 存放图片
@property (nonatomic, strong) NSMutableArray *pictureArr2;
/// 存放上传后返回图片名
@property (nonatomic, strong) NSMutableArray *pictureName2;

@property (nonatomic, strong) ZLPhotoActionSheet *photoSheet;

#pragma mark - 数据参数
@property (nonatomic, strong) CNMBankModel *bankModel;
/// 默认 CNMPayUIStatusPaying
@property (nonatomic, assign) CNMPayUIStatus status;


@end

@implementation CNMFastPayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setStatusUI:self.status];
    self.pictureArr1 = [NSMutableArray arrayWithCapacity:1];
    self.pictureArr2 = [NSMutableArray arrayWithCapacity:4];
    self.pictureName1 = [NSMutableArray arrayWithCapacity:1];
    self.pictureName2 = [NSMutableArray arrayWithCapacity:4];
    
    [self loadData];
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(goToBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI {
    self.bankView.layer.borderWidth = 1;
    self.bankView.layer.borderColor = kHexColor(0x3A3D46).CGColor;
    self.bankView.layer.cornerRadius = 8;
    
    self.clockView.layer.cornerRadius = 10;
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    self.cancelBtn.layer.cornerRadius = 24;
}

- (void)setStatusUI:(CNMPayUIStatus)status {
    self.status = status;
    for (int i = 0; i <= status; i++) {
        if (i >= self.statusIVs.count) {
            break;
        }
        UIImageView *iv = self.statusIVs[i];
        [iv setHighlighted:YES];
        UILabel *label = self.statusLbs[i];
        label.textColor = UIColor.whiteColor;
    }
    
    switch (status) {
        case CNMPayUIStatusConfirm:
            self.title = @"待确认到账";
            self.headerH.constant = 140;
            self.tip1Lb.text = @"已等待";
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = YES;
            
            self.bankRow5.hidden = NO;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = NO;
            
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = NO;
            break;
        case CNMPayUIStatusSuccess:
            self.title = @"存款完成";
            self.headerH.constant = 140;
            self.tip1Lb.hidden = YES;
            self.tip2Lb.hidden = YES;
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = NO;
            self.tip5Lb.textColor = kHexColor(0x6D778B);
            self.tip5Lb.text = @"您完成了一笔存款";
            self.tip5LbH.constant = 16;
            
            self.amountTitleLb.hidden = YES;
            self.amountTipLb.hidden = NO;
            self.amountTipLbH.constant = 50;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            self.rowTitle6.text = @"订单编号：";
            
            self.lineView.hidden = YES;
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = YES;
            self.confirmTipViewH.constant = 0;
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = YES;
            [self.customerServerBtn setTitle:@"返回首页" forState:UIControlStateNormal];
            break;
        default:
            self.title = @"等待存款";
            self.amountTipLb.hidden = YES;
            self.amountTipLbH.constant = 0;
            self.submitTipView.hidden = NO;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = YES;
            self.bankRow7.hidden = NO;
            
            self.confirmTipView.hidden = YES;
            self.customerServerBtn.hidden = YES;
            self.confirmBtn.enabled = YES;
            break;
    }
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self showLoading];
    [CNMatchPayRequest queryDepisit:self.transactionId finish:^(id responseObj, NSString *errorMsg) {
        [self hideLoading];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            [weakSelf reloadUIWithModel:[CNMBankModel cn_parse:[dic objectForKey:@"data"]]];
            return;
        }
        [self showError:errorMsg];
    }];
}

- (void)reloadUIWithModel:(CNMBankModel *)bank {
    if (bank == nil) {
        return;
    }
    self.bankModel = bank;
    
    // 银行卡栏目信息
    self.amountLb.text = [NSString stringWithFormat:@"%ld", bank.amount.integerValue];
    [self.bankLogo sd_setImageWithURL:[NSURL URLWithString:[PublicMethod nowCDNWithUrl:bank.bankIcon]]];
    self.bankName.text = bank.bankName;
    self.accountName.text = bank.bankAccountName;
    self.accountNo.text = bank.bankAccountNo;
    self.bankAmount.text = [NSString stringWithFormat:@"%.2f元", bank.amount.floatValue];
    self.submitDate.text = bank.createdDate;
    self.confirmDate.text = bank.confirmTime;
    
    NSString *timeSting;
    switch (bank.status) {
        case CNMPayBillStatusSubmit:
            [self setStatusUI:CNMPayUIStatusSubmit];
            break;
        case CNMPayBillStatusPaying:
            [self setStatusUI:CNMPayUIStatusPaying];
            timeSting = bank.payLimitTimeFmt;
            break;
        case CNMPayBillStatusCancel:
            // 订单取消，直接回到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        case CNMPayBillStatusTimeout: {
            NSString *desc = [NSString stringWithFormat:@"您今天还有 %ld 次取消机会，如果超过%ld次，可能会冻结账号。", self.cancelTime, self.cancelTime];
            [CNMAlertView showAlertTitle:@"超时提醒" content:@"老板，您已存款超时，系统自动取消订单" desc:desc needRigthTopClose:NO commitTitle:@"关闭" commitAction:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            } cancelTitle:nil cancelAction:nil];
        }
            break;
        case CNMPayBillStatusConfirm:
            [self setStatusUI:CNMPayUIStatusConfirm];
            
            self.customerServerBtn.enabled = (bank.withdrawStatus == 6);
            timeSting = bank.confirmTimeFmt;
            // 这个状态需要定时刷新
            [self refreshBillStatusOntime];
            break;
        case CNMPayBillStatusUnMatch:
            
            break;
        case CNMPayBillStatusSuccess:
            [self setStatusUI:CNMPayUIStatusSuccess];
            self.confirmDate.text = bank.transactionId;
            self.amountTipLb.text = [NSString stringWithFormat:@"恭喜老板！获得存款返利礼金 %.2f 元\n每周一统一发放", (bank.amount.doubleValue *0.01)];
            // 停止倒计时
            [self.timer invalidate];
            self.timer = nil;
            break;
    }
    
    if (timeSting) {
        NSArray *tem = [timeSting componentsSeparatedByString:@";"];
        self.timeInterval = [tem.firstObject intValue] * 60 + [tem.lastObject intValue];
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)timerCounter {
    // 待确认是正计时
    if (self.status == CNMPayUIStatusConfirm) {
        self.timeInterval += 1;
    } else { // 倒计时
        self.timeInterval -= 1;
        if (self.timeInterval <= 0) {
            [self.timer setFireDate:[NSDate distantFuture]];
            self.timeInterval = 0;
            // 等待倒计时为0，在刷一次接口即可
            [self loadData];
        }
    }
    self.tip2Lb.text = [NSString stringWithFormat:@"%02ld分%02ld秒", self.timeInterval/60, self.timeInterval%60];
}

/// 待确认状态 CNMPayUIStatusConfirm 需要定时刷新订单状态
- (void)refreshBillStatusOntime {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBillStatus];
    });
}

- (void)refreshBillStatus {
    __weak typeof(self) weakSelf = self;
    [CNMatchPayRequest queryDepisit:self.transactionId finish:^(id responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            CNMBankModel *bank = [CNMBankModel cn_parse:[dic objectForKey:@"data"]];
            if (bank.status == CNMPayBillStatusSuccess) {
                [weakSelf reloadUIWithModel:bank];
                return;
            }
            
            if (bank.status == CNMPayBillStatusConfirm) {
                weakSelf.customerServerBtn.enabled = (bank.withdrawStatus == 6);
            }
        }
        [weakSelf refreshBillStatusOntime];
    }];
}


#pragma mark - 按钮组事件

- (IBAction)cancel:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSString *desc = [NSString stringWithFormat:@"您今天还有 %ld 次取消机会，如果超过%ld次，可能会冻结账号。", self.cancelTime, self.cancelTime];
    [CNMAlertView showAlertTitle:@"取消存款" content:@"老板！如已存款，请不要取消" desc:desc needRigthTopClose:NO commitTitle:@"确定" commitAction:^{
        // 调接口取消
        [self showLoading];
        [CNMatchPayRequest cancelDepisit:weakSelf.bankModel.transactionId finish:^(id responseObj, NSString *errorMsg) {
            [self hideLoading];
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObj;
                NSString *result = [dic objectForKey:@"code"];
                if ([result isKindOfClass:[NSString class]] && [result isEqualToString:@"00000"]) {
                    [CNTOPHUB showSuccess:@"取消成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                    return;
                }
            }
            [CNTOPHUB showError:errorMsg];
        }];
    } cancelTitle:@"返回" cancelAction:nil];
}

- (IBAction)confirm:(UIButton *)sender {
    if (self.pictureView.superview) {
        // 上传图片
        [self uploadImages];
        return;
    }
    self.pictureView.frame = self.midView.bounds;
    [self.midView addSubview:self.pictureView];
    sender.enabled = NO;
}

- (IBAction)customerServer:(UIButton *)sender {
    if (self.status == CNMPayUIStatusSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [CNTOPHUB showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持"];
        }
    }];
}

- (IBAction)copyContent:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.contentLbArray[sender.tag].text;
    [CNTOPHUB showSuccess:@"复制成功"];
}

- (void)goToBack {
    if (_backToLastVC) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 选择相册

- (IBAction)selectSinglePicture:(UIButton *)sender {
    if (sender.selected) {
        //放大图片查看
        [self showBigImages:self.pictureArr1 index:sender.tag];
        return;
    }
    self.photoSheet.configuration.maxSelectCount = 1;
    self.photoSheet.configuration.maxPreviewCount = 1;
    self.photoSheet.configuration.allowTakePhotoInLibrary = NO;
    __weak typeof(sender) weakSender = sender;
    __weak typeof(self) weakSelf = self;
    self.photoSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSender setBackgroundImage:images.firstObject forState:UIControlStateSelected];
        weakSender.selected = YES;
        weakSelf.deleteBtn.hidden = NO;
        [weakSelf.pictureArr1 addObject:images.firstObject];
        [weakSelf checkConfirmBtnEnable];
    };
    [self.photoSheet showPhotoLibrary];
}

- (IBAction)selectPictures:(UIButton *)sender {
    if (sender.selected) {
        //放大图片查看
        [self showBigImages:self.pictureArr2 index:sender.tag];
        return;
    }
    NSInteger leftCount = 4 - self.pictureArr2.count;
    self.photoSheet.configuration.maxSelectCount = leftCount;
    self.photoSheet.configuration.allowTakePhotoInLibrary = NO;
    __weak typeof(sender) weakSender = sender;
    __weak typeof(self) weakSelf = self;
    self.photoSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        weakSender.selected = YES;
        [weakSelf.pictureArr2 addObjectsFromArray:images];
        //按序加载图片
        [weakSelf reloadImages];
    };
    [self.photoSheet showPhotoLibrary];
}

/// 放大图片查看
- (void)showBigImages:(NSArray *)images index:(NSInteger)index {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:images.count];
    for (UIImage *img in images) {
        [photos addObject:GetDictForPreviewPhoto(img, ZLPreviewPhotoTypeUIImage)];
    }
    ZLPhotoActionSheet *sheet = [[ZLPhotoActionSheet alloc] init];
    sheet.sender = self;
    sheet.configuration.allowSelectImage = NO;
    sheet.configuration.allowSelectVideo = NO;
    sheet.configuration.allowTakePhotoInLibrary = NO;
    sheet.configuration.allowEditImage = NO;
    sheet.configuration.navTitleColor = self.view.backgroundColor;
    sheet.configuration.navBarColor = kHexColor(0x4083E8);
    [sheet previewPhotos:photos index:index hideToolBar:YES complete:^(NSArray * _Nonnull photos) {}];
}

- (void)reloadImages {
    
    for (UIButton *btn in self.pictureBtnArr) {
        btn.selected = NO;
    }
    
    for (UIButton *btn in self.deleteBtnArr) {
        btn.hidden = YES;
    }
    
    for (int i = 0; i < self.pictureArr2.count; i++) {
        [self.pictureBtnArr[i] setImage:self.pictureArr2[i] forState:UIControlStateSelected];
        self.pictureBtnArr[i].selected = YES;
        self.deleteBtnArr[i].hidden = NO;
    }
    [self checkConfirmBtnEnable];
}

- (void)checkConfirmBtnEnable {
    self.countLb1.text = [NSString stringWithFormat:@"%ld/1", self.pictureArr1.count];
    self.countLb2.text = [NSString stringWithFormat:@"%ld/4", self.pictureArr2.count];
    self.confirmBtn.enabled = (self.pictureArr1.count > 0 && self.pictureArr2.count > 0);
}

- (IBAction)deleteSinglePicture:(UIButton *)sender {
    self.pictureBtn.selected = NO;
    sender.hidden = YES;
    [self.pictureArr1 removeAllObjects];
    [self checkConfirmBtnEnable];
}

- (IBAction)deleteSelectPictures:(UIButton *)sender {
    [self.pictureArr2 removeObjectAtIndex:sender.tag];
    [self reloadImages];
}

#pragma mark - 图片上传

/// 图片上传
- (void)uploadImages {
    [self showLoading];
    __block NSInteger uploadCount = self.pictureArr1.count + self.pictureArr2.count;
    // 有就不用再次上传了
    if (self.pictureName1.count == 0) {
        [CNMatchPayRequest uploadImage:self.pictureArr1.lastObject finish:^(id responseObj, NSString *errorMsg) {
            uploadCount -= 1;
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObj;
                NSString *name = [dic objectForKey:@"fileName"];
                if (name) {
                    [self.pictureName1 addObject:name];
                }
            }
            if (uploadCount == 0) {
                [self uploadFinish];
            }
        }];
    } else {
        uploadCount -= self.pictureArr1.count;
    }
    
    // 有就不用再次上传了
    if (self.pictureName2.count > 0) {
        uploadCount -= self.pictureArr2.count;
        return;
    }
    for (int i = 0; i < self.pictureArr2.count; i ++) {
        // 同时上传会超时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i+1)*2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CNMatchPayRequest uploadImage:self.pictureArr2[i] finish:^(id responseObj, NSString *errorMsg) {
                uploadCount -= 1;
                if ([responseObj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)responseObj;
                    NSString *name = [dic objectForKey:@"fileName"];
                    if (name) {
                        [self.pictureName2 addObject:name];
                    }
                }
                if (uploadCount == 0) {
                    [self uploadFinish];
                }
            }];
        });
    }
}

- (void)uploadFinish {
    // 只要没有，重选上传
    if (self.pictureName1.count == 0 || self.pictureName2.count == 0) {
        [self uploadImages];
        return;
    }
    // 上报数据
    [CNMatchPayRequest commitDepisit:self.transactionId receiptImg:self.pictureName1.firstObject transactionImg:self.pictureName2 finish:^(id responseObj, NSString *errorMsg) {
        [self hideLoading];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            if ([[dic objectForKey:@"code"] isEqualToString:@"00000"]) {
                [self setStatusUI:CNMPayUIStatusConfirm];
                [self.pictureView removeFromSuperview];
                [self loadData];
            } else {
                [CNTOPHUB showError:errorMsg];
            }
        }
    }];
}

- (ZLPhotoActionSheet *)photoSheet {
    if (!_photoSheet) {
        _photoSheet = [[ZLPhotoActionSheet alloc] init];
        _photoSheet.sender = self;
        _photoSheet.configuration.allowSelectImage = YES;
        _photoSheet.configuration.allowSelectVideo = NO;
        _photoSheet.configuration.allowTakePhotoInLibrary = NO;
        _photoSheet.configuration.allowEditImage = YES;
        _photoSheet.configuration.allowSelectOriginal = NO;
        _photoSheet.configuration.navTitleColor = self.view.backgroundColor;
        _photoSheet.configuration.navBarColor = kHexColor(0x4083E8);
    }
    return _photoSheet;
}

#pragma mark - Setter Getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCounter) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
@end
