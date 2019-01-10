//
// TransactionDetailViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class Transaction;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionDetailViewController : UIViewController

@property (nonatomic, assign) BOOL isDetailPage;

- (instancetype)initWithTransaction:(Transaction *)transaction account:(Account *)account;

@end

NS_ASSUME_NONNULL_END
