//
//  VTabBarController.m
//  Wallet
//
//  All rights reserved.
//

#import "VTabBarController.h"

#import "Language.h"
#import "VColor.h"
#import "UIImage+Color.h"

@interface VTabBarController ()

@end

@implementation VTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)setupTabBar {
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = VColor.tabbarTintColor;
    self.tabBar.shadowImage = UIImage.new;
    self.tabBar.backgroundImage = [UIImage imageWithColor:VColor.tabbarBgColor];
    self.tabBar.layer.shadowColor = VColor.shadowColor.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -4.f);
    self.tabBar.layer.shadowRadius = 12.f;
    self.tabBar.layer.shadowOpacity = 0.04f;
    
    for (int i = 0; i < self.viewControllers.count ; i++) {
        UITabBarItem *item = [self.viewControllers[i] tabBarItem];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        NSString *key = [NSString stringWithFormat:@"tabbar.title.%d", i];
        [item setTitle:VLocalize(key)];
    }
}

@end
