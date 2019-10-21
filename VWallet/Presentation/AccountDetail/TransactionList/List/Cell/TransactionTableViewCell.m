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
    if (_transaction.originTransaction.txType == VsysTxTypeContractRegister ||
        _transaction.originTransaction.txType == VsysTxTypeContractExecute) {
        if (![@"Success" isEqualToString:_transaction.status]) {
            self.typeImgView.image = [UIImage imageNamed:@"ico_contract_fail"];
        }else {
            if (_transaction.originTransaction.txType == VsysTxTypeContractRegister) {
                self.typeImgView.image = [UIImage imageNamed:@"ico_contract_register_success"];
            }else {
                self.typeImgView.image = [UIImage imageNamed:@"ico_contract_success"];
            }
        }
        self.addressLabel.text = [_transaction.ownerAddress explicitCount:12 maxAsteriskCount:6];
    }else {
        self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", _transaction.transactionType]];
        // Minting - Receive
        if (_transaction.transactionType == 5) {
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_2"];
        }
        if ([_transaction.originTransaction.recipient isEqualToString: _transaction.ownerAddress]) {
            if ([NSString isNilOrEmpty:_transaction.senderAddress]) {
                self.addressLabel.text = [_transaction.ownerAddress explicitCount:12 maxAsteriskCount:6];
            }else {
                self.addressLabel.text = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
            }
        } else {
            self.addressLabel.text = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
        }
    }

    self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ | %@", _transaction.TypeDesc, [NSDate dateWithTimeIntervalSince1970:_transaction.originTransaction.timestamp / VTimestampMultiple].pastTimeFormatString];

    NSString *amountStr = [NSString stringWithDecimal:[NSString getAccurateDouble:_transaction.originTransaction.amount unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    if (_transaction.transactionType == 1) {
        amountStr = [@"-" stringByAppendingString:amountStr];
    } else if (_transaction.transactionType == 2) {
        amountStr = [@"+" stringByAppendingString:amountStr];
    }
    self.amountLabel.text = amountStr;
}

@end
