//
//  CNMatchPayRequest.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/19/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMatchPayRequest.h"
#import "CNEncrypt.h"

@implementation CNMatchPayRequest
+ (void)Post:(NSString *)url para:(NSDictionary *)para finish:(HandlerBlock)finish {
    [self POST:url parameters:para completionHandler:finish];
}

+ (void)queryFastPayOpenFinish:(HandlerBlock)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"1"; // 存款
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/checkChannel" para:dic finish:^(id responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [((NSDictionary *)responseObj) objectForKey:@"data"];
            if (data) {
                !finish ?: finish(data, nil);
                return;
            }
        }
        !finish ?: finish(responseObj, errorMsg);
    }];
}

+ (void)createDepisit:(NSString *)amount realName:(NSString *)realName finish:(HandlerBlock)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"amount"] = amount;
    dic[@"depositor"] = [CNEncrypt encryptString:realName];
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/MMPayment" para:dic finish:finish];
}

+ (void)commitDepisit:(NSString *)billId receiptImg:(NSString *)imgName transactionImg:(NSArray *)imgNames finish:(HandlerBlock)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"transactionId"] = billId;
    dic[@"opType"] = @"1"; //确认存款
    dic[@"receiptImg"] = imgName;
    dic[@"transactionImg"] = [imgNames componentsJoinedByString:@";"];
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/depositOperateV2" para:dic finish:finish];
}

+ (void)cancelDepisit:(NSString *)billId finish:(HandlerBlock)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"transactionId"] = billId;
    dic[@"opType"] = @"2"; //取消存款
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/depositOperate" para:dic finish:finish];
}

+ (void)queryDepisit:(NSString *)billId finish:(HandlerBlock)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"transactionId"] = billId;
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/depositDetail" para:dic finish:finish];
}

+ (void)uploadReceiptImages:(NSArray *)receiptImages recordImages:(NSArray *)recordImages billId:(NSString *)billId finish:(HandlerBlock)finish {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"transactionId"] = billId;
        [[IVHttpManager shareManager] uploadFileWithUrl:@"deposit/uploadImgV3" parameters:dic callBack:^(id  _Nullable response, NSError * _Nullable error) {
            if ([response isKindOfClass:[IVJResponseObject class]]) {
                IVJResponseObject *obj = (IVJResponseObject *)response;
                if ([obj.head.errCode isEqualToString:@"0000"]) {
                    !finish ?: finish(obj.body, nil);
                } else {
                    !finish ?: finish(obj.body, obj.head.errMsg);
                }
            } else if (error) {
                !finish ?: finish(nil, error.localizedDescription);
            }
        } constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *img in receiptImages) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.01) name:@"receiptImg" fileName:@"receiptImg.jpg" mimeType:@"image/jpeg"];
            }
            for (UIImage *img in recordImages) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.01) name:@"transactionImg" fileName:@"transactionImg.jpg" mimeType:@"image/jpeg"];
            }
        }];
    });
}
@end
