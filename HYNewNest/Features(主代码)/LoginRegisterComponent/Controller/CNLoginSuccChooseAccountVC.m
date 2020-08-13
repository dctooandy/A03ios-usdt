//
//  CNLoginSuccChooseAccountVC.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/25.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNLoginSuccChooseAccountVC.h"
#import "CNAlertPickerView.h"
#import "CNAccountSelectView.h"
#import "CNTwoStatusBtn.h"

@interface CNLoginSuccChooseAccountVC ()
@property (weak, nonatomic) IBOutlet CNAccountSelectView *accountSelectView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *loginBtn;
@property (nonatomic, copy) NSString *selectedName;
@end

@implementation CNLoginSuccChooseAccountVC

- (IBAction)accountSelectClick:(id)sender {

    NSArray <SamePhoneLoginNameItem *> *items = self.samePhoneLogNameModel.samePhoneLoginNames;
    NSMutableArray *names = @[].mutableCopy;
    for (SamePhoneLoginNameItem *item in items) {
        [names addObject:item.loginName];
    }
    
    WEAKSELF_DEFINE
    [CNAlertPickerView showList:names title:@"选择账号" finish:^(NSString * _Nonnull selectText) {
        STRONGSELF_DEFINE
        strongSelf.selectedName = selectText;
        strongSelf.loginBtn.enabled = YES;
        strongSelf.accountSelectView.loginNameTf.text = selectText;
    }];
}

- (IBAction)loginBtnClick:(id)sender {
    [CNLoginRequest mulLoginSelectedLoginName:self.selectedName
                                    messageId:self.samePhoneLogNameModel.messageId
                                   validateId:self.samePhoneLogNameModel.validateId
                            completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNHUB showSuccess:@"登录成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navBarTransparent = YES;
//    self.makeTranslucent = YES;
    self.view.backgroundColor = kHexColor(0x212137);
    
    self.accountSelectView.loginNameTf.text = self.samePhoneLogNameModel.samePhoneLoginNames.firstObject.loginName;
    
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
