//
// TransactionListType.h
//  Wallet
//
//  All rights reserved.
//

#ifndef TransactionListType_h
#define TransactionListType_h

typedef NS_ENUM(NSInteger, TransactionListType) {
    TransactionListTypeAll = 0,
    TransactionListTypePayment,
    TransactionListTypeLease,
    TransactionListTypeCancelLease,
    TransactionListTypeRegisterContract,
    TransactionListTypeExecuteContract,
};

#endif /* TransactionListType_h */
