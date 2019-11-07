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
            case 5: {
                _transactionType = 5;
            } break;
            case 8: {
                _transactionType = 8;
            } break;
            case 9: {
                _transactionType = 9;
            } break;
        }
    }
    return _transactionType;
}

- (NSString *)getFunctionName:(BOOL)split {
    if (split) {
        switch (_originTransaction.funcIdx) {
            case 0:
                return VsysActionSupersede;
            case 1:
                return VsysActionIssue;
            case 2:
                return VsysActionDestroy;
            case 3:
                return VsysActionSplit;
            case 4:
                return VsysActionSend;
            case 5:
                return VsysActionTransfer;
            case 6:
                return VsysActionDeposit;
            case 7:
                return VsysActionWithdraw;
            default:
                return @"transaction.list.type.9";
        }
    }else {
       switch (_originTransaction.funcIdx) {
            case 0:
                return VsysActionSupersede;
            case 1:
                return VsysActionIssue;
            case 2:
                return VsysActionDestroy;
            case 3:
                return VsysActionSend;
            case 4:
                return VsysActionTransfer;
            case 5:
                return VsysActionDeposit;
            case 6:
                return VsysActionWithdraw;
            default:
                return @"transaction.list.type.9";
        }
    }
}

@end
