//
//  AppServer.m
//  Wallet
//
//  All rights reserved.
//

#import "AppServer.h"

@implementation AppServer

+ (AFHTTPSessionManager *)shareInstance {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer.timeoutInterval = 7;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", @"application/json", @"text/json", @"text/html",@"text/javascript",@"text/plain", nil];
    });
    return manager;
}

+ (void)Get:(NSString*) url params:(id)params success:(void (^)(NSDictionary *response))success fail:(void(^)(id info))fail {
    [AppServer requestMethod:@"get" url:url params:params result2Json:YES success:success fail:fail];
}

+ (void)Post:(NSString*) url params:(id)params success:(void (^)(NSDictionary *response))success fail:(void(^)(id info))fail {
    [AppServer requestMethod:@"post" url:url params:params result2Json:YES success:success fail:fail];
}

+ (void)requestMethod:(NSString *)method url:(NSString*) url params:(id)params result2Json:(BOOL)isResult2Json success:(void (^)(id response))success fail:(void(^)(id info))fail {
#if DEBUG
    NSLog(@"\nrequest Url：%@，\nparams：%@",url,params);
#endif
    if ([method isEqualToString: @"post"]) {
        [AppServer.shareInstance POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    !success ? : success(responseObject);
                } else {
                    success(responseObject);
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !fail ? : fail(error.userInfo);
            });
        }];
    } else {
        [AppServer.shareInstance GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
#if DEBUG
                NSLog(@"%@",responseObject);
#endif
                !success ? : success(responseObject);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !fail ? : fail(error.userInfo);
            });
        }];
    }
}


@end
