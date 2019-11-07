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
    NSString *typeDesc = _transaction.TypeDesc;
    NSString *targetAddress = [_transaction.ownerAddress explicitCount:12 maxAsteriskCount:6];
    NSString *amountStr = [NSString stringWithDecimal:[NSString getAccurateDouble:_transaction.originTransaction.amount unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    if (_transaction.transactionType == 1) {
        amountStr = [@"-" stringByAppendingString:amountStr];
    } else if (_transaction.transactionType == 2) {
        amountStr = [@"+" stringByAppendingString:amountStr];
    }
    
    if (_transaction.originTransaction.txType == VsysTxTypeContractRegister) {
        if (![@"Success" isEqualToString:_transaction.status]) {
            self.typeImgView.image = [UIImage imageNamed:@"ico_contract_fail"];
        }else {
            self.typeImgView.image = [UIImage imageNamed:@"ico_contract_register_success"];
        }
    }else if (_transaction.originTransaction.txType == VsysTxTypeContractExecute) {
        if (![@"Success" isEqualToString:_transaction.status]) {
            self.typeImgView.image = [UIImage imageNamed:@"ico_contract_fail"];
        }else {
            if ([NSString isNilOrEmpty:_transaction.contractFuncName]) {
                self.typeImgView.image = [UIImage imageNamed:@"ico_contract_success"];
            }else {
                if ([_transaction.contractFuncName isEqualToString:@"send"]) {
                    if ([_transaction.direction isEqualToString:@"out"]) {
                        self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_1"];
                        amountStr = [@"-" stringByAppendingString:[NSString stringWithDecimal:[NSString getAccurateDouble:_transaction.originTransaction.amount unity:_transaction.unity] maxFractionDigits:9 minFractionDigits:2 trimTrailing:YES]];
                        targetAddress = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
                    }else {
                        self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_2"];
                        amountStr = [@"+" stringByAppendingString:[NSString stringWithDecimal:[NSString getAccurateDouble:_transaction.originTransaction.amount unity:_transaction.unity] maxFractionDigits:9 minFractionDigits:2 trimTrailing:YES]];
                        targetAddress = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
                    }
                    amountStr = [amountStr stringByAppendingString:[NSString stringWithFormat:@" %@", _transaction.symbol]];
                }
                typeDesc = VLocalize(_transaction.contractFuncName);
            }
        }
    }else {
        self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", _transaction.transactionType]];
        // Minting - Receive
        if (_transaction.transactionType == 5) {
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_2"];
        }
        if ([_transaction.originTransaction.recipient isEqualToString: _transaction.ownerAddress]) {
            if ([NSString isNilOrEmpty:_transaction.senderAddress]) {
                targetAddress = [_transaction.ownerAddress explicitCount:12 maxAsteriskCount:6];
            }else {
                targetAddress = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
            }
        } else {
            targetAddress = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
        }
    }
    
    self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ | %@", typeDesc, [NSDate dateWithTimeIntervalSince1970:_transaction.originTransaction.timestamp / VTimestampMultiple].pastTimeFormatString];
    
    self.amountLabel.text = amountStr;
    self.addressLabel.text = targetAddress;
}

@end
