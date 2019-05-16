//
//  ApiServer.m
//  Wallet
//
//  All rights reserved.
//

#import "ApiServer.h"
#import "AppServer.h"
#import "ServiceAPI.h"
#import "ServerConfig.h"
#import "WalletMgr.h"
#import "Token.h"
#import "Contract.h"

#define VApi(path) [ServerConfig.ApiHost stringByAppendingString: path]

@implementation ApiServer

+ (void)allSlotsInfo: (void(^)(BOOL isSuc, NSArray <SlotInfo *> *infoArr))callback {
    [AppServer Get:VApi(ApiAllSlotsInfo) params:@{} success:^(id _Nonnull response) {
        if ([response isKindOfClass:NSArray.class]) {
            NSMutableArray *retArr = @[].mutableCopy;
            for (NSDictionary *dict in response) {
                if (dict[@"slotId"]) {
                    SlotInfo *item = [SlotInfo new];
                    item.slotId = dict[@"slotId"];
                    item.address = dict[@"address"];
                    item.mab = dict[@"mintingAverageBalance"];
                    [retArr addObject:item];
                }
            }
            callback(YES, retArr);
        }
    } fail:^(NSDictionary * _Nonnull info) {
        callback(NO, nil);

    }];
}

+ (void)addressBalanceDetail:(Account *)account callback: (void(^)(BOOL isSuc, Account *account))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiAddressBalanceDetail, account.originAccount.address])) params:@{} success:^(id _Nonnull response) {
        if ([response isKindOfClass:NSDictionary.class]) {
            account.totalBalance = [response[@"regular"] integerValue];
            account.availableBalance = [response[@"available"] integerValue];
            account.leasedIn = [response[@"effective"] integerValue] - account.availableBalance;
            account.leasedOut = account.totalBalance - account.availableBalance;
            callback(YES, account);
        } else {
            account.getedInfo = NO;
        }
    } fail:^(NSDictionary * _Nonnull info) {
        account.getedInfo = NO;
        callback(NO, nil);
    }];
}

+ (void)transactionList:(NSString *)address callback: (void(^)(BOOL isSuc, NSArray <Transaction *> *txArr))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiTransactionList, address])) params:@{} success:^(id _Nonnull response) {
        if ([response isKindOfClass:NSArray.class] && [response count] == 1 && [response[0] isKindOfClass:NSArray.class]) {
            NSMutableArray *retArr = @[].mutableCopy;
            NSMutableDictionary *cancelLeaseDict = @{}.mutableCopy;
            for (NSDictionary *dict in response[0]) {
                Transaction *t = [Transaction new];
                t.ownerAddress = address;
                VsysTransaction *tx;
                NSInteger txType = [dict[@"type"] integerValue];
                if (txType == VsysTxTypePayment) {
                    tx = VsysNewPaymentTransaction(dict[@"recipient"], [dict[@"amount"] integerValue]);
                    tx.timestamp = [dict[@"timestamp"] integerValue];
                    tx.fee = [dict[@"fee"] integerValue];
                    tx.txId = dict[@"id"];
                    tx.feeScale = [dict[@"feeScale"] integerValue];
                    tx.attachment = [dict[@"attachment"] dataUsingEncoding:NSUTF8StringEncoding];
                } else if (txType == VsysTxTypeLease) {
                    tx = VsysNewLeaseTransaction(dict[@"recipient"], [dict[@"amount"] integerValue]);
                    tx.timestamp = [dict[@"timestamp"] integerValue];
                    tx.fee = [dict[@"fee"] integerValue];
                    tx.txId = dict[@"id"];
                    tx.feeScale = [dict[@"feeScale"] integerValue];
                    if (cancelLeaseDict[dict[@"id"]] || [tx.recipient isEqualToString:address]) {
                        t.canCancel = NO;
                    } else {
                        t.canCancel = YES;
                    }
                } else if (txType == VsysTxTypeCancelLease) {
                    NSDictionary *lease = dict[@"lease"];
                    tx = VsysNewCancelLeaseTransaction(lease[@"id"]);
                    tx.amount = [lease[@"amount"] integerValue];
                    tx.timestamp = [dict[@"timestamp"] integerValue];
                    tx.fee = [dict[@"fee"] integerValue];
                    tx.feeScale = [dict[@"feeScale"] integerValue];
                    tx.recipient = lease[@"recipient"];
                    cancelLeaseDict[lease[@"id"]] = @(YES);
                } else if (txType == VsysTxTypeMining) {
                    tx = VsysNewMiningTransaction();
                    tx.amount = [dict[@"amount"] integerValue];
                    tx.recipient = dict[@"recipient"];
                    tx.timestamp = [dict[@"timestamp"] integerValue];
                    tx.txId = dict[@"id"];
                }
                if (!tx) {
                    continue;
                }
                if ([tx.recipient isEqualToString:address]) {
                    if ([dict[@"proofs"] count]) {
                        VsysAccount *sendAcc = VsysNewAccount(WalletMgr.shareInstance.network, dict[@"proofs"][0][@"publicKey"]);
                        t.senderAddress = sendAcc.address;
                    }
                } else {
                    t.senderAddress = address;
                }
                t.originTransaction = tx;
                [retArr addObject:t];
             
            }
            callback(YES, retArr);
        } else {
            callback(YES, nil);
        }
    } fail:^(NSDictionary * _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)broadcastPayment:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback {
    NSDictionary *dict = @{
        @"senderPublicKey": tx.ownerPublicKey ? : @"",
        @"amount": @(tx.originTransaction.amount),
        @"fee": @(tx.originTransaction.fee),
        @"feeScale": @(tx.originTransaction.feeScale),
        @"recipient": tx.originTransaction.recipient ? : @"",
        @"timestamp": @(tx.originTransaction.timestamp),
        @"attachment": [[NSString alloc] initWithData:VsysBase58Encode(tx.originTransaction.attachment) encoding:NSUTF8StringEncoding],
        @"signature": tx.signature ? : @""
    };
    [AppServer Post:VApi(ApiPayment) params:dict success:^(NSDictionary * _Nonnull response) {
#if DEBUG
        NSLog(@" - response = %@", response);
#endif
        callback(YES);
    } fail:^(id  _Nonnull info) {
#if DEBUG
        NSLog(@" - info = %@", info);
#endif
        callback(NO);
    }];
}

+ (void)broadcastLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback {
    NSDictionary *dict = @{
                           @"senderPublicKey": tx.ownerPublicKey ? : @"",
                           @"amount": @(tx.originTransaction.amount),
                           @"fee": @(tx.originTransaction.fee),
                           @"feeScale": @(tx.originTransaction.feeScale),
                           @"recipient": tx.originTransaction.recipient ? : @"",
                           @"timestamp": @(tx.originTransaction.timestamp),
                           @"signature": tx.signature ? : @""
                           };
    [AppServer Post:VApi(ApiLease) params:dict success:^(NSDictionary * _Nonnull response) {
        callback(YES);
    } fail:^(id  _Nonnull info) {
        callback(NO);
    }];
}

+ (void)broadcastCancelLease:(Transaction *)tx callback: (void(^)(BOOL isSuc))callback {
    NSDictionary *dict = @{
                           @"senderPublicKey": tx.ownerPublicKey ? : @"",
                           @"txId": tx.originTransaction.txId,
                           @"fee": @(tx.originTransaction.fee),
                           @"feeScale": @(tx.originTransaction.feeScale),
                           @"timestamp": @(tx.originTransaction.timestamp),
                           @"signature": tx.signature ? : @""
                           };
    [AppServer Post:VApi(ApiCancelLease) params:dict success:^(NSDictionary * _Nonnull response) {
        callback(YES);
    } fail:^(id  _Nonnull info) {
        callback(NO);
    }];
}

+ (void)getTokenById:(NSString *)tokenId callback:(void (^)(BOOL isSec, Token *token))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiGetTokenInfo, tokenId])) params:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response isKindOfClass:NSDictionary.class]) {
            Token *token = [Token new];
            NSLog(@"---> jooyyy: %@", VsysBase58Decode(response[@"description"]));
            token.tokenId = response[@"tokenId"];
            token.contractId = response[@"contractId"];
            token.max = [response[@"max"] doubleValue];
            token.issuer = response[@"total"];
            token.unity = [response[@"unity"] integerValue];
            callback(YES, token);
        }else {
            callback(NO, nil);
        }
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)getContractById:(NSString *)contractId callback:(void (^)(BOOL isSus, Contract *contract))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiGetContractInfo, contractId])) params:@{} success:^(NSDictionary *response) {
        if ([response isKindOfClass:NSDictionary.class]) {
            NSLog(@"--> jooyyy %@", response);
            Contract *contract = [Contract new];
            contract.contractId = [response[@"contractId"] stringValue];
            contract.transactionId = [response[@"transactionId"] stringValue];
            contract.height = [response[@"height"] integerValue];
            callback(YES, contract);
        }else {
            callback(NO, nil);
        }
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)getAccountTokenBalance:(NSString *)tokenId address:(NSString *)address callback:(void (^)(BOOL isSus, VsysContract * contract))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiGetAddressTokenBalance, address, tokenId])) params:@{} success:^(NSDictionary *response) {
        callback(YES, nil);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}
@end
