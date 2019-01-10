//
//  Transaction.m
//  Wallet
//
//  All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

/**
 * 1.sent
 * 2.received
 * 3.start leasing
 * 4.canceled out leasing
 * 5.incoming leasing
 * 6.canceled incoming leasing
 */
- (int)transactionType {
    if (!_transactionType) {
        switch (self.originTransaction.txType) {
            case 2: {
                _transactionType = [self.ownerAddress isEqualToString:self.originTransaction.recipient] ? 2 : 1;
            } break;
            case 3: {
                _transactionType = [self.ownerAddress isEqualToString:self.originTransaction.recipient] ? 5 : 3;
            } break;
            case 4: {
                _transactionType = [self.ownerAddress isEqualToString:self.originTransaction.recipient] ? 6 : 4;
            } break;
            case 5: {   // mining → received
                _transactionType = 2;
            }
        }
    }
    return _transactionType;
}

@end
