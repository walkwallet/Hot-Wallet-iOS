//
//  UIViewController+ColdWalletTransaction.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Transaction;
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ColdWalletTransaction)

- (void)coldWalletSendTransactionWithTransation:(Transaction *)transaction account:(Account *)account;

@end

NS_ASSUME_NONNULL_END
