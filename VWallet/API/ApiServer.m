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

+ (void)transactionList:(NSString *)address offset:(NSInteger)offset limit:(NSInteger)limit type:(NSInteger)type callback: (void(^)(BOOL isSuc, NSArray <Transaction *> *txArr))callback {
    NSString *api = @"";
    if (type == 0) {
        api = [NSString stringWithFormat:ApiTransactionList, address, limit, offset];
    }else {
        api = [NSString stringWithFormat:@"%@&txType=%ld", [NSString stringWithFormat:ApiTransactionList, address, limit, offset], type];
    }
    [AppServer Get:VApi((api)) params:@{} success:^(id _Nonnull response) {
        if ([response[@"transactions"] isKindOfClass:NSArray.class]) {
            NSMutableArray *retArr = @[].mutableCopy;
            NSMutableDictionary *cancelLeaseDict = @{}.mutableCopy;
            for (NSDictionary *dict in response[@"transactions"]) {
                Transaction *t = [Transaction new];
                t.ownerAddress = address;
                VsysTransaction *tx;
                int txType = [dict[@"type"] intValue];
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
                } else if (txType == VsysTxTypeContractRegister) {
                    tx = VsysNewRegisterTransaction(@"", dict[@"initData"], dict[@"description"]);
                    tx.txId = dict[@"id"];
                    tx.timestamp = [dict[@"timestamp"] integerValue];
                    tx.description = dict[@"description"];
                } else if (txType == VsysTxTypeContractExecute) {
                    tx = VsysNewExecuteTransaction(dict[@"contractId"], dict[@"functionData"], [dict[@"functionIndex"] intValue], dict[@"attachment"]);
                    tx.txId = dict[@"id"];
                    tx.timestamp = [dict[@"timestamp"] integerValue];
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
                if ([dict[@"status"] isKindOfClass:NSString.class]) {
                    t.status = dict[@"status"];
                }
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

+ (void)getTokenInfo:(NSString *)tokenId callback:(void (^)(BOOL isSuc, Token *token))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiGetTokenInfo, tokenId])) params:@{} success:^(NSDictionary * _Nonnull response) {
        Token *token = [Token new];
        token.tokenId = response[@"tokenId"];
        token.contractId = response[@"contractId"];
        token.max = [response[@"max"] longLongValue];
        token.total = [response[@"total"] longLongValue];
        token.unity = [response[@"unity"] longLongValue];
        token.desc = VsysDecodeDescription(response[@"description"]);
        callback(YES, token);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)getContractInfo:(NSString *)contractId callback:(void (^)(BOOL isSuc, Contract *contract))callback {
    [AppServer Get:VApi(([NSString stringWithFormat: ApiGetContractInfo, contractId])) params:@{} success:^(NSDictionary * _Nonnull response) {
        Contract *contract = [Contract new];
        contract.contractId = response[@"contractId"];
        contract.transactionId = response[@"transactionId"];
        contract.height = [response[@"height"] longLongValue];
        if ([response[@"info"] isKindOfClass:NSArray.class]) {
            NSMutableArray *list = @[].mutableCopy;
            for (NSDictionary *dict in response[@"info"]) {
                ContractInfoItem *one = [[ContractInfoItem alloc] init];
                one.data = dict[@"data"];
                one.name = dict[@"name"];
                one.type = dict[@"type"];
                [list addObject:one];
            }
            contract.info = list.copy;
        }
        callback(YES, contract);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)getContractContent:(NSString *)contractId callback:(void (^)(BOOL isSus, ContractContent *contractContent))callback {
    [AppServer Get:VApi(([NSString stringWithFormat:ApiGetContractContent, contractId])) params:@{} success:^(NSDictionary * _Nonnull response) {
        ContractContent *content = [ContractContent new];
        content.transactionId = response[@"transactionId"];
        content.languageCode = response[@"languageCode"];
        content.languageVersion = [response[@"languageVersion"] intValue];
        content.height = [response[@"height"] longLongValue];
        if ([response[@"textual"] isKindOfClass:NSDictionary.class]) {
            NSDictionary *textual = response[@"textual"];
            content.textual = [ContractContentTextual new];
            content.textual.descriptors = textual[@"descriptors"];
            content.textual.triggers = textual[@"triggers"];
            content.textual.stateVariables = textual[@"stateVariables"];
        }else {
            callback(NO, nil);
            return;
        }
        callback(YES, content);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)getAddressTokenBalance:(NSString *)address tokenId:(NSString *)tokenId callback:(void (^)(BOOL isSuc, Token *token))callback {
    [AppServer Get:VApi(([NSString stringWithFormat: ApiGetAddressTokenBalance, address, tokenId])) params:@{} success:^(NSDictionary * _Nonnull response) {
        Token *token = [Token new];
        token.tokenId = response[@"tokenId"];
        token.balance = [response[@"balance"] longLongValue];
        token.unity = [response[@"unity"] intValue];
        callback(YES, token);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)broadcastContractRegister:(Transaction *)tx  callback:(void (^)(BOOL isSuc, Token *token))callback {
    NSDictionary *dict = @{
                           @"senderPublicKey": tx.ownerPublicKey ? : @"",
                           @"contract": VsysBase58EncodeToString(tx.originTransaction.contract),
                           @"initData": VsysBase58EncodeToString(tx.originTransaction.data),
                           @"description": tx.originTransaction.description,
                           @"fee": @(tx.originTransaction.fee),
                           @"feeScale": @(tx.originTransaction.feeScale),
                           @"timestamp": @(tx.originTransaction.timestamp),
                           @"signature": tx.signature ? : @""
                           };
    [AppServer Post:VApi(ApiPostContractRegister) params:dict success:^(NSDictionary * _Nonnull response) {
        Token *token = [Token new];
        token.contractId = response[@"contractId"] ? : @"";
        token.tokenId = VsysContractId2TokenId(token.contractId, 0);
        VsysContract *c = [VsysContract new];
        [c decodeRegister:tx.originTransaction.data];
        token.max = c.max;
        token.unity = c.unity;
        token.desc = c.tokenDescription;
        token.descContract = response[@"description"];
        token.maker = tx.senderAddress;
        token.issuer = tx.senderAddress;
        if ([response[@"contract"] isKindOfClass:NSDictionary.class]) {
            NSDictionary *cDic = response[@"contract"];
            if ([cDic[@"textual"] isKindOfClass:NSDictionary.class]) {
                NSDictionary *tDic = cDic[@"textual"];
                token.textualDescriptor = tDic[@"descriptors"] ? : @"";
            }
        }
        callback(YES, token);
    } fail:^(id  _Nonnull info) {
        callback(NO, nil);
    }];
}

+ (void)broadcastContractExecute:(Transaction *)tx callback:(void (^)(BOOL))callback {
    NSDictionary *dict = @{
                           @"senderPublicKey": tx.ownerPublicKey ? : @"",
                           @"contractId": tx.originTransaction.contractId,
                           @"functionIndex": @(tx.originTransaction.funcIdx),
                           @"functionData": VsysBase58EncodeToString(tx.originTransaction.data),
                           @"attachment": VsysBase58EncodeToString(tx.originTransaction.attachment),
                           @"fee": @(tx.originTransaction.fee),
                           @"feeScale": @(tx.originTransaction.feeScale),
                           @"timestamp": @(tx.originTransaction.timestamp),
                           @"signature": tx.signature ? : @""
                           };
    [AppServer Post:VApi(ApiPostContractExecute) params:dict success:^(NSDictionary * _Nonnull response) {
        callback(YES);
    } fail:^(id  _Nonnull info) {
        callback(NO);
    }];
}

+ (void)getTokenDetailFromExplorer:(NSString *)tokenId callback:(void (^)(BOOL, Token *))callback {
    [AppServer Post:[NSString stringWithFormat:@"%@%@", ServerConfig.ExplorerHost, ApiPostExplorerTokenDetail]
             params:@{
                      @"TokenId": tokenId,
                      }
            success:^(NSDictionary * _Nonnull response) {
                if ([response[@"data"] isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dict = response[@"data"];
                    Token *token = [Token new];
                    token.tokenId = dict[@"Id"];
                    token.icon = dict[@"IconUrl"];
                    token.name = dict[@"Name"];
                    callback(YES, token);
                }else {
                    callback(NO, nil);
                }
            } fail:^(id  _Nonnull info) {
                NSLog(@"--->%@", info);
                callback(NO, nil);
            }];
}

@end
