//
//  KYMSelectChannelVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMSelectChannelVC.h"
#import "KYMSelectChannelCell.h"

@interface KYMSelectChannelVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation KYMSelectChannelVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.frame;
    maskLayer.path = path.CGPath;
    self.contentView.layer.mask = maskLayer;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.closeBtn setTitle:@"" forState:UIControlStateNormal];
    self.contentView.layer.cornerRadius = 20;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"KYMSelectChannelCell" bundle:nil] forCellReuseIdentifier:@"KYMSelectChannelCell"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    KYMSelectChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KYMSelectChannelCell"];
    if (indexPath.row == 0) {
        cell.titleLable.text = @"急速转卡";
        cell.iconImageView.image = [UIImage imageNamed:@"mwd_fast"];
        cell.descLable.hidden = NO;
        cell.recommendIcon.hidden = NO;
    } else {
        cell.titleLable.text = @"提现";
        cell.iconImageView.image = [UIImage imageNamed:@"mwd_normal"];
        cell.descLable.hidden = YES;
        cell.recommendIcon.hidden = YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedChannelCallback(indexPath.row);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
