//
//  Transaction.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
@import Vsys;
@class VsysToken;

NS_ASSUME_NONNULL_BEGIN

static int64_t const VTimestampMultiple = 1000000000;

@interface Transaction : NSObject

@property (nonatomic, strong) VsysTransaction *originTransaction;

@property (nonatomic, copy) NSString *ownerPublicKey;

@property (nonatomic, copy) NSString *ownerAddress;

@property (nonatomic, copy) NSString *senderAddress;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *comingOutCancelTransaction;

@property (nonatomic, assign) BOOL canCancel;

@property (nonatomic, copy) NSString *direction;

/**
 * 1.sent
 * 2.received
 * 3.start leasing
 * 4.canceled out leasing
 * 5.incoming leasing
 * 6.canceled incoming leasing
 * 8.register contract
 * 9.contract transaction
 */
@property (nonatomic, assign) int transactionType;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *contractFuncName;

@property (nonatomic, copy) NSString *contractId;

@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, assign) int64_t unity;

- (NSString *)getFunctionName:(VsysToken *)token;

@end

NS_ASSUME_NONNULL_END
