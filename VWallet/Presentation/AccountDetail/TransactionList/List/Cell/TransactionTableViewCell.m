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
    if (transaction.originTransaction.txType == VsysTxTypeContractRegister || transaction.originTransaction.txType == VsysTxTypeContractExecute) {
        amountStr = [NSString stringWithDecimal:[NSString getAccurateDouble:_transaction.originTransaction.fee unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    }
    if ([transaction.direction isEqualToString:@"out"]) {
        amountStr = [@"-" stringByAppendingString:amountStr];
    }else if ([transaction.direction isEqualToString:@"in"]) {
        amountStr = [@"+" stringByAppendingString:amountStr];
    }
    
    if ([transaction.senderAddress isEqualToString:transaction.originTransaction.recipient]) {
        if ([transaction.direction isEqualToString:@"out"]) {
            typeDesc = VLocalize(@"const.transaction.type.send");
        }else if ([transaction.direction isEqualToString:@"in"]) {
            typeDesc = VLocalize(@"const.transaction.type.receive");
        }
    }

    if (_transaction.originTransaction.txType == VsysTxTypePayment) {
        if ([transaction.direction isEqualToString:@"out"]) {
            self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", 1]];
        }else if ([transaction.direction isEqualToString:@"in"]){
            self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", 2]];
        }else {
            self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", _transaction.transactionType]];
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
    }else if (_transaction.originTransaction.txType == VsysTxTypeLease){
        if ([self.transaction.originTransaction.recipient isEqualToString:self.transaction.ownerAddress]){
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_5"];
            targetAddress = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
        }else {
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_3"];
            targetAddress = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
        }
    }else if (_transaction.originTransaction.txType == VsysTxTypeCancelLease) {
       if ([self.transaction.originTransaction.recipient isEqualToString:self.transaction.ownerAddress]){
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_6"];
            targetAddress = [_transaction.senderAddress explicitCount:12 maxAsteriskCount:6];
        }else {
            self.typeImgView.image = [UIImage imageNamed:@"ico_transaction_type_4"];
            targetAddress = [_transaction.originTransaction.recipient explicitCount:12 maxAsteriskCount:6];
        }
    }else if (_transaction.originTransaction.txType == VsysTxTypeContractRegister) {
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
                    amountStr = [amountStr stringByAppendingString:[NSString stringWithFormat:@" %@", [NSString isNilOrEmpty: _transaction.symbol] ? @"": _transaction.symbol]];
                }
                typeDesc = VLocalize(_transaction.contractFuncName);
            }
        }
    }else {
        self.typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_transaction_type_%d", _transaction.transactionType]];
        // Minting - Receive
        if (_transaction.transactionType == 7) {
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
