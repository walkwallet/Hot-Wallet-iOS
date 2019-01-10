//
// TransactionTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Transaction;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, weak) Transaction *transaction;

@end

NS_ASSUME_NONNULL_END
