//
//  WindowManager.m
//  Wallet
//
//  All rights reserved.
//

#import "WindowManager.h"
#import "AppDelegate.h"

@implementation WindowManager

+ (void)changeToRootViewController:(UIViewController *)viewController {
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    UIViewController *currentRootVC = appDelegate.window.rootViewController;
    if ([currentRootVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *naviVC = (UINavigationController *)currentRootVC;
        if (naviVC.childViewControllers.count > 1) {
            [naviVC popToRootViewControllerAnimated:NO];
        }
    }
    
    for (UIView *subView in appDelegate.window.rootViewController.view.subviews) {
        [subView removeFromSuperview];
    }
    [appDelegate.window.rootViewController.view removeFromSuperview];
    
    if (currentRootVC.presentingViewController) {
        [currentRootVC.presentingViewController dismissViewControllerAnimated:NO completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                appDelegate.window.rootViewController = viewController;
            });
        }];
    } else {
        appDelegate.window.rootViewController = viewController;
    }
}

+ (UIViewController *)topViewController {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    UIViewController *viewController = window.rootViewController;
    while (YES) {
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else if ([viewController isKindOfClass:UINavigationController.class]) {
            viewController = ((UINavigationController *)viewController).topViewController;
        } else if ([viewController isKindOfClass:UITabBarController.class]) {
            viewController = ((UITabBarController *)viewController).selectedViewController;
        } else {
            break;
        }
    }
    return viewController;
}

+ (UIViewController *)topViewControllerDismissAlert {
    UIViewController *topViewController = WindowManager.topViewController;
    if ([topViewController isKindOfClass:UIAlertController.class]) {
        topViewController = topViewController.presentingViewController;
        [topViewController dismissViewControllerAnimated:NO completion:nil];
    }
    return topViewController;
}

@end
