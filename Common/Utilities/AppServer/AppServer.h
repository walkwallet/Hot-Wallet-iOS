//
//  AppServer.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppServer : NSObject

+ (AFHTTPSessionManager *)shareInstance;

+ (void)Get:(NSString*) url params:(id)params success:(void (^)(NSDictionary *response))success fail:(void(^)(id info))fail;

+ (void)Post:(NSString*) url params:(id)params success:(void (^)(NSDictionary *response))success fail:(void(^)(id info))fail;

+ (void)requestMethod:(NSString *)method url:(NSString*) url params:(id)params result2Json:(BOOL)isResult2Json success:(void (^)(id response))success fail:(void(^)(id info))fail;

@end

NS_ASSUME_NONNULL_END
