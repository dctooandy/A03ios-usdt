//
//  BYGloryHeaderContentView.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryHeaderContentView.h"

@interface BYGloryHeaderContentView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BYGloryHeaderContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)listView {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = true;
    return self;
}

@end
