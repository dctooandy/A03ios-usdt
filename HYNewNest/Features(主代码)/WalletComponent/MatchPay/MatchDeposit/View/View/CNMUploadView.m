//
//  CNMUploadView.m
//  HYNewNest
//
//  Created by cean on 3/21/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNMUploadView.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import <ZLPhotoBrowser/ZLShowBigImgViewController.h>
#import "CNMatchPayRequest.h"
#import <CSCustomSerVice/CSCustomSerVice.h>


@interface CNMUploadView ()
#pragma mark - 上面一个按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb1;
/// 存放图片
@property (nonatomic, strong) NSMutableArray *pictureArr1;

#pragma mark - 下面按钮组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *pictureBtnArr;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray <UIButton *> *deleteBtnArr;
@property (weak, nonatomic) IBOutlet UILabel *countLb2;
/// 存放图片
@property (nonatomic, strong) NSMutableArray *pictureArr2;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *promoIV;
@property (weak, nonatomic) IBOutlet UIButton *serverBtn;

@property (nonatomic, strong) ZLPhotoActionSheet *photoSheet;
/// 添加到该控制器
@property (nonatomic, weak) UIViewController *superVC;
/// 订单号
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) void(^commitBlock)(NSArray *receiptImages, NSArray *recordImages);
@end

@implementation CNMUploadView

+ (void)showUploadViewTo:(UIViewController *)superVC billId:(NSString *)billId promo:(BOOL)promo commitDeposit:(void (^)(NSArray * _Nonnull, NSArray * _Nonnull))commitBlock {
    CNMUploadView *view = [[CNMUploadView alloc] initWithFrame:superVC.view.bounds];
    [superVC.view addSubview:view];
    view.superVC = superVC;
    view.billId = billId;
    view.commitBlock = commitBlock;
    if (promo) {
        [view.confirmBtn setBackgroundImage:[UIImage imageNamed:@"upload_light"] forState:UIControlStateNormal];
        [view.confirmBtn setBackgroundImage:[UIImage imageNamed:@"upload_grey"] forState:UIControlStateDisabled];
    } else {
        [view.confirmBtn setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
        [view.confirmBtn setBackgroundImage:[UIImage imageNamed:@"l_btn_hh"] forState:UIControlStateDisabled];
        [view.confirmBtn setTitle:@"确认存款" forState:UIControlStateNormal];
    }
}

- (void)loadViewFromXib {
    [super loadViewFromXib];
    self.pictureArr1 = [NSMutableArray arrayWithCapacity:1];
    self.pictureArr2 = [NSMutableArray arrayWithCapacity:4];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"联系客服"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[attributeString length]}];
    [attributeString addAttribute:NSForegroundColorAttributeName value:self.serverBtn.titleLabel.textColor range:NSMakeRange(0,[attributeString length])];

    //设置下划线颜色
    [attributeString addAttribute:NSUnderlineColorAttributeName value:self.serverBtn.titleLabel.textColor range:(NSRange){0,[attributeString length]}];
    [self.serverBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
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

- (void)checkConfirmBtnEnable {
    self.countLb1.text = [NSString stringWithFormat:@"%ld/1", self.pictureArr1.count];
    self.countLb2.text = [NSString stringWithFormat:@"%ld/4", self.pictureArr2.count];
    BOOL enabled = (self.pictureArr1.count > 0 || self.pictureArr2.count > 0);
    self.confirmBtn.enabled = enabled;
    self.promoIV.highlighted = enabled;
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

/// 放大图片查看
- (void)showBigImages:(NSArray *)images index:(NSInteger)index {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:images.count];
    for (UIImage *img in images) {
        [photos addObject:GetDictForPreviewPhoto(img, ZLPreviewPhotoTypeUIImage)];
    }
    ZLPhotoActionSheet *sheet = [[ZLPhotoActionSheet alloc] init];
    sheet.sender = self.superVC;
    sheet.configuration.allowSelectImage = NO;
    sheet.configuration.allowSelectVideo = NO;
    sheet.configuration.allowTakePhotoInLibrary = NO;
    sheet.configuration.allowEditImage = NO;
    sheet.configuration.navTitleColor = kHexColor(0x212228);
    sheet.configuration.navBarColor = kHexColor(0x4083E8);
    [sheet previewPhotos:photos index:index hideToolBar:YES complete:^(NSArray * _Nonnull photos) {}];
}

#pragma mark - 按钮组事件

- (IBAction)confirm:(UIButton *)sender {
    [self uploadImages];
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)server:(id)sender {
    // 联系客服
    [CSVisitChatmanager startWithSuperVC:self.superVC finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [CNTOPHUB showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持"];
        }
    }];
}

#pragma mark - 图片上传

/// 图片上传
- (void)uploadImages {
    [LoadingView showLoadingViewWithToView:self needMask:YES];
    __weak typeof(self) weakSelf = self;
    [CNMatchPayRequest uploadReceiptImages:self.pictureArr1 recordImages:self.pictureArr2 billId:self.billId finish:^(id responseObj, NSString *errorMsg) {
        [LoadingView hideLoadingViewForView:self];
        if (errorMsg) {
            [CNTOPHUB showError:errorMsg];
            return;
        }
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            [CNTOPHUB showSuccess:@"图片上传成功"];
            NSDictionary *dic = (NSDictionary *)responseObj;
            [weakSelf removeFromSuperview];
            !weakSelf.commitBlock ?: weakSelf.commitBlock([dic objectForKey:@"receiptOriginalFileNames"], [dic objectForKey:@"transactionOriginalFileNames"]);
        }
    }];
}

#pragma mark - Setter Getter

- (ZLPhotoActionSheet *)photoSheet {
    if (!_photoSheet) {
        _photoSheet = [[ZLPhotoActionSheet alloc] init];
        _photoSheet.sender = self.superVC;
        _photoSheet.configuration.allowSelectImage = YES;
        _photoSheet.configuration.allowSelectVideo = NO;
        _photoSheet.configuration.allowTakePhotoInLibrary = NO;
        _photoSheet.configuration.allowEditImage = YES;
        _photoSheet.configuration.allowSelectOriginal = NO;
        _photoSheet.configuration.navTitleColor = kHexColor(0x212228);
        _photoSheet.configuration.navBarColor = kHexColor(0x4083E8);
    }
    return _photoSheet;
}
@end
