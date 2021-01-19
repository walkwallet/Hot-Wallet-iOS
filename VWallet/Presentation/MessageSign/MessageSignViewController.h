//
//  MessageSignViewController.h
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

NS_ASSUME_NONNULL_BEGIN

@interface MessageSignViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account;

@end

NS_ASSUME_NONNULL_END
