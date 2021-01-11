//
//  TokenMgr.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VsysToken;

@interface TokenMgr : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) VsysToken *token;

@property (nonatomic, strong) NSArray <VsysToken *> *tokenList;

- (VsysToken *)getTokenByAddress:(NSString *)address tokenId:(NSString *)tokenId;

- (NSArray<VsysToken *> *)loadAddressWatchToken:(NSString *)address;

- (NSError *)saveToStorage:(NSString *)address list:(NSArray<VsysToken *> *)list;

- (NSArray<VsysToken *> *)getCertifiedTokenList;

- (NSError *)saveCertifiedTokenList:(NSArray<VsysToken *> *) list;

@end
