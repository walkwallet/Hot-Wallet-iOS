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
#import "Contract.h"
#import "VsysToken.h"
#import "LeaseNode.h"

@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface ApiServer : NSObject

+ (void)allSlotsInfo: (void(^)(BOOL isSuc, NSArray <SlotInfo *> *infoArr))callback;

+ (void)addressBalanceDetail:(Account *)account callback: (void(^)(BOOL isSuc, Account *account))callback;

+ (void)transactionList:(NSString *)address offset:(NSInteger)offset limit:(NSInteger)limit type:(NSInteger)type callback: (void(^)(BOOL isSuc, NSArray <Transaction *> *txArr))callback;

+ (void)broadcastPayment:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)broadcastLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)broadcastCancelLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback;

+ (void)getTokenInfo:(NSString *)tokenId callback: (void(^)(BOOL isSuc, VsysToken *token))callback;

+ (void)getContractInfo:(NSString *)contractId callback: (void(^)(BOOL isSuc, Contract *contract))callback;

+ (void)getContractContent:(NSString *)contractId callback: (void(^)(BOOL isSuc, ContractContent *contractContent))callback;

+ (void)getAddressTokenBalance:(NSString *)address tokenId:(NSString *)tokenId callback:(void(^)(BOOL isSuc, VsysToken *token))callback;

+ (void)getCertifiedTokenInfo:(NSString *)tokenId callback:(void(^)(BOOL isSuc, VsysToken *token))callback;

+ (void)broadcastContractRegister:(Transaction *)tx callback:(void(^)(BOOL isSuc, VsysToken *token))callback;

+ (void)broadcastContractExecute:(Transaction *)tx callback:(void(^)(BOOL isSuc))callback;

+ (void)getTokenDetailFromExplorer:(NSString *)tokenId callback:(void(^)(BOOL isSuc, VsysToken *tokenDetail))callback;

+ (void)getCertifiedTokenList:(NSInteger)page callback: (void(^)(BOOL isSuc, NSArray<VsysToken *> *tokenArr))callback;

+ (void)getLeaseNodeList:(void (^)(BOOL isSuc, NSArray<LeaseNode *> *nodeList))callback;

+ (void)getContractData:(NSString *)contractId dbKey:(NSString *)dbKey callback:(void (^)(BOOL isSuc, ContractData *contractData))callback;

@end

NS_ASSUME_NONNULL_END
