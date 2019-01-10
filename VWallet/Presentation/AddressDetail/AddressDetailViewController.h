//
// AddressDetailViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressDetailViewController : UIViewController

@property (nonatomic, assign) BOOL popToRoot;

- (void)updateAccout: (Account *)account;

@end

NS_ASSUME_NONNULL_END
