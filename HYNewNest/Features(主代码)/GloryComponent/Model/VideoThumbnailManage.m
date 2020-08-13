//
//  VideoThumbnailManage.m
//  HyEntireGame
//
//  Created by bux on 2018/10/20.
//  Copyright © 2018 kunlun. All rights reserved.
//

#import "VideoThumbnailManage.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoThumbnailManage()

@property (strong,nonatomic) NSMutableArray *imgViewUrlArray; //!<imgview 和 它要的url的视频帧 ，由于imgview存在于cell 所以它对应的url是会变的

@end

@implementation VideoThumbnailManage

static VideoThumbnailManage *sharedInstance = nil;
+(instancetype)sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[VideoThumbnailManage alloc] init];
        }
    }
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlImgPairs = [NSMutableDictionary dictionary];
        self.imgViewUrlArray = [NSMutableArray array];
    }
    return self;
}

+ (void)setThumbnailForImgView:(UIImageView *)imgView videoUrlStr:(NSString *)videoUrlStr placeHoldImg:(UIImage *)placeHoldImage{
    
    if (videoUrlStr==nil) {
        imgView.image = placeHoldImage;
        return;
    }
    
    if ([[VideoThumbnailManage sharedInstance].urlImgPairs objectForKey:videoUrlStr]) {
        imgView.image = [[VideoThumbnailManage sharedInstance].urlImgPairs objectForKey:videoUrlStr];
        return;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ImgViewAndUrlItem *item in [VideoThumbnailManage sharedInstance].imgViewUrlArray) {
        if (item.imgView==imgView) {
            [tmpArray addObject:item];
        }
    }
    [[VideoThumbnailManage sharedInstance].imgViewUrlArray removeObjectsInArray:tmpArray];
    ImgViewAndUrlItem *item = [[ImgViewAndUrlItem alloc]init];
    item.imgView = imgView;
    item.url = videoUrlStr;
    [[VideoThumbnailManage sharedInstance].imgViewUrlArray addObject:item];
    
    __block NSString *blockVideoURLStr = videoUrlStr;
    __block UIImageView *blockImgView = imgView;
    blockVideoURLStr = [blockVideoURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:blockVideoURLStr] options:nil];
        if (asset==nil) {
            MyLog(@"--zq-- AVURLAsset init faliled bacause of bad url");
            return ;
        }
        AVAssetImageGenerator *assetIG =
        [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetIG.appliesPreferredTrackTransform = YES;
        assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = 20.0;
        NSError *igError = nil;
        //* CMTimeMake(a,b) a当前第几帧, b每秒钟多少帧.当前播放时间a/b * CMTimeMakeWithSeconds(a,b) a当前时间,b每秒钟多少帧.
        thumbnailImageRef = [assetIG copyCGImageAtTime:CMTimeMakeWithSeconds(thumbnailImageTime, 30) actualTime:NULL error:&igError];
        
        if (!thumbnailImageRef)
            MyLog(@"thumbnailImageGenerationError %@", igError );
        
        UIImage *image = thumbnailImageRef
        ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
        : nil;
        
        if (image) {
            [VideoThumbnailManage sharedInstance].urlImgPairs[videoUrlStr] = image;
            [self updateTheRightImgView:blockImgView image:image url:videoUrlStr];
        }
    });
    
}
+(void)updateTheRightImgView:(UIImageView *)imgView image:(UIImage*)image url:(NSString *)url{
    __block ImgViewAndUrlItem *blockitem = nil;
    for (ImgViewAndUrlItem *item in [VideoThumbnailManage sharedInstance].imgViewUrlArray) {
        if (item.imgView == imgView) {
            if ([item.url isEqualToString:url]) {
                blockitem = item;
            }
        }
    }
    if (blockitem==nil) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        blockitem.imgView.image = image;
    });
}
@end




@implementation ImgViewAndUrlItem

@end
