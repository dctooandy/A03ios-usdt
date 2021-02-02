//
//  CNGameBtnsStackView.h
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GameBtnsStackViewDelegate <NSObject>

- (void)didTapGameBtnsIndex:(NSUInteger)index;

@end

@interface CNGameBtnsStackView : CNBaseXibView

// 添加outlet可以在控制器中拖线
@property (nonatomic, weak) IBOutlet id <GameBtnsStackViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
