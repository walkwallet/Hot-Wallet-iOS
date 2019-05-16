//
//  TokenMgr.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Token;

NS_ASSUME_NONNULL_BEGIN

@interface TokenMgr : NSObject

+ (NSArray<Token*>*) getTokenByWalletAddress:(NSString *)address;

+ (void)saveTokenByWalletAddress:(NSString *)address list:(NSArray*)list;

@end

NS_ASSUME_NONNULL_END
