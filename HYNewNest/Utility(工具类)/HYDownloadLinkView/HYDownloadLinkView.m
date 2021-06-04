//
//  HYDownBFBView.m
//  HYGEntire
//
//  Created by zaky on 12/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "HYDownloadLinkView.h"
#import "NSAttributedString+Selectable.h"

/// 可点击的String View
@interface HYDownloadLinkView() <UITextViewDelegate>

@end

@implementation HYDownloadLinkView

- (instancetype)initWithFrame:(CGRect)frame normalText:(NSString *)norTxt tapableText:(NSString *)tapTxt tapColor:(UIColor *)color hasUnderLine:(BOOL)hasUnderLine urlValue:(nullable NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.url = url;
        
        UITextView *lblDown = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        lblDown.linkTextAttributes = @{};
        lblDown.backgroundColor = [UIColor clearColor];
        lblDown.attributedText = [NSAttributedString attributeText:norTxt selectableText:tapTxt selectableColor:color isUnderline:hasUnderLine URLStr:url?url:@""];
        lblDown.delegate = self;
        lblDown.editable = NO;
        lblDown.scrollEnabled = NO;
        [lblDown sizeThatFits:CGSizeMake(frame.size.width, 14)];
        self.lblDown = lblDown;
        [self addSubview:lblDown];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    //在这里是可以做一些判定什么的，用来确定对应的操作。
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"正在为您跳转.."];
        }];
        return YES;
    } else {
        if (self.tapBlock) {
            self.tapBlock();
        }
        return NO;
    }
}

@end
