//
// TransactionQrcodeViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionQrcodeViewController : UIViewController

- (instancetype)initWithTransaction:(VsysTransaction *)transaction account:(Account *)account;

@end

NS_ASSUME_NONNULL_END
