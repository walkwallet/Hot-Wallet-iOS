//
// PasswordAuthAlertViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordInput.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordAuthAlertViewController : UIViewController

- (instancetype)initWithModel:(PasswordInput *)model;

- (void)showPasswordAlert:(UIViewController *)rootVc result:(void(^ __nullable)(BOOL success))result;

@end

NS_ASSUME_NONNULL_END
