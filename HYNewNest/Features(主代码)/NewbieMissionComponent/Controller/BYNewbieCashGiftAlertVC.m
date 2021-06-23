//
//  BYNewbieCashGiftAlertVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieCashGiftAlertVC.h"
#import "BYMissionCompleteVC.h"

@interface BYNewbieCashGiftAlertVC ()
@property (weak, nonatomic) IBOutlet UILabel *unreadMsgLabel;

@end

@implementation BYNewbieCashGiftAlertVC
@synthesize unreadMsgLabel;

#define UNREAD(...) [NSString stringWithFormat:@"您有%i条未领取的\n新人礼金", __VA_ARGS__]

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kHexColorAlpha(0x10101C, 0.75);
    [self.unreadMsgLabel setText:UNREAD(10)];
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
- (IBAction)receivedClicked:(id)sender {
    [kCurNavVC dismissViewControllerAnimated:false completion:^{
        BYMissionCompleteVC *vc = [[BYMissionCompleteVC alloc] init];
        [kCurNavVC presentViewController:vc animated:true completion:nil];
    }];
     
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
