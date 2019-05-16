//
// TransactionTableViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionListType.h"
#import "DateRangeType.h"
@class Transaction;
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionTableViewController : UITableViewController

- (instancetype)initWithListType:(TransactionListType)transactionType transactionArray:(NSArray<Transaction *> *)transactionArray account:(Account *)account;

- (void)setDateRangeType:(DateRangeType)dateRangeType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp;

@end

NS_ASSUME_NONNULL_END
