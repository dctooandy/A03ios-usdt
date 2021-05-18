//
//  BYNewUsrMissionCell.m
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewUsrMissionCell.h"
#import "BYThreeStatusBtn.h"

#import "CNBindPhoneVC.h"
#import "HYXiMaViewController.h"

#import "HYInGameHelper.h"
#import "CNTaskRequest.h"
#import "CNSplashRequest.h"
#import "HYNewUsrMissonAlertView.h"

@interface BYNewUsrMissionCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLbTopSpacingCons;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet BYThreeStatusBtn *aBtn;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgv;

@end

@implementation BYNewUsrMissionCell

- (void)setIsUpgradeTask:(BOOL)isUpgradeTask {
    _isUpgradeTask = isUpgradeTask;
    if (isUpgradeTask) {
        _tagImgv.image = [UIImage imageNamed:@"_progress"];
    } else {
        _tagImgv.image = [UIImage imageNamed:@"_limited time"];
    }
}

- (void)setIsTimeout:(BOOL)isTimeout {
    _isTimeout = isTimeout;
    if (isTimeout && self.resModel.fetchResultFlag != 1) {
        [_aBtn setTitle:@"已失效" forState:UIControlStateNormal];
        _aBtn.status = CNThreeStaBtnStatusDark;
    }
}

- (void)setResModel:(Result *)resModel {
    _resModel = resModel;
    _titleLb.text = resModel.title;
    if (resModel.subtitle.length > 10) {
        _titleLbTopSpacingCons.constant = 11;
    } else {
        _titleLbTopSpacingCons.constant = 16;
    }
    _subTitleLb.text = resModel.subtitle;
    _amountLb.text = [NSString stringWithFormat:@"+%@",resModel.amount];
    
//    //1. 测去完成
//    _aBtn.status = CNThreeStaBtnStatusGradientBorder;
//    [_aBtn setTitle:@"去完成" forState:UIControlStateNormal];
//    _resModel.fetchResultFlag = -1;
    //2. 测领取
//    _aBtn.status = CNThreeStaBtnStatusGradientBackground;
//    [_aBtn setTitle:@"待领取" forState:UIControlStateNormal];
//    _resModel.fetchResultFlag = 0;
    //3. 测已领取
//    _aBtn.status = CNThreeStaBtnStatusDark;
//    [_aBtn setTitle:@"已领取" forState:UIControlStateNormal];
//    _resModel.fetchResultFlag = 1;
    
    //4. 已结束
    if (_isTimeout && resModel.fetchResultFlag != 1) {
        return;
    }
    
    _aBtn.status = (CNThreeStaBtnStatus)resModel.fetchResultFlag;
    switch (resModel.fetchResultFlag) {
        case -1:
            [_aBtn setTitle:@"去完成" forState:UIControlStateNormal];
            break;
        case 0:
            [_aBtn setTitle:@"待领取" forState:UIControlStateNormal];
            break;
        case 1:
            [_aBtn setTitle:@"已领取" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)didTapBtn:(id)sender {
    if (!_resModel) {
        [CNTOPHUB showError:@"出错了 请下拉刷新页面"];
        return;
    }
    if (_resModel.fetchResultFlag == 1) {
        [CNTOPHUB showError:@"您已领取过该奖励"];
        return;
    }
    
    UINavigationController *nav = [NNControllerHelper currentTabbarSelectedNavigationController];
    
    if ([_aBtn.titleLabel.text isEqualToString:@"已失效"]) {
        [HYNewUsrMissonAlertView showFirstDepositOrTaskEndIsEnd:YES handler:^(BOOL isComfm) {
            if (isComfm) {
                [nav popToRootViewControllerAnimated:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [NNControllerHelper currentTabBarController].selectedIndex = 2;
                });
            }
        }];
        return;
    }
    
    if (_resModel.fetchResultFlag == -1) { // 去完成
        if ([_resModel.title isEqualToString:@"完善资料"]) {
            CNBindPhoneVC *vc = [CNBindPhoneVC new];
            vc.bindType = CNSMSCodeTypeBindPhone;
            [nav pushViewController:vc animated:YES];
        } else if ([_resModel.title isEqualToString:@"首次充值"]) {
            [HYNewUsrMissonAlertView showFirstDepositOrTaskEndIsEnd:NO handler:^(BOOL isComfm) {
                if (isComfm) {
                    [NNPageRouter jump2Deposit];
                }
            }];
        } else if ([_resModel.title containsString:@"充值"]) {
            [NNPageRouter jump2Deposit];
        } else if ([_resModel.title isEqualToString:@"新手洗码"]) {
            [nav pushViewController:[HYXiMaViewController new] animated:YES];
        } else if ([_resModel.title isEqualToString:@"完成取款"]) {
            [NNPageRouter jump2Withdraw];
        } else if ([_resModel.title isEqualToString:@"累计体验"] || [_resModel.title isEqualToString:@"进阶投注"]) {
            [[HYInGameHelper sharedInstance] inGame:InGameTypeAGQJ];
        } else if ([_resModel.title isEqualToString:@"专享VIP"]) {
            [nav popToRootViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NNControllerHelper currentTabBarController].selectedIndex = 1;
            });
        } else if ([_resModel.title isEqualToString:@"手机登录"]) {
            [CNSplashRequest queryNewVersion:^(BOOL isHardUpdate) {
            }];
        }
        
    } else if (_resModel.fetchResultFlag == 0) { // 待领取
        if (_isBeyondClaim) {
            [CNTOPHUB showError:@"该奖品已过期"];
        } else {
            WEAKSELF_DEFINE
            [CNTaskRequest applyTaskRewardIds:_resModel.ID code:_resModel.prizeCode handler:^(id responseObj, NSString *errorMsg) {
                STRONGSELF_DEFINE
                if (!errorMsg) {
                    strongSelf.aBtn.status = CNThreeStaBtnStatusDark;
                    [strongSelf.aBtn setTitle:@"已领取" forState:UIControlStateNormal];
                }
            }];
        }
    }
}


@end
