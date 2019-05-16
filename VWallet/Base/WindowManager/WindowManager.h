//
//  WindowManager.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowManager : NSObject

+ (void)changeToRootViewController:(UIViewController *)viewController;

+ (UIViewController *)topViewController;

+ (UIViewController *)topViewControllerDismissAlert;

@end

NS_ASSUME_NONNULL_END
