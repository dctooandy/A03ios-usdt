//
//  VIPCumulateIdCell.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCumulateIdCell.h"
#import "VIPCumulateIdButton.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"
#import "UIColor+Gradient.h"

@interface VIPCumulateIdCell ()
@property (weak, nonatomic) IBOutlet UIView *centerBGView;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet VIPCumulateIdButton *btnReceive;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgviewHeightCons;

@property (weak, nonatomic) IBOutlet UIImageView *giftImgv;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation VIPCumulateIdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    _btnExpand.backgroundColor = kHexColorAlpha(0x000000, 0.4);
    _btnExpand.layer.cornerRadius = 1;
    _btnExpand.layer.masksToBounds = YES;
    
    _centerBGView.backgroundColor = [UIColor gradientColorImageFromColors:@[kHexColor(0x514C47), kHexColor(0x7F7B6C)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(kScreenWidth-14*2, 70)];
}

- (void)setModel:(VIPIdentityModel *)model {
    _model = model;
    
    NSString *club;
    switch (model.clubLevel) {
        case 2: club = @"赌侠"; break;
        case 3: club = @"赌霸"; break;
        case 4: club = @"赌王"; break;
        case 5: club = @"赌圣"; break;
        case 6: club = @"赌神"; break;
        case 7: club = @"赌尊"; break;
        default:
            break;
    }
    
    [self.giftImgv sd_setImageWithURL:[NSURL getUrlWithString:model.prizeUrl] placeholderImage:[UIImage imageNamed:@"1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // 拿到图片改高度
//        CGFloat h = (kScreenWidth-32) * image.size.height / image.size.width;
//        self.imgviewHeightCons.constant = h + 70 + 15;
//        [self setNeedsLayout];
    }];
    
    self.btnReceive.enabled = model.residueCount?YES:NO;
    self.lblTitle.text = model.title;
    self.lblContent.text = [NSString stringWithFormat:@"领取条件: %ld次%@   价值: %@%@", model.condition, club, model.amount, model.currency];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapBtnReceive:(id)sender {
    if (self.receivedBlcok) {
        self.receivedBlcok();
    }
}


- (IBAction)didTapBtnExpand:(id)sender {
    if (self.expandBlcok) {
        self.expandBlcok(self, self.giftImgv);
    }
}

@end
