//
//  A03ActivityManager.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "A03ActivityManager.h"
#import "CNHomeRequest.h"

@interface A03ActivityManager()
@property(nonatomic,strong)A03PopViewModel * popModel;
@end
@implementation A03ActivityManager
static A03ActivityManager * sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedSingleton = [[A03ActivityManager alloc] init];
        
    }
}
+ (A03ActivityManager *)sharedInstance {
    return sharedSingleton;
}
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock {
    
    WEAKSELF_DEFINE
    [CNHomeRequest checkPopviewHandler:^(id responseObj, NSString *errorMsg) {
        A03PopViewModel *subModel = [A03PopViewModel cn_parse:responseObj];
        if (subModel)
        {
            self->_popModel = subModel;
            int isShowType =[weakSelf.popModel.isShow intValue];
            switch (isShowType) {
//                    1. 预热时间内
//                    2. 活动时间内
//                    3. 不在预热也不在活动, 但有配置 (月工资弹窗)
//                    4. 今天不用再弹弹窗 (什么弹窗都不出现了)
                case 0://没配置任何东西
                    completionBlock(nil,nil);
                    break;
                case 1://预热彈窗
                    completionBlock(weakSelf.popModel,nil);
                    break;
                case 2://活动彈窗
                    completionBlock(nil,nil);
                    break;
                case 3://不在预热也不在活动, 但有配置
                    completionBlock(nil,nil);
                    break;
                case 4://今天不用再弹弹窗 (什么弹窗都不出现了)
                    completionBlock(nil,nil);
                    break;
                default:
                    break;
            }
        }
        
    }];
  
//        [IVNetwork requestPostWithUrl:BTTCheckPopView paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//
//            IVJResponseObject *result = response;
//            if ([result.head.errCode isEqualToString:@"0000"]) {
//                //            0723 isshow
//                //            1. 预热时间内
//                //            2. 活动时间内
//                //            3. 不在预热也不在活动, 但有配置 (月工资弹窗)
//                //            4. 今天不用再弹弹窗 (什么弹窗都不出现了)
//                self.popModel = [BTTPopViewModel yy_modelWithJSON:result.body];
//                if (self.popModel.isShow)
//                {
//                    int isShowType =[self.popModel.isShow intValue];
//                    //测试
//                    //                isShowType = 2;
//                    switch (isShowType) {
//                        case 0://没配置任何东西 (月工资弹窗)
//                            [weakSelf directToShowYenFenHongPopView];
//                            break;
//                        case 1://预热彈窗
//                            [weakSelf directToShowDefaultPopView];
//                            break;
//                        case 2://活动彈窗
//                            [weakSelf loadSevenXiData];// 七夕
//                            break;
//                        case 3://不在预热也不在活动, 但有配置(月工资弹窗)
//                            [weakSelf directToShowYenFenHongPopView];
//                        case 4://今天不用再弹弹窗 (什么弹窗都不出现了)
//                            break;
//                        default:
//                            break;
//                    }
//                    if (completionBlock)
//                    {
//                        NSString * isShowString = [NSString stringWithFormat:@"%d",isShowType];
//                        completionBlock(isShowString,[error description]);
//                    }
//
//                } else {
//                    if (completionBlock)
//                    {
//                        completionBlock(nil,[error description]);
//                    }
//                }
//
//                //            if (self.popModel.isShow)//0 不弹窗,1五重礼,2月分红
//                //            {
//                //                if (self.popModel.image){
//                //                    weakSelf.imageUrlString = self.popModel.image;
//                //                }
//                //                if (self.popModel.link){
//                //                    weakSelf.linkString = self.popModel.link;
//                //                }
//                //                int isShowType = [self.popModel.isShow intValue];
//                //测试
//                //                 isShowType = 1;
//                //                switch (isShowType) {
//                //                    case 0://不弹窗
//                //                        break;
//                //                    case 1://一般彈窗
//                //                        [weakSelf directToShowDefaultPopView];
//                //                        break;
//                //                    case 2://月分红
//                //                        [weakSelf directToShowYenFenHongPopView];
//                //                        break;
//                //                    default:
//                //                        break;
//                //                }
//                //                if (completionBlock)
//                //                {
//                //                    NSString * isShowString = [NSString stringWithFormat:@"%d",isShowType];
//                //                    completionBlock(isShowString,[error description]);
//                //                }
//
//                //            } else {
//                //                if (completionBlock)
//                //                {
//                //                    completionBlock(nil,[error description]);
//                //                }
//                //            }
//            }else{
//                [MBProgressHUD showError:result.head.errMsg toView:nil];
//                if (completionBlock)
//                {
//                    completionBlock(nil,result.head.errMsg);
//                }
//            }
//        }];
}
@end
