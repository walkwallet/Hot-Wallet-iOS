//
// TransactionQrcodeViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@class Transaction;
@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionQrcodeViewController : UIViewController

- (instancetype)initWithTransaction:(Transaction *)transaction account:(Account *)account;

- (instancetype)initWithOriginTransaction:(VsysTransaction *)transaction account:(Account *)account;

@end

NS_ASSUME_NONNULL_END
