//
//  TokenInfoViewController.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class VsysToken;

@interface TokenInfoViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account token:(VsysToken *)token;

@end
