//
//  CTZNModel.h
//  HYGEntire
//
//  Created by zaky on 7/18/20.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTZNModel : CNBaseModel
@property (nonatomic , copy) NSString              * img;
@property (nonatomic , copy) NSString              * pc_video;
@property (nonatomic , copy) NSString              * pc_img;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * video;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * content;
@end

NS_ASSUME_NONNULL_END
