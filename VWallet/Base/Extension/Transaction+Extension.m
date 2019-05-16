
//
//  Transaction+Extension.m
//  Wallet
//
//  All rights reserved.
//

#import "Transaction+Extension.h"
#import "Language.h"
@import Vsys;

@implementation Transaction (Extension)

- (NSString *)TypeDesc {
    /**
     * 1.sent
     * 2.received
     * 3.start leasing
     * 4.canceled out leasing
     * 5.incoming leasing
     * 6.canceled incoming leasing
     */
    switch (self.transactionType) {
        case 1:
            return VLocalize(@"const.transaction.type.send");
        case 2:
            return VLocalize(@"const.transaction.type.receive");
        case 3:
            return VLocalize(@"const.transaction.type.lease.out");
        case 4:
            return VLocalize(@"const.transaction.type.lease.out.cancel");
        case 5:
            return VLocalize(@"const.transaction.type.lease.in");
        case 6:
            return VLocalize(@"const.transaction.type.lease.in.cancel");
        default:
            return @"";
    }
    return @"";
}

@end
