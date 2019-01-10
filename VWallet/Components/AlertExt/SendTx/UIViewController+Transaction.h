//
//  UIViewController+Transaction.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Transaction;
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Transaction)

- (void)beginTransactionConfirmWithTransaction:(Transaction *)transaction account:(Account *)account;

@end

NS_ASSUME_NONNULL_END
