//
//  Transaction.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
@import Vsys;

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

/**
 * 1.sent
 * 2.received
 * 3.start leasing
 * 4.canceled out leasing
 * 5.incoming leasing
 * 6.canceled incoming leasing
 */
@property (nonatomic, assign) int transactionType;

@end

NS_ASSUME_NONNULL_END
