//
// AccountTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface AccountTableViewCell : UITableViewCell

@property (nonatomic, weak) Account *account;

@end

NS_ASSUME_NONNULL_END
