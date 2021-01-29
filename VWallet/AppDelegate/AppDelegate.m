//
//  AppDelegate.m
//  Wallet
//
//  All rights reserved.
//

#import "AppDelegate.h"
#import "AppState.h"
#import "TouchIDTool.h"
#import "VStoryboard.h"
#import "WalletMgr.h"
#import "PasswordInputViewController.h"
#import "AppDelegate+DismissKeyboard.h"
#import "ApiServer.h"
#import "WindowManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self enableAutoDismissKeyboard];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    
    if (AppState.shareInstance.hasWallet) {
        self.window.rootViewController = VStoryboard.Password.instantiateInitialViewController;
    } else {
        self.window.rootViewController = VStoryboard.Generate.instantiateInitialViewController;
    }
    sleep(1.f);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self auth];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self auth];
}

- (void)auth {
    if (AppState.shareInstance.hasWallet && AppState.shareInstance.autoLockTime > 0) {
        UIViewController *topVC = WindowManager.topViewControllerDismissAlert;
        if ([topVC isKindOfClass:PasswordInputViewController.class]) {
            return;
        }
        PasswordInputViewController *pwdInputVC = [[PasswordInputViewController alloc] initWithResult:^(BOOL success) {
            if (success) {
                [topVC dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        pwdInputVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [topVC presentViewController:pwdInputVC animated:YES completion:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)sendEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];
    if(AppState.shareInstance.autoLockTime > 0) {
        [self performSelector:@selector(update) withObject:nil afterDelay:AppState.shareInstance.autoLockTime == 10 ? 600 : 300];
    }
    [super sendEvent:event];
}

- (void)update {
    NSLog(@"auto lock");
    [self auth];
}

@end
