//
//  CNFeedBackVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNFeedBackVC.h"
#import "CNFeedBackRightTCell.h"
#define kCNFeedBackRightTCellID  @"CNFeedBackRightTCell"
#import "CNFeedBackLeftTCell.h"
#define kCNFeedBackLeftTCellID  @"CNFeedBackLeftTCell"
#import "CNUserCenterRequest.h"
#import "CNBaseTF.h"
#import <UIImageView+WebCache.h>

@interface CNFeedBackVC () <UITableViewDataSource>
// 底部间隔，随键盘而起
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CNBaseTF *suggesTf;
@property (nonatomic, strong) NSArray<UserSuggestionModel *> *suggests;
@end

@implementation CNFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈意见";
//    [self addKeyboardNotification];
    [self configUI];
    
    [self querySuggestions];

}

// 发送
- (IBAction)send:(id)sender {
    if (KIsEmptyString(_suggesTf.text)) {
        return;
    }
    [CNUserCenterRequest submitSugestionContent:_suggesTf.text handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            self.suggesTf.text = @"";
            [self querySuggestions];
        }
    }];
}

- (void)configUI {
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNFeedBackLeftTCellID bundle:nil] forCellReuseIdentifier:kCNFeedBackLeftTCellID];
    [self.tableView registerNib:[UINib nibWithNibName:kCNFeedBackRightTCellID bundle:nil] forCellReuseIdentifier:kCNFeedBackRightTCellID];
}

#pragma mark - REQUEST
- (void)querySuggestions{
    [CNUserCenterRequest querySuggestionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            if (!responseObj) {
                [self.tableView reloadData];
            } else {
                NSArray *arr = [UserSuggestionModel cn_parse:responseObj];
                if (arr.count) {
                    self.suggests = arr;
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }
    }];
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.suggests.count*2;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    NSInteger modelIdx = (2*self.suggests.count)-1-indexPath.row;//model 是倒序的
    UserSuggestionModel *model = self.suggests[modelIdx/2];
    
    if (indexPath.row % 2 == 0) {
        CNFeedBackRightTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNFeedBackRightTCellID forIndexPath:indexPath];
        cell.timeLb.text = model.createdDate;
        cell.contentLb.text = model.content;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"2"]];
        return cell;
    } else {
        CNFeedBackLeftTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNFeedBackLeftTCellID forIndexPath:indexPath];
        cell.timeLb.text = model.lastUpdate;
        cell.contentLb.text = model.remarks?:@"反馈已收到,客服会尽快回复";
        cell.imageV.image = [UIImage imageNamed:@"a03_main_kefu"];
        return cell;
    }
}

/* 暂不需要
#pragma - mark 键盘动画
 
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    NSDictionary *dic = notifi.userInfo;
    NSInteger animationType = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [dic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (@available(iOS 11.0, *)) {
        self.bottomSpace.constant = rect.size.height - self.view.safeAreaInsets.bottom;
    } else {
        self.bottomSpace.constant = rect.size.height;
    }
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    NSInteger animationType = [notifi.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomSpace.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
@end
