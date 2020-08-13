//
//  VideoThumbnailManage.h
//  HyEntireGame
//
//  Created by bux on 2018/10/20.
//  Copyright © 2018 kunlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoThumbnailManage : NSObject

@property (strong,nonatomic) NSMutableDictionary *urlImgPairs; //!<缓存之前获取到的地址和图片配对

+(void)setThumbnailForImgView:(UIImageView *)imgView videoUrlStr:(NSString *)videoUrlStr placeHoldImg:(UIImage *)placeHoldImage;

@end



@interface ImgViewAndUrlItem : NSObject

@property (strong,nonatomic) UIImageView *imgView;
@property (strong,nonatomic) NSString *url; 

@end
