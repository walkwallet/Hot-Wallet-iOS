//
//  TokenInfoViewController.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class Token;

@interface TokenInfoViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account token:(Token *)token;

@end
