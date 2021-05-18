//
//  HYTapHanImageCodeView.m
//  HYNewNest
//
//  Created by zaky on 10/23/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYTapHanImageCodeView.h"
#import "CNLoginRequest.h"
#import "UIView+Badge.h"

@interface HYTapHanImageCodeView () <UIGestureRecognizerDelegate>
{
    NSUInteger _tapCounter;
}
@property (weak, nonatomic) IBOutlet UIImageView *captchaImgv;
@property (strong, nonatomic) CNImageCodeModel *codeModel;
@property (nonatomic, strong) NSMutableArray *coordinates;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (nonatomic, readwrite) NSString *ticket;
@end

@implementation HYTapHanImageCodeView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = AD(10);
    
    return self;
}

- (NSMutableArray *)coordinates {
    if (!_coordinates) {
        _coordinates = [NSMutableArray new];
    }
    return _coordinates;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - action

- (IBAction)didTapImgv:(UITapGestureRecognizer *)sender {
    
    CGPoint p = [sender locationInView:self.captchaImgv];
    MyLog(@"获取到坐标P: %@", NSStringFromCGPoint(p));
    NSDictionary *dict = @{@"x": @(round(p.x)), @"y": @(round(p.y))};
    [self.coordinates addObject:dict];
    [self.captchaImgv showRedPoint:p value:_tapCounter+1];
    
    _tapCounter ++;
    if (_tapCounter == 3) {
        [self verifyCoordinates];
    }
}

- (IBAction)didTapReloadBtn:(id)sender {
    [self getImageCodeForceRefresh:YES];
}


#pragma mark - request

- (void)getImageCodeForceRefresh:(BOOL)isForce {
    if (!isForce && self.codeModel) { //非强制刷新并且已有模型
        return;
    }
    
    _tapCounter = 0; // 清0
    [self.coordinates removeAllObjects];
    for (UIView *view in self.captchaImgv.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view performSelector:@selector(removeFromSuperview)];
        }
    }
    for (UIView *view in self.subviews) {
        if (view.tag == 999) {
            [view performSelector:@selector(removeFromSuperview)];
            break;
        }
    }
    
    [CNLoginRequest getHanImageCodeHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            self.codeModel = [CNImageCodeModel cn_parse:responseObj];
            UIImage *img = self.codeModel.decodeImage;
            [self.captchaImgv setImage:img];
            if (self.codeModel.specifyWord.count) {
                NSMutableString *str = @"请“依次”点击".mutableCopy;
                for (NSString *s in self.codeModel.specifyWord) {
                    [str appendFormat:@"【%@】",s];
                }
                self.lblText.text = str.copy;
                self.lblText.hidden = NO;
            } else {
                self.lblText.hidden = YES;
            }
        }
    }];
}

- (void)verifyCoordinates {
    NSString *str = [self arrayToJson:self.coordinates];
    NSString *baseStr = [str jk_base64EncodedString];
    MyLog(@"加密前:%@------加密后:%@",str, baseStr);
    [CNLoginRequest verifyHanImageCodeCaptcha:baseStr captchaId:self.codeModel.captchaId handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ( [responseObj[@"validateResult"] integerValue] == 1) {
                self.ticket = responseObj[@"ticket"];
                self.correct = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(validationDidSuccess)]) {
                    [self.delegate validationDidSuccess];
                }
            } else {
                self.correct = NO;
                [self getImageCodeForceRefresh:YES];
                [CNTOPHUB showError:@"请点击正确的汉字"];
            }
        }
    }];
}


#pragma mark - others

- (void)showSuccess {
    UIView *whiteView = [UIView new];
    whiteView.frame = CGRectMake(0, 0, 300, 47);
    whiteView.tag = 999;
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = AD(10);
    whiteView.layer.borderWidth = 1;
    whiteView.layer.borderColor = kHexColor(0x5ACFBD).CGColor;
    
    UILabel *lblSuc = [UILabel new];
    lblSuc.text = @"验证成功";
    lblSuc.textColor = kHexColor(0x5ACFBD);
    lblSuc.textAlignment = NSTextAlignmentCenter;
    lblSuc.font = [UIFont fontPFM17];
    lblSuc.frame = whiteView.bounds;
    [whiteView addSubview:lblSuc];
    
    [self addSubview:whiteView];
}

- (NSString *)imageCodeId {
    return self.codeModel.captchaId;
}

- (NSString*)arrayToJson:(NSArray*)array{

    NSError* parseError =nil;
    //options=0转换成不带格式的字符串
    //options=NSJSONWritingPrettyPrinted格式化输出

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&parseError];

    return[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}




@end
