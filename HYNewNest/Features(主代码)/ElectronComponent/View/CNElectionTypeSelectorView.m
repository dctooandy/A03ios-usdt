//
//  CNRecordTypeSelectorView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNElectionTypeSelectorView.h"
#import "CNSelectBtn.h"
#import "CNOneStatusBtn.h"
#import "CNTwoStatusBtn.h"

@interface CNElectionTypeSelectorView ()
/// 游戏厅列表
@property (strong, nonatomic) IBOutletCollection(CNSelectBtn) NSArray *hallBtnArray;
@property (weak, nonatomic) IBOutlet CNSelectBtn *allHallBtn;
/// 游戏类型列表
@property (strong, nonatomic) IBOutletCollection(CNSelectBtn) NSArray *typeBtnArray;
@property (weak, nonatomic) IBOutlet CNSelectBtn *allTpyeBtn;
/// 赔付线列表
@property (strong, nonatomic) IBOutletCollection(CNSelectBtn) NSArray *lineBtnArray;
@property (weak, nonatomic) IBOutlet CNSelectBtn *allLineBtn;
@property (weak, nonatomic) IBOutlet CNOneStatusBtn *clearBtn;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;


@property (nonatomic, weak) id delegate;
/// 选中的游戏厅
@property (nonatomic, strong) NSMutableArray *selectHalls;
/// 选中的游戏类型
@property (nonatomic, strong) NSMutableArray *selectTypes;
/// 选中的赔付线
@property (nonatomic, strong) NSMutableArray *selectLines;
/// 回调
@property (nonatomic, copy) void(^callBack)(NSArray *halls, NSArray *types, NSArray *lines);
@end

@implementation CNElectionTypeSelectorView

+ (void)showSelectorWithDefaultHall:(NSArray *)halls defaultType:(NSArray *)types defaultLine:(NSArray *)lines callBack:(void (^)(NSArray * _Nonnull, NSArray * _Nonnull, NSArray * _Nonnull))callBack {
    
    CNElectionTypeSelectorView *alert = [[CNElectionTypeSelectorView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    // 按钮边框颜色
    alert.clearBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    alert.clearBtn.layer.borderWidth = 1;
    alert.submitBtn.enabled = YES;
    
    alert.callBack = callBack;
    alert.bottom.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [alert layoutIfNeeded];
    }];
    
    // 设置默认选择
    // 厅
    if (halls.count == 0 ||
        [halls containsObject:alert.allHallBtn.currentTitle] ||
        [halls containsObject:@"游戏厅"]) {
        [alert chosesAllHall];
    } else {
        for (UIButton *btn in alert.hallBtnArray) {
            if ([halls containsObject:btn.currentTitle]) {
                btn.selected = YES;
            }
        }
        [alert.selectHalls removeAllObjects];
        [alert.selectHalls addObjectsFromArray:halls];
    }
    
    // 类型
    if (types.count == 0 ||
        [types containsObject:alert.allTpyeBtn.currentTitle] ||
        [types containsObject:@"游戏类型"]) {
        [alert chosesAllType];
    } else {
        for (UIButton *btn in alert.typeBtnArray) {
            if ([types containsObject:btn.currentTitle]) {
                btn.selected = YES;
            }
        }
        [alert.selectTypes removeAllObjects];
        [alert.selectTypes addObjectsFromArray:types];
    }
    
    // 线路
    if (lines.count == 0 ||
        [lines containsObject:alert.allLineBtn.currentTitle] ||
        [lines containsObject:@"赔付线"]) {
        [alert chosesAllLine];
    } else {
        for (UIButton *btn in alert.lineBtnArray) {
            if ([lines containsObject:btn.currentTitle]) {
                btn.selected = YES;
            }
        }
        [alert.selectLines removeAllObjects];
        [alert.selectLines addObjectsFromArray:lines];
    }
}

#pragma mark - button Action

- (IBAction)hallAction:(UIButton *)sender {
    if ([sender isEqual:self.allHallBtn]) {
        [self chosesAllHall];
    } else {
        
        // 先删除全部
        self.allHallBtn.selected = NO;
        if ([self.selectHalls containsObject:self.allHallBtn.currentTitle]) {
            [self.selectHalls removeObject:self.allHallBtn.currentTitle];
        }
        
        // 添加或删除项
        sender.selected = !sender.selected;
        if (sender.selected) {
            if (![self.selectHalls containsObject:sender.currentTitle]) {
                [self.selectHalls addObject:sender.currentTitle];
            }
        } else {
            if ([self.selectHalls containsObject:sender.currentTitle]) {
                [self.selectHalls removeObject:sender.currentTitle];
            }
        }
    }
}

- (IBAction)typeAction:(UIButton *)sender {
    if ([sender isEqual:self.allTpyeBtn]) {
        [self chosesAllType];
    } else {
        
        // 先删除全部
        self.allTpyeBtn.selected = NO;
        if ([self.selectTypes containsObject:self.allTpyeBtn.currentTitle]) {
            [self.selectTypes removeObject:self.allTpyeBtn.currentTitle];
        }
        
        // 添加或删除项
        sender.selected = !sender.selected;
        if (sender.selected) {
            if (![self.selectTypes containsObject:sender.currentTitle]) {
                [self.selectTypes addObject:sender.currentTitle];
            }
        } else {
            if ([self.selectTypes containsObject:sender.currentTitle]) {
                [self.selectTypes removeObject:sender.currentTitle];
            }
        }
    }
}


- (IBAction)lineAction:(UIButton *)sender {
    if ([sender isEqual:self.allLineBtn]) {
        [self chosesAllLine];
    } else {
        
        // 先删除全部
        self.allLineBtn.selected = NO;
        if ([self.selectLines containsObject:self.allLineBtn.currentTitle]) {
            [self.selectLines removeObject:self.allLineBtn.currentTitle];
        }
        
        // 添加或删除项
        sender.selected = !sender.selected;
        if (sender.selected) {
            if (![self.selectLines containsObject:sender.currentTitle]) {
                [self.selectLines addObject:sender.currentTitle];
            }
        } else {
            if ([self.selectLines containsObject:sender.currentTitle]) {
                [self.selectLines removeObject:sender.currentTitle];
            }
        }
    }
}

// 选择全部厅
- (void)chosesAllHall {
    for (UIButton *btn in self.hallBtnArray) {
        btn.selected = NO;
    }
    self.allHallBtn.selected = YES;
    [self.selectHalls removeAllObjects];
    [self.selectHalls addObject:self.allHallBtn.currentTitle];
}

// 选择全部类型
- (void)chosesAllType {
    for (UIButton *btn in self.typeBtnArray) {
        btn.selected = NO;
    }
    self.allTpyeBtn.selected = YES;
    [self.selectTypes removeAllObjects];
    [self.selectTypes addObject:self.allTpyeBtn.currentTitle];
}

// 选择全部线
- (void)chosesAllLine {
    for (UIButton *btn in self.lineBtnArray) {
        btn.selected = NO;
    }
    self.allLineBtn.selected = YES;
    [self.selectLines removeAllObjects];
    [self.selectLines addObject:self.allLineBtn.currentTitle];
}

// 提交
- (IBAction)clearAction:(UIButton *)sender {
    [self chosesAllHall];
    [self chosesAllType];
    [self chosesAllLine];
}


// 提交
- (IBAction)submitAction:(UIButton *)sender {
    !_callBack ?: _callBack(self.selectHalls.copy, self.selectTypes.copy, self.selectLines.copy);
    [self removeFromSuperview];
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSMutableArray *)selectHalls {
    if (!_selectHalls) {
        _selectHalls = [NSMutableArray arrayWithCapacity:self.hallBtnArray.count];
    }
    return _selectHalls;
}

- (NSMutableArray *)selectTypes{
    if (!_selectTypes) {
        _selectTypes = [NSMutableArray arrayWithCapacity:self.typeBtnArray.count];
    }
    return _selectTypes;
}

- (NSMutableArray *)selectLines {
    if (!_selectLines) {
        _selectLines = [NSMutableArray arrayWithCapacity:self.lineBtnArray.count];
    }
    return _selectLines;
}
@end
