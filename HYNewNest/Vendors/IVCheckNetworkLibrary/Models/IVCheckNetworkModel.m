//
//  IVCheckNetworkModel.m
//  IVCheckNetwork
//
//  Created by Key on 13/08/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVCheckNetworkModel.h"

@interface IVCheckNetworkModel ()
@property (nonatomic, strong, readwrite) NSMutableArray<IVCheckDetailModel *> *detailModels;
@end
@implementation IVCheckNetworkModel

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    _detailModels = [[NSMutableArray alloc] init];
    self.fullTitle = [NSString stringWithFormat:@"%@: %@",self.title,@"线路0"];
    for (NSInteger j = 0; j < self.urls.count ;j++) {
        NSString *urlStr = urls[j];
        IVCheckDetailModel *detailModel = [[IVCheckDetailModel alloc] init];
        detailModel.index = j;
        detailModel.url = urlStr;
        detailModel.title = [NSString stringWithFormat:@"线路%zi:",j + 1];
        detailModel.time = 0.0;
        detailModel.type = self.type;
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURL *currentUrl = [NSURL URLWithString:self.currentUrl];
        if ([url.host isEqualToString:currentUrl.host]) {
            self.fullTitle = [NSString stringWithFormat:@"%@: 线路%zi",self.title,j + 1];
        }
        [_detailModels addObject:detailModel];
    }
}

@end
