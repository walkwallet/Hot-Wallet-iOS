//
//  UIViewController+Transaction.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Transaction;
@class Account;
@class VsysToken;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Transaction)

- (void)beginTransactionConfirmWithTransaction:(Transaction *)transaction account:(Account *)account;
- (void)beginTransactionConfirmWithTransaction:(Transaction *)transaction account:(Account *)account token:(VsysToken *)token;
- (void)chooseRentalAddress:(NSArray *)dataArr;
@end

NS_ASSUME_NONNULL_END
