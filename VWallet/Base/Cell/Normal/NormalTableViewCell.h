//
//  NormalTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

@import UIKit;
#import "CellItem.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const NormalTableViewCellIdentifier = @"NormalTableViewCell";

@interface NormalTableViewCell : UITableViewCell

- (void)setupCellItem:(CellItem *)item;

@end

NS_ASSUME_NONNULL_END
