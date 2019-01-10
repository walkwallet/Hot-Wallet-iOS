//
//  SwitchTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

@import UIKit;
#import "CellItem.h"
#import "VTableViewCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const SwitchTableViewCellIdentifier = @"SwitchTableViewCell";


@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, weak) id<VTableViewCellDelegate> delegate;

- (void)setupCellItem:(CellItem *)item;

@end

NS_ASSUME_NONNULL_END
