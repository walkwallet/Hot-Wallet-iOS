//
// AccountTableViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountType.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountTableViewController : UITableViewController

- (instancetype)initWithAccountType:(AccountType)walletType;

@end

NS_ASSUME_NONNULL_END
