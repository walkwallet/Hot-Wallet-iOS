//
// TransactionTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "Language.h"
#import "NSString+Decimal.h"
#import "NSString+Asterisk.h"
#import "NSDate+FormatString.h"
#import "Transaction+Extension.h"
@import Vsys;

@interface TransactionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation TransactionTableViewCell

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", _transaction.transactionType]];
    
    if ([_transaction.originTransaction.recipient isEqualToString: _transaction.ownerAddress]) {
        self.addressLabel.text = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
    } else {
        self.addressLabel.text = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
    }
    
    self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ | %@", _transaction.TypeDesc, [NSDate dateWithTimeIntervalSince1970:_transaction.originTransaction.timestamp / VTimestampMultiple].pastTimeFormatString];
    
    NSString *amountStr = [NSString stringWithDecimal:(_transaction.originTransaction.amount * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    if (_transaction.transactionType == 1) {
        amountStr = [@"-" stringByAppendingString:amountStr];
    } else if (_transaction.transactionType == 2) {
        amountStr = [@"+" stringByAppendingString:amountStr];
    }
    self.amountLabel.text = amountStr;
}

@end
