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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUI];
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
    //reload
}

#pragma mark -
#pragma mark Custom Method
- (void)setupUI {    
    [self.gradientLabel setupGradientColorFrom:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
    if (self.type == MissionCompleteTypeFirstFill) {
        BYFirstFillBannerView *bannerView = [[BYFirstFillBannerView alloc] init];
        bannerView.frame = self.bannerBackground.bounds;
        [self.bannerBackground addSubview:bannerView];
    }
    else {
        BYMoreCompleteMissionView *bannerView = [[BYMoreCompleteMissionView alloc] init];
        [bannerView setDelegate:self];
        bannerView.frame = self.bannerBackground.bounds;
        [self.bannerBackground addSubview:bannerView];
    }
}


@end
