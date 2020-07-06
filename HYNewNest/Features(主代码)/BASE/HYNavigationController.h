//
//  HYNavigationController.h
//  HYGEntire
//
//  Created by zaky on 11/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYNavigationController : UINavigationController

+ (HYNavigationController *)navigationControllerWithController:(Class)controller tabBarTitle:(NSString *)tabBarTitle normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

@end

NS_ASSUME_NONNULL_END
