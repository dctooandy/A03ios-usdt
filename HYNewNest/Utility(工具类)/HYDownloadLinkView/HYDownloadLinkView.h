//
//  HYDownBFBView.h
//  HYGEntire
//
//  Created by zaky on 12/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYDownloadLinkView : UIView
@property (copy,nonatomic) void(^tapBlock)(void);
@property (strong,nonatomic) UITextView *lblDown;
@property (strong,nonatomic) NSString *url;

- (instancetype)initWithFrame:(CGRect)frame
                   normalText:(NSString *)norTxt
                  tapableText:(NSString *)tapTxt
                     tapColor:(UIColor *)color
                 hasUnderLine:(BOOL)hasUnderLine
                     urlValue:(nullable NSString *)url;

@end

NS_ASSUME_NONNULL_END
