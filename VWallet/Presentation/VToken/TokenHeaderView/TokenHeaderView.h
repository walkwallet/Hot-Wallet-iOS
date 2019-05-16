//
//  TokenHeaderView.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface TokenHeaderView : UIView

@property (nonatomic, weak) Account *account;

@end

NS_ASSUME_NONNULL_END
