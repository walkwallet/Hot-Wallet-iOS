//
//  TokenMgr.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenMgr.h"
#import "VsysToken.h"

static NSString *VKeyChainToken = @"WatchingToken_%@";

static NSString *VKeyCertifiedTokenList = @"CertifiedToken";

static TokenMgr *VTokenMgr = nil;

@implementation TokenMgr

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VTokenMgr = [[TokenMgr alloc] init];
    });
    return VTokenMgr;
}

- (NSArray<VsysToken *> *)loadAddressWatchToken:(NSString *)address {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:VKeyChainToken, address]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSError *)saveToStorage:(NSString *)address list:(NSArray<VsysToken *> *)list {
    self.tokenList = list;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:VKeyChainToken, address]];
    return nil;
}

- (VsysToken *)getTokenByAddress:(NSString *)address tokenId:(NSString *)tokenId {
    for (VsysToken *one in self.tokenList) {
        if ([one.tokenId isEqualToString:tokenId]) {
            return one;
        }
    }
    return nil;
}

- (NSArray<VsysToken *> *)getCertifiedTokenList {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:VKeyCertifiedTokenList];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSError *)saveCertifiedTokenList:(NSArray<VsysToken *> *) list {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:VKeyCertifiedTokenList];
    return nil;
}

@end
