//
//  TokenMgr.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenMgr.h"
#import <SAMKeychain/SAMKeychain.h>

static NSString *VKeyChainToken = @"WatchToken_%@";

static TokenMgr *VTokenMgr = nil;

@implementation TokenMgr

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VTokenMgr = [[TokenMgr alloc] init];
    });
    return VTokenMgr;
}

- (NSArray<Token *> *)loadAddressWatchToken:(NSString *)address {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:VKeyChainToken, address]];
    NSArray<Token *> *watchTokenList = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    return watchTokenList;
}

- (NSError *)saveToStorage:(NSString *)address list:(NSArray<Token *> *)list {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:VKeyChainToken, address]];
    return nil;
}

- (Token *)getTokenByAddress:(NSString *)address tokenId:(NSString *)tokenId {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:VKeyChainToken, address]];
    NSArray<Token *> *watchTokenList = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    for (Token *one in watchTokenList) {
        if ([one.tokenId isEqualToString:tokenId]) {
            return one;
        }
    }
    return nil;
}

@end
