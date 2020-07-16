//
//  CNBaseTF.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/16.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseTF.h"

@implementation CNBaseTF

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"l_form_delete"] forState:UIControlStateNormal];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
    @{NSForegroundColorAttributeName:kHexColorAlpha(0xFFFFFF, 0.3),
                 NSFontAttributeName:self.font
    }];
    self.attributedPlaceholder = attrString;
}
@end
