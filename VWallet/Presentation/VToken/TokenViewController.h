//
//  TokenViewController.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface TokenViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account;

@end

NS_ASSUME_NONNULL_END
