//
// PasswordSettingsViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordSettingsViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title success:(void(^)(NSString *password))success;

@end

NS_ASSUME_NONNULL_END
