//
//  TokenMgr.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface TokenMgr : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, copy) Token *token;
@property (nonatomic, copy) NSArray <Token *> *tokenList;

- (Token *)getTokenByAddress:(NSString *)address tokenId:(NSString *)tokenId;

- (NSArray<Token *> *)loadAddressWatchToken:(NSString *)address;

- (NSError *)saveToStorage:(NSString *)address list:(NSArray<Token *> *)list;

- (NSArray<Token *> *)getCertifiedTokenList;

- (NSError *)saveCertifiedTokenList:(NSArray<Token *> *) list;

@end
