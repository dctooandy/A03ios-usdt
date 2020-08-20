//
//  CNSettingVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNSettingVC.h"
#import "CNAlertPickerView.h"
#import "BRPickerView.h"
#import "CNChoseImageVC.h"
#import "CNFeedBackVC.h"
#import <UIImageView+WebCache.h>
#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"

@interface CNSettingVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *birthTF;

@property (weak, nonatomic) IBOutlet UILabel *btmVersionLb;

@end

@implementation CNSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    self.btmVersionLb.text = [NSString stringWithFormat:@"版本号：%@\nCOPYRIGHT © 2022 币游国际. ALL RIGHTS RESERVED.\n币游集团版权所有", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userDetail.avatar]];
        if ([[CNUserManager shareManager].userDetail.gender isEqualToString:@"F"]) {
            self.sexTF.text = @"女";
        } else if ([[CNUserManager shareManager].userDetail.gender isEqualToString:@"M"]) {
            self.sexTF.text = @"男";
        }
        if (!KIsEmptyString([CNUserManager shareManager].userDetail.birthday)) {
            self.birthTF.text = [CNUserManager shareManager].userDetail.birthday;
        }
    }];
}


#pragma mark - 按钮事件

/// 选择头像
- (IBAction)choseHeader:(id)sender {
    [self.navigationController pushViewController:[CNChoseImageVC new] animated:YES];
}

/// 选择性别
- (IBAction)choseSex:(id)sender {
    [CNAlertPickerView showList:@[@"男", @"女"] title:@"性别选择" finish:^(NSString * _Nonnull selectText) {
        self.sexTF.text = selectText;
        NSString *codeOfGender = @"F";
        if ([selectText isEqualToString:@"男"]) {
            codeOfGender = @"M";
        }
        [CNUserCenterRequest modifyUserRealName:nil gender:codeOfGender birth:nil avatar:nil onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
            if (!KIsEmptyString(errorMsg)) {
                [CNHUB showSuccess:@"性别修改成功"];
            }
        }];
    }];
}

/// 选择生日
- (IBAction)choseBirthday:(id)sender {
    [BRDatePickerView showDatePickerWithTitle:@"生日选择" dateType:BRDatePickerModeYMD defaultSelValue:self.birthTF.text resultBlock:^(NSString *selectValue) {
        self.birthTF.text = selectValue;
        [CNUserCenterRequest modifyUserRealName:nil gender:nil birth:selectValue avatar:nil onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
            if (!KIsEmptyString(errorMsg)) {
                [CNHUB showSuccess:@"生日修改成功"];
            }
        }];
    }];
}

/// 意见反馈
- (IBAction)feedback:(id)sender {
    [self.navigationController pushViewController:[CNFeedBackVC new] animated:YES];
}

/// 退出登录
- (IBAction)logout:(id)sender {
    [CNLoginRequest logoutHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [CNHUB showSuccess:@"您已退出登录"];
        } else {
            [[CNUserManager shareManager] cleanUserInfo];
        }
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


@end
