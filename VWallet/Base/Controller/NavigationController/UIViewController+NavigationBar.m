//
//  UIViewController+NavigationBar.m
//  Wallet
//
//  All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "VNavigationController.h"

@implementation UIViewController (NavigationBar)

- (void)changeToWhiteNavigationBar {
    if ([self.navigationController isKindOfClass:VNavigationController.class]) {
        ((VNavigationController *)self.navigationController).colorStyle = 0;
    }
}

- (void)changeToGrayNavigationBar {
    if ([self.navigationController isKindOfClass:VNavigationController.class]) {
        ((VNavigationController *)self.navigationController).colorStyle = 1;
    }
}

- (void)changeToThemeNavigationBar {
    if ([self.navigationController isKindOfClass:VNavigationController.class]) {
        ((VNavigationController *)self.navigationController).colorStyle = 2;
    }
}

@end
