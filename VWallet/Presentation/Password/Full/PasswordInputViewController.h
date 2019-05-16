//
// PasswordInputViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordInputViewController : UIViewController

- (instancetype)initWithResult:(void(^)(BOOL success))result;

@end

NS_ASSUME_NONNULL_END
