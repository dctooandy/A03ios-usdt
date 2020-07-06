//
//  UIViewController+Extension.h
//  UtilityToolComponentOC
//
//  Created by carey on 2019/4/27.
//


@interface UIViewController (Extension)

/*
 *  隐藏导航栏  默认值:false
 */
@property (assign, nonatomic) BOOL hideNavgation;

/*
 *  设置页面背景色  不传则默为白色
 */
@property (strong, nonatomic) UIColor *bgColor;

/*
*   导航栏半透明 如果半透明就会往上缩进44
*/
@property (assign, nonatomic) BOOL makeTranslucent;



+ (UIViewController *)getCurrentViewController;
@end


