//
//  HYCTZNPlayerViewController.m
//  HYGEntire
//
//  Created by zaky on 7/18/20.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "HYCTZNPlayerViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "NSAttributedString+SJMake.h"

@interface HYCTZNPlayerViewController ()
@property (strong,nonatomic) SJVideoPlayer *player;
@end

@implementation HYCTZNPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    _player.defaultEdgeControlLayer.showResidentBackButton = YES;
    _player.pausedToKeepAppearState = YES;
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    _player.resumePlaybackWhenAppDidEnterForeground = YES;
    [self.view addSubview:_player.view];

    NSURL *url = [NSURL URLWithString:self.sourceUrl];
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
    asset.startPosition = 0;
//    asset.trialEndPosition = 30; // 试看30秒
    WEAKSELF_DEFINE
    asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        STRONGSELF_DEFINE
        make.append(strongSelf.tit);
        make.textColor(UIColor.whiteColor);
    }];
    _player.URLAsset = asset;
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
        make.top.equalTo(self.view).mas_offset(kStatusBarHeight);
        make.bottom.equalTo(self.view).mas_offset(-kSafeAreaHeight);
        make.left.right.equalTo(self.view);
    }];

    __weak typeof(self) _self = self;
    _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
#ifdef DEBUG
        NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
    };
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
