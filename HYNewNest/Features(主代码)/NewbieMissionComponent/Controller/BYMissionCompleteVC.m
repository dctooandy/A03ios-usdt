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

@interface BYMissionCompleteVC ()<BYMoreCompleteDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerBackground;
@property (weak, nonatomic) IBOutlet UILabel *receivedUSDTLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradientLabel;

@end

@implementation BYMissionCompleteVC
@synthesize bannerBackground;
@synthesize receivedUSDTLabel;
@synthesize gradientLabel;
@synthesize type;

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
    
    [self receivedData:self.result];
    
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
#pragma mark PostData
- (void)receivedData:(CNTaskReceived *)result {
    [LoadingView show];
    WEAKSELF_DEFINE
    [CNTaskRequest applyTaskRewardIds:result.receivedID code:result.receivedCode handler:^(id responseObj, NSString *errorMsg) {
        [LoadingView hide];
        if (!errorMsg) {
            CNTaskReceivedReward *reward = [CNTaskReceivedReward cn_parse:responseObj];
            STRONGSELF_DEFINE
            if (strongSelf.resultArray.count > 0) {
                [strongSelf.resultArray removeObjectAtIndex:0];
                [strongSelf setupBanner];
            }
            [strongSelf.receivedUSDTLabel setText:[NSString stringWithFormat:@"%liUSDT", reward.sucAmount]];
            
        }
    }];
}

#pragma mark -
#pragma mark Delegate
- (void)moreBannerClicked {
    //reload
    if (self.type == MissionCompleteTypeLimite) {
        
    }
    else {
        //call api
        if (self.resultArray.count > 0) {
            CNTaskReceived *recevied = self.resultArray.firstObject.mutableCopy;
            [self receivedData:recevied];
        }
    }
}

#pragma mark -
#pragma mark Custom Method
- (void)setupBanner {
    for (UIView *subview in self.bannerBackground.subviews) {
        [subview removeFromSuperview];
    }
    
    if (self.type == MissionCompleteTypeLimite) {
        BYFirstFillBannerView *bannerView = [[BYFirstFillBannerView alloc] init];
        bannerView.frame = self.bannerBackground.bounds;
        [self.bannerBackground addSubview:bannerView];
    }
    else if (self.resultArray.count > 0){
        BYMoreCompleteMissionView *bannerView = [[BYMoreCompleteMissionView alloc] init];
        [bannerView setDelegate:self];
        bannerView.frame = self.bannerBackground.bounds;
        [self.bannerBackground addSubview:bannerView];
    }
    
}


@end
