//
//  BTTBaseAnimationPopView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

@implementation BTTBaseAnimationPopView

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}



@end
