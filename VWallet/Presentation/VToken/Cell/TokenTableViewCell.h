//
//  TokenTableViewCell.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Token;

NS_ASSUME_NONNULL_BEGIN

@interface TokenTableViewCell : UITableViewCell

@property (nonatomic, strong) Token *token;

@end

NS_ASSUME_NONNULL_END
