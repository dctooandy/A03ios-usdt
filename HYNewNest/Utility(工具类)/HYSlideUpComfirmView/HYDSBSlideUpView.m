//
//  HYDSBSlideUpView.m
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYDSBSlideUpView.h"
#import "HYDSBSlideUpViewCell.h"

@interface HYDSBSlideUpView() <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation HYDSBSlideUpView

+ (void)showSlideupView {
    [[HYDSBSlideUpView alloc] initWithContentViewHeight:410 title:@"周累计盈利" comfirmBtnText:@""];
    
    [NNControllerHelper currentTabBarController].tabBar.hidden = YES;
}

- (instancetype)initWithContentViewHeight:(CGFloat)height title:(NSString *)title comfirmBtnText:(NSString *)btnTitle {
    self = [super initWithContentViewHeight:height title:title comfirmBtnText:btnTitle];
    [self setupViews];
    
    [self.tableView reloadData];
    return self;
}

- (void)setupViews {
    self.comfirmBtn.hidden = YES;
    self.titleLbl.backgroundColor = kHexColor(0x202238);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, kScreenWidth, 410-57)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kHexColor(0x202238);
    _tableView.scrollEnabled = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"HYDSBSlideUpViewCell" bundle:nil] forCellReuseIdentifier:@"HYDSBSlideUpViewCell"];
    
    [self.contentView addSubview:_tableView];
}

- (void)dismiss {
    [super dismiss];
    
    [NNControllerHelper currentTabBarController].tabBar.hidden = NO;
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDSBSlideUpViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYDSBSlideUpViewCell"];
    
    return cell;
}

@end
