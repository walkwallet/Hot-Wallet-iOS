//
//  ApiServer.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlotInfo.h"
#import "Account.h"
#import "Transaction.h"
@class Token;
@class Contract;

@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface ApiServer : NSObject

+ (void)allSlotsInfo: (void(^)(BOOL isSuc, NSArray <SlotInfo *> *infoArr))callback;

+ (void)addressBalanceDetail:(Account *)account callback: (void(^)(BOOL isSuc, Account *account))callback;

+ (void)transactionList:(NSString *)address callback: (void(^)(BOOL isSuc, NSArray <Transaction *> *txArr))callback;

+ (void)broadcastPayment:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)broadcastLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)broadcastCancelLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)getContractById:(NSString *)contractId callback:(void(^)(BOOL isSuc, Contract *contract))callback;

+ (void)getTokenById:(NSString *)tokenId callback:(void(^)(BOOL isSuc, Token *token))callback;

+ (void)getAccountTokenBalance:(NSString *)tokenId address:(NSString *)address callback:(void(^)(BOOL isSuc, Contract *contract))callback;;


@end

NS_ASSUME_NONNULL_END
