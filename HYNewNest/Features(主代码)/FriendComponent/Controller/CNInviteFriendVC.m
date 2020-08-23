//
//  CNInviteFriendVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNInviteFriendVC.h"
#import "CNTwoStatusBtn.h"
#import "CNUserCenterRequest.h"
#import "CNHomeRequest.h"
#import "CNShareView.h"
#import "HYOneBtnAlertView.h"
#import "SGQRCodeGenerateManager.h"
#import "OCBarrage.h"
#import "OCBarrageGradientBackgroundColorCell.h"

@interface CNInviteFriendVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *shareBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *stepLbs;
/// 查看收入按钮
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
/// 显示邀请人数量
@property (weak, nonatomic) IBOutlet UILabel *lblInvite;
/// 链接
@property (weak, nonatomic) IBOutlet UILabel *linkLb;
/// 链接图
@property (weak, nonatomic) IBOutlet UIImageView *linkIV;

/// 承载弹幕图
@property (weak, nonatomic) IBOutlet UIView *barrageView;
/// 弹幕管理者
@property (nonatomic, strong) OCBarrageManager *barrageManager;
@property (nonatomic, strong) AgentRecordModel *agentModel;
@property (nonatomic, strong) FriendShareGroupModel *shareModel;
@end

@implementation CNInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友分享";
    [self addNaviRightItemWithTitle:@"规则说明"];
    self.contentWidth.constant = kScreenWidth;
    self.contentView.backgroundColor = self.view.backgroundColor = kHexColor(0x212137);
    
    self.incomeBtn.layer.borderWidth = 1;
    self.incomeBtn.layer.borderColor = kHexColor(0x10B4DD).CGColor;
    self.incomeBtn.layer.cornerRadius = self.incomeBtn.bounds.size.height *0.5;
    self.shareBtn.enabled = YES;
    // 步骤圆角边框
    for (UILabel *lb in self.stepLbs) {
        lb.layer.cornerRadius = 20;
        lb.layer.borderWidth = 1;
        lb.layer.borderColor = kHexColor(0x10B4DD).CGColor;
        lb.layer.masksToBounds = YES;
    }
    
    [self queryMessages];
    [self queryShareLinks];
    
    // 初始化弹幕
    [self initBarrage];
}

- (void)rightItemAction {
    
    [HYOneBtnAlertView showWithTitle:@"规则说明" content:@"1、您必须达到1星级方可参加活动；\n2、被邀请人单周有效投注额≥1500USDT，您可以获取无流水要求0.1%%佣金，无上限；\n3、重复注册将无法产生该优惠；\n4、币游享有本活动最终解释权，如有不诚实套利用户，获取的金额会被撤销；" comfirmText:@"我知道了" comfirmHandler:^{
    }];
}

- (void)updateShare {
    // 链接和链接图
    AdBannerModel *model = self.shareModel.bannersModel.firstObject;
    NSString *shareLink = [NSString stringWithFormat:@"%@%@", model.linkUrl, [CNUserManager shareManager].userInfo.customerId];
    self.linkLb.text = shareLink;
    UIImage *img = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:shareLink imageViewWidth:self.linkIV.width];
    self.linkIV.image = img;
}

- (void)updateViews {
    WsQuerySumCount *sumCount = self.agentModel.wsQuerySumCount;
    
    // 邀请人样式
    NSString *peple = sumCount.count ?: @"0";
    NSString *amount = sumCount.sumAmount ?: @"0.00";
    NSString *text = [NSString stringWithFormat:@"我已邀请%@人，获得%@元现金", peple, amount];

    NSRange rangeA = [text rangeOfString:peple];
    NSString *tempText = [text componentsSeparatedByString:@"，"].lastObject;
    NSRange rangeB = [tempText rangeOfString:amount];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:text];
    [aStr addAttribute:NSForegroundColorAttributeName value:kHexColor(0xD65A18) range:rangeA];
    [aStr addAttribute:NSForegroundColorAttributeName value:kHexColor(0xD65A18) range:NSMakeRange(rangeA.location + 2 + rangeA.length + rangeB.location, rangeB.length)];//2 == "人，"
    
    self.lblInvite.attributedText = aStr;
    
    //这是每个悬浮item的数据
    NSArray <ResultItem *> *items = self.agentModel.result;
    [self addBarrage:items];
}

// 查看我的收入
- (IBAction)seeMyIncome:(id)sender {
    [NNPageRouter jump2HTMLWithStrURL:@"https://m.ag88win.com" title:@"好友推荐"];
}

// 分享
- (IBAction)share:(id)sender {
    [CNShareView showShareViewWithModel:self.shareModel];
    // 分享即复制，后面各平台就不需要复制了
    [UIPasteboard generalPasteboard].string = self.linkLb.text;
}

// 复制
- (IBAction)copyLink:(id)sender {
    [UIPasteboard generalPasteboard].string = self.linkLb.text;
    [CNHUB showSuccess:@"已复制到剪切板！"];
}


#pragma mark - REQUEST
- (void)queryMessages {
    [CNUserCenterRequest queryAgentRecordsHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.agentModel = [AgentRecordModel cn_parse:responseObj];
            [self updateViews];
        }
    }];
}

/// 分享链接
- (void)queryShareLinks {
    [CNHomeRequest requestBannerWhere:BannerWhereFriend Handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            self.shareModel = [FriendShareGroupModel cn_parse:responseObj];
            [self updateShare];
        }
    }];
}

#pragma - mark 弹幕

- (void)initBarrage {
    self.barrageManager = [[OCBarrageManager alloc] init];
    [self.barrageView addSubview:self.barrageManager.renderView];
    self.barrageManager.renderView.frame = self.barrageView.bounds;
    self.barrageManager.renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)addBarrage:(NSArray <ResultItem *> *)array {
    // 启动弹幕
    [self.barrageManager start];
    
    for (int i = 0; i < array.count; i++) {
        // 显示超文本
        ResultItem *item = array[i];
        NSString *amount = [NSString stringWithFormat:@"%.2ld", item.agentCommission];
        NSString *text = [NSString stringWithFormat:@"%@推荐好友成功，获得%@元礼金    ",item.loginName, amount];
        NSRange range = [text rangeOfString:amount];
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:text];
        [aStr addAttribute:NSForegroundColorAttributeName value:kHexColor(0xD80052) range:range];
        
        // 每隔1秒加一个
        [self performSelector:@selector(startBarrageWith:) withObject:aStr afterDelay:1.5*i];
    }
}

- (void)startBarrageWith:(NSMutableAttributedString *)aStr {
    OCBarrageGradientBackgroundColorDescriptor *gradient = [[OCBarrageGradientBackgroundColorDescriptor alloc] init];
    gradient.textColor = [UIColor whiteColor];
    gradient.positionPriority = OCBarragePositionHigh;
    gradient.textFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    gradient.strokeWidth = -1;
    gradient.fixedSpeed = 20.0;//用fixedSpeed属性设定速度
    gradient.barrageCellClass = [OCBarrageGradientBackgroundColorCell class];
    gradient.gradientColor = kHexColorAlpha(0x10B4DD, 0.7);
    gradient.textShadowOpened = YES;
    
    // 多文本存在文案计算宽度问题，直接修改第三方内部文件
    gradient.attributedText = aStr;
//    gradient.text = @"多文本存在文案计算宽度问题，直接修改第三方内部文件";
    [self.barrageManager renderBarrageDescriptor:gradient];
}

@end

 
