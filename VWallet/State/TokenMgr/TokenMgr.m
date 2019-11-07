//
//  TokenMgr.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenMgr.h"

static NSString *VKeyChainToken = @"WatchToken_%@";

static NSString *VKeyCertifiedTokenList = @"CertifiedTokenList";

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

- (NSArray<Token *> *)getCertifiedTokenList {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:VKeyCertifiedTokenList];
    NSArray<Token *> *certifiedTokenList = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    return certifiedTokenList;
}

- (NSError *)saveCertifiedTokenList:(NSArray<Token *> *) list {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:VKeyCertifiedTokenList];
    return nil;
}

@end
