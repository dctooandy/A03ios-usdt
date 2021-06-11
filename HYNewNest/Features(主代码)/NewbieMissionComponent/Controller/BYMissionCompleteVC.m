//
//  BYMissionCompleteVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYMissionCompleteVC.h"
#import "BYFirstFillBannerView.h"
#import "UILabel+Gradient.h"
#import "BYMoreCompleteMissionView.h"
#import "NNPageRouter.h"
#import "CNTaskRequest.h"
#import "CNTaskModel.h"
#import "LoadingView.h"

@interface BYMissionCompleteVC ()<BYMissionBannerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerBackground;
@property (weak, nonatomic) IBOutlet UILabel *receivedUSDTLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradientLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@end

@implementation BYMissionCompleteVC
@synthesize bannerBackground;
@synthesize receivedUSDTLabel;
@synthesize gradientLabel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBanner];
    [self.gradientLabel setupGradientColorFrom:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
    [self.rewardLabel setText:[NSString stringWithFormat:@"%liUSDT",self.reward.sucAmount]];
        
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark IBAction
- (IBAction)backToMain:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -
#pragma mark Delegate
- (void)moreBannerClicked {
    [self dismissViewControllerAnimated:false completion:nil];
    [NNPageRouter jump2HTMLWithStrURL:H5URL_Pub_Coin
                                title:@"首存活動"
                          needPubSite:false];
}

#pragma mark -
#pragma mark Custom Method
- (void)setupBanner {
    BYFirstFillBannerView *bannerView = [[BYFirstFillBannerView alloc] init];
    bannerView.frame = self.bannerBackground.bounds;
    bannerView.delegate = self;
    [self.bannerBackground addSubview:bannerView];
}


@end
