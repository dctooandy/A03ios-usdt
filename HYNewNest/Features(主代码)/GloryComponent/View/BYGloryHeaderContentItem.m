//
//  BYGloryHeaderContentView.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryHeaderContentItem.h"

@interface BYGloryHeaderContentItem ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *jumpHtmlButton;
@property (nonatomic, strong) GloryBannerModel *model;
@end

@implementation BYGloryHeaderContentItem
- (void)setupGloryBanner:(GloryBannerModel *)model {
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.imageView.image = [UIImage imageNamed:model.imageName];
    self.jumpHtmlButton.hidden = model.hideButton;
    self.model = model;
    
}

- (UIView *)listView {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = true;
    return self;
}

- (IBAction)jumpHmltClicked:(id)sender {
    [NNPageRouter jump2HTMLWithStrURL:self.model.webURL title:self.model.title needPubSite:false];
}

@end
