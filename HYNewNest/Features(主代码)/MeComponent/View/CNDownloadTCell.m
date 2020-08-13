//
//  CNDownloadTCell.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNDownloadTCell.h"

@implementation CNDownloadTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

// 下载APP
- (IBAction)doloadApp:(id)sender {
    !_downloadAction ?: _downloadAction();
}

@end
