//
//  BYGloryVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/15.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryVC.h"
#import "BYGloryHeaderTableViewCell.h"

@interface BYGloryVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *gloryTableView;

@end

@implementation BYGloryVC

static NSString *const kBYGloryHeaderCell = @"BYGloryHeaderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.gloryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYGloryHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:kBYGloryHeaderCell];
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
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYGloryHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBYGloryHeaderCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  800;
}


@end
