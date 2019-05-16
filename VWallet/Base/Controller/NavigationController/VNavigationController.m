//
//  VNavigationController.m
//  Wallet
//
//  All rights reserved.
//

#import "VNavigationController.h"

#import "UIImage+Color.h"
#import "VColor.h"

@interface VNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation VNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.navigationBar.shadowImage = UIImage.new;
    self.navigationBar.translucent = NO;
    self.colorStyle = self.colorStyle;
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"ico_navi_back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"ico_navi_back"];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.orangeColor}
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.orangeColor}
     forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.textSecondColor}
     forState:UIControlStateDisabled];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)setColorStyle:(int)colorStyle {
    _colorStyle = abs(colorStyle) % 3;
    switch (_colorStyle) {
        case 0:
            [self changeToWhiteNavigationBar];
            break;
        case 1:
            [self changeToGrayNavigationBar];
            break;
        case 2:
            [self changeToThemeNavigationBar];
            break;
    }
}

- (void)changeToWhiteNavigationBar {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : VColor.textColor};
    self.navigationBar.tintColor = VColor.navigationTintColor;
    self.navigationBar.backgroundColor = UIColor.whiteColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)changeToGrayNavigationBar {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : VColor.textColor};
    self.navigationBar.tintColor = VColor.navigationTintColor;
    self.navigationBar.backgroundColor = VColor.navigationGrayBgColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:VColor.navigationGrayBgColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)changeToThemeNavigationBar {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    self.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationBar.backgroundColor = VColor.themeColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:VColor.themeColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count;
    self.viewControllers.lastObject.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.viewControllers count] > 1;
}

@end
