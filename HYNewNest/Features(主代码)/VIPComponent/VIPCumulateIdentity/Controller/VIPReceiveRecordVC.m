//
//  VIPReceiveRecordVC.m
//  HYNewNest
//
//  Created by zaky on 9/27/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPReceiveRecordVC.h"
#import "CNVIPRequest.h"
#import "VIPRecordSelectorView.h"

@interface VIPReceiveRecordVC () <UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageNo;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) VIPReceiveRecordType curType;
@property (nonatomic, assign) NSInteger preDays;
@end

@implementation VIPReceiveRecordVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"私享会记录";
    self.view.backgroundColor = self.tableView.backgroundColor = kHexColor(0x1A1A1A);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    btn.tintColor = kHexColor(0xD3D3D3);
    [self addNaviRightItemButton:btn];

    [self.navigationController.navigationBar setBackgroundImage:[UIColor gradientImageFromColors:@[kHexColor(0x252525), kHexColor(0x1A1A1A)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(kScreenWidth, kNavPlusStaBarHeight)]  forBarMetrics:UIBarMetricsDefault];
    
    _pageNo = 0;
    _curType = 1;
    [self.view addSubview:self.tableView];
    [self requestData];
    
}
     
- (void)dealloc {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage jk_imageWithColor:kHexColor(0x1A1A2C)]  forBarMetrics:UIBarMetricsDefault];
}

- (void)rightItemAction {
    [VIPRecordSelectorView showSelectorWithSelcType:_curType dayParm:_preDays callBack:^(VIPReceiveRecordType type, NSInteger day) {
        self.curType = type;
        self.preDays = day;
        self->_pageNo = 0;
        [self requestData];
    }];
}

- (void)requestData {
    [CNVIPRequest vipsxhReceiveAwardRecordPageNo:_pageNo
                                        pageSize:20
                                            type:_curType == 0 ? VIPSxhAwardTypeZZZP : VIPSxhAwardTypeLJSF
                                             day:_preDays
                                         handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            //TODO: 没数据
            
        }
    }];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VIPRECCELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"VIPRECCELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kHexColor(0x1A1A1A);
        cell.textLabel.textColor = kHexColor(0xD3D3D3);
    }
    //TODO: --
    cell.textLabel.text = @"天然蜜蜡貔貅";
    cell.detailTextLabel.text = @"2020.05.02 13:30";
    return cell;
}





@end
