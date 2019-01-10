//
// TransactionRecordsPageViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class Transaction;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionRecordsPageViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account transationArray:(NSArray<Transaction *> *)transactionArray;

@end

NS_ASSUME_NONNULL_END
