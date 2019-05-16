//
//  TokenMgr.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenMgr.h"
#import "Token.h"
#import "AppState.h"

#define VDefaults [NSUserDefaults standardUserDefaults]

static NSString *WalletTokenListKey = @"TokenList_%@";

@implementation TokenMgr

+ (NSArray<Token*> *)getTokenByWalletAddress:(NSString *)address {
    return [VDefaults arrayForKey:[NSString stringWithFormat:WalletTokenListKey, address]];
}

+ (void)saveTokenByWalletAddress:(NSString *)address list:(NSArray *)list {
    return [VDefaults setObject:list forKey:[NSString stringWithFormat:WalletTokenListKey, address]];
}

@end
