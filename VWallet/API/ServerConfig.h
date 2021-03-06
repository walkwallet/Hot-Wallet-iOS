//
// ServerConfig.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerConfig : NSObject

+ (NSString *)ApiHost;

+ (NSString *)ExplorerHost;

+ (NSString *)RateHost;

@end

NS_ASSUME_NONNULL_END
